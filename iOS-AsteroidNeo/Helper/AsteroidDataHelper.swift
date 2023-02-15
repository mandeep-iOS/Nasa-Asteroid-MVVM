//
//  AsteroidDataHelper.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import Foundation

//MARK: AsteroidDataHelper class used for filter, calculated size or count - class will get argument based on requirement and update data to other function accordingly
class AsteroidDataHelper {
    
    static func filterData(filterCloset: [FilterdAsteroidModel], filterFastest: [FilterdAsteroidModel], getData: [AsteroidDataModelWithDate.NearEarthObject]) -> (fastestArr: [AsteroidDataModelWithDate.NearEarthObject], closetArr: [AsteroidDataModelWithDate.NearEarthObject], averageArr: [AsteroidDataModelWithDate.NearEarthObject]){
        
        var filteredFastestData: [AsteroidDataModelWithDate.NearEarthObject] = []
        var filteredClosetData: [AsteroidDataModelWithDate.NearEarthObject] = []
        var filteredAverageData: [AsteroidDataModelWithDate.NearEarthObject] = []
        //  let idsToFilter = Set(filterCloset.map { $0.asteroidID } + filterFastest.map { $0.asteroidID })
        let fastestToFilter = filterFastest.map { $0.asteroidID }
        let closetToFilter = filterCloset.map { $0.asteroidID }
        
        for data in getData {
            if fastestToFilter.contains(data.id ?? "") {
                filteredFastestData.append(data)
            }else if closetToFilter.contains(data.id ?? ""){
                filteredClosetData.append(data)
            }else{
                filteredAverageData.append(data)
            }
        }
        
        return (filteredFastestData, filteredClosetData, filteredAverageData)
    }
    
    static func calculateTwoDate(startDate: String, endDate: String, from data: [String: [AsteroidDataModelWithDate.NearEarthObject]]) -> [AsteroidDataModelWithDate.NearEarthObject] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let start = dateFormatter.date(from: startDate)!
        let end = dateFormatter.date(from: endDate)!
        let dates = Array(data.keys).sorted(by: { dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)! })
        let objects = dates
            .filter({ dateFormatter.date(from: $0)! >= start && dateFormatter.date(from: $0)! <= end })
            .flatMap({ data[$0]! })
        
        return objects
    }
    
    static func averageSize(_data: AsteroidDataModelWithDate.NearEarthObject) -> Double {
        var totalSize = 0.0
        var count = 0
        if let size = _data.estimatedDiameter?.kilometers?.estimatedDiameterMax {
            totalSize += size
            count += 1
        }
        return totalSize / Double(count)
    }
    
    static func calculateAsteroidsCount(startDate: String, endDate: String, nearEarthObjects: [String: [AsteroidDataModelWithDate.NearEarthObject]]) -> [String: Int] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let startDateObject = formatter.date(from: startDate),
              let endDateObject = formatter.date(from: endDate) else {
            print("Invalid date format.")
            return [:]
        }
        var asteroidCountByDate = [String: Int]()
        for (dateString, dateArray) in nearEarthObjects {
            guard let date = formatter.date(from: dateString) else {
                continue
            }
            if date >= startDateObject && date <= endDateObject {
                asteroidCountByDate[dateString] = dateArray.count
            }
        }
        return asteroidCountByDate
    }
    
}
