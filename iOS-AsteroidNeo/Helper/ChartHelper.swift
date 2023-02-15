//
//  ChartHelper.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit
import Charts

//MARK: Strcutre for handling Bar char entry
struct AsteroidItem {
    let index: Int
    let dates: String
    let asteroidRate: Double
    
    func transformToBarChartDataEntry() -> BarChartDataEntry {
        let entry = BarChartDataEntry(x: Double(index), y: asteroidRate)
        return entry
    }
}

//MARK: BarValueFormatter for setup ValueFormatter on Bar char
class BarValueFormatter: ValueFormatter {

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.2f", value)
    }
}

//MARK: ChartHelper class used - get argument based on requirement and updateChart data and UI accordingly
class ChartHelper {
   static func getFormattedItemValue(_ rawValues: [String]) -> [AsteroidItem] {
        var items = [AsteroidItem]()
        var index = 0
        for i in rawValues {
            let valuePair = i.components(separatedBy: ", ")
            let dates = valuePair[0]
            let asteroidRateStr = valuePair[1]
            let asteroidRate = Double(asteroidRateStr) ?? 0.0
            items.append(AsteroidItem(index: index, dates: dates, asteroidRate: asteroidRate))
            index += 1
        }
        return items
    }
   
    static func setupDataWithChart(chartView: BarChartView,items: [AsteroidItem], rawData: [String], asteroidHigh: Double, asteroidAverage: Double, delegate: ChartViewDelegate?){
       //Setup Data
        let dataEntries = items.map{ $0.transformToBarChartDataEntry() }
        let set1 = BarChartDataSet(entries: dataEntries)
        set1.setColor(.chartBarColour)
        set1.highlightColor = .chartHightlightColour
        set1.highlightAlpha = 1
        let data = BarChartData(dataSet: set1)
        data.setDrawValues(true)
        data.setValueTextColor(.chartLineColour)
        let barValueFormatter = BarValueFormatter()
        data.setValueFormatter(barValueFormatter)
        chartView.data = data
       //InitChart
       chartView.setCornerRadius(radius: 10, borderColor: .chartLineColour)
        chartView.delegate = delegate
       chartView.highlightPerTapEnabled = true
       chartView.highlightFullBarEnabled = true
       chartView.highlightPerDragEnabled = false
       chartView.pinchZoomEnabled = false
       chartView.setScaleEnabled(false)
       chartView.doubleTapToZoomEnabled = false
       chartView.drawBarShadowEnabled = false
       chartView.drawBordersEnabled = false
       chartView.drawGridBackgroundEnabled = false
       chartView.animate(yAxisDuration: 3.0 , easingOption: .easeOutBounce)//.easeOutBounce)
       chartView.legend.enabled = false
       chartView.borderColor = .chartLineColour
       chartView.setExtraOffsets(left: 10, top: 0, right: 20, bottom: 62)
       // Setup X axis
       let xAxis = chartView.xAxis
       xAxis.labelPosition = .bottom
       xAxis.drawAxisLineEnabled = true
       xAxis.drawGridLinesEnabled = false
       xAxis.granularityEnabled = false
       xAxis.labelRotationAngle = -25
       xAxis.setLabelCount(rawData.count, force: false)
       xAxis.valueFormatter = IndexAxisValueFormatter(values: items.map { $0.dates })
       xAxis.axisMaximum = Double(rawData.count)
       xAxis.axisLineColor = .chartLineColour
       xAxis.labelTextColor = .chartLineColour
       // Setup left axis
       let leftAxis = chartView.leftAxis
       leftAxis.drawTopYLabelEntryEnabled = true
       leftAxis.drawAxisLineEnabled = true
       leftAxis.drawGridLinesEnabled = true
       leftAxis.granularityEnabled = false
       //        leftAxis.granularity = 1
       leftAxis.axisLineColor = .chartLineColour
       leftAxis.labelTextColor = .chartLineColour
       leftAxis.setLabelCount(7, force: false)
       leftAxis.axisMinimum = 0.0
       leftAxis.axisMaximum = 30
       // Remove right axis
       let rightAxis = chartView.rightAxis
       rightAxis.enabled = false
       let replacementRateLine = ChartLimitLine()
       replacementRateLine.limit = asteroidHigh
       replacementRateLine.lineColor = .chartReplacementColour
       replacementRateLine.valueTextColor = .chartReplacementColour
       replacementRateLine.label = "High : \(asteroidHigh)"
       replacementRateLine.labelPosition = .leftTop
       leftAxis.addLimitLine(replacementRateLine)
       let highIncomeAverageLine = ChartLimitLine()
       highIncomeAverageLine.limit = asteroidAverage
       highIncomeAverageLine.lineColor = .chartAverageColour
       highIncomeAverageLine.valueTextColor = .chartAverageColour
       highIncomeAverageLine.label = "Average : \(asteroidAverage)"
       highIncomeAverageLine.labelPosition = .leftBottom
       leftAxis.addLimitLine(highIncomeAverageLine)
    }
}
