//
//  BarVC.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit
import Charts

class BarVC: UIViewController, ChartViewDelegate {
    //MARK: Outlets
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    //MARK: Variable & Constants
    let customMarkerView = CustomMarkerView()
    var items = [AsteroidItem]()
    let asteroidHigh = 25.0
    let asteroidAverage = 15.0
    var asteroidWithEachDate: [String: Int] = [:]
    private var rawData = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //MARK: call getDataMethod
        getDataAndConvertIntoChartData()
    }
    
   @IBAction func backBtnAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: setup and filter data based on dates for chart
    func getDataAndConvertIntoChartData(){
        if asteroidWithEachDate.count > 0 {
            for date in asteroidWithEachDate.keys.sorted() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let dateObject = dateFormatter.date(from: date) {
                    dateFormatter.dateFormat = "MMM dd"
                    let dateString = dateFormatter.string(from: dateObject)
                    if let count = asteroidWithEachDate[date] {
                        rawData.append("\(dateString), \(count)")
                    }
                }
            }
        }
        if rawData.count > 0 {
            noDataLbl.isHidden = true
            infoLbl.isHidden = false
            setupChartWithData()
        }else{
            noDataLbl.isHidden = false
            infoLbl.isHidden = true
        }
    }
    
    //MARK: Setup filter data over chart
    func setupChartWithData() {
        items = ChartHelper.getFormattedItemValue(rawData)
        ChartHelper.setupDataWithChart(chartView: self.chartView, items: self.items, rawData: self.rawData, asteroidHigh: self.asteroidHigh, asteroidAverage: self.asteroidAverage, delegate: self)
        //MARK: Call Setup custom marker
        setupMarker()
        
    }
    
    //MARK: Setup custom marker on chart
    func setupMarker() {
        customMarkerView.chartView = chartView
        chartView.marker = customMarkerView
    }
    
    // MARK: - Chart Methods
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        let entryIndex = dataSet.entryIndex(entry: entry)
        customMarkerView.rateLabel.text = "\(items[entryIndex].asteroidRate)"
        customMarkerView.countryLabel.text = items[entryIndex].dates
    }
}
