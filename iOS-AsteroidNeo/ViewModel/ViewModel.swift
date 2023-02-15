//
//  ViewModel.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit

class ViewModel {
    
    //MARK: Constants and variables
    let nib = UINib(nibName: "AsteroidTableCell", bundle: nil)
    let headerArray = ["Fastest Asteroid", "Closest Asteroid"]
    var data = [String: Any]()
    private var tableDataSource: TableGenricDataSource<AsteroidTableCell, AsteroidDataModelWithDate.NearEarthObject, [String: Any]>!

    //MARK: Closures
    var updateLoadingStatus: ((Bool) -> Void)?
    var updateChartData: (([String: Int]) -> Void)?
    var updateCounts: ((Int, Int) -> Void)?
    var navigateToAsteroidDetail: (AsteroidDataModelWithDate.NearEarthObject, AsteroidDataModelWithDate) -> () = { _,_  in }
    
    //MARK: Computed property
    var isLoading :Bool = false {
        didSet {
            self.updateLoadingStatus?(self.isLoading)
        }
    }
    
    var getChartDataValue: [String: Int] = [:] {
        didSet{
            self.updateChartData?(self.getChartDataValue)
        }
    }
    
    var filteredCount: Int = 0 {
        didSet {
            self.updateCounts?(self.filteredCount, self.totalCount)
        }
    }
    
    var totalCount: Int = 0 {
        didSet {
            self.updateCounts?(self.filteredCount, self.totalCount)
        }
    }
    
    //MARK: Method for fetch data and update into DataModel
    func fetchData(_startDate: String, _endDate: String, completion : @escaping (AsteroidDataModelWithDate?) -> ()){
        isLoading = true
        //called Apiservice class fetchdata method for get api data
        APIService.shared.fetchData(startDate: _startDate, endDate: _endDate) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                if let inital = try? AsteroidDataModelWithDate.init(data: data){
                    completion(inital)
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    //MARK: Method for setup tableview cell
    func registerNib(for tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: "AsteroidTableCell")
    }
    
    //MARK: Filter Api data based on fastest and closet Asteroid data
    func filterDataBasedOnStats(tableView: UITableView,startDateText: String, endDateText: String, nasaResponse: AsteroidDataModelWithDate) {
        
        let filterFastest = nasaResponse.fastestAsteroidArr()
        let filterCloset = nasaResponse.closestAsteroidArr()
        
        guard let unwrapNearObj = nasaResponse.nearEarthObjects else {return}
        //AsteroidDataHelper method for calculate data count for update total and filter count
        getChartDataValue = AsteroidDataHelper.calculateAsteroidsCount(startDate: startDateText, endDate: endDateText, nearEarthObjects: unwrapNearObj)
        
        //AsteroidDataHelper method for calculate data based on start and end date
        let getNearObjCalculatedData = AsteroidDataHelper.calculateTwoDate(startDate: startDateText, endDate: endDateText, from: unwrapNearObj)
        
        //AsteroidDataHelper method for handling fastClose asteroid data collection
        let getFastCloseDataCollection =  AsteroidDataHelper.filterData(filterCloset: filterCloset, filterFastest: filterFastest, getData: getNearObjCalculatedData)
        
        let fastArr = getFastCloseDataCollection.fastestArr
        let closeArr = getFastCloseDataCollection.closetArr
        
        let itemsSectionRow: [[AsteroidDataModelWithDate.NearEarthObject]] = [fastArr, closeArr]
       
        for (index, value) in itemsSectionRow.enumerated() {
            data[headerArray[index]] = value
        }
        
        DispatchQueue.main.async { [weak self] in
            //updatedata on table veiw method called
            self?.updateDataOnTableView(_tableView: tableView, _itemsSectionRow: itemsSectionRow, _headerArray: self?.headerArray ?? [], _nasaResponse: nasaResponse, filterDataCount: fastArr.count + closeArr.count)
        }
        
    }
    
    //MARK: Update closet and fastest asteroiod data on table view
    func updateDataOnTableView(_tableView: UITableView,_itemsSectionRow: [[AsteroidDataModelWithDate.NearEarthObject]], _headerArray: [String], _nasaResponse: AsteroidDataModelWithDate, filterDataCount: Int){
        
        //Generic method called for updating table cell values
        self.tableDataSource = TableGenricDataSource(cellIdentifier: "AsteroidTableCell", items: _itemsSectionRow, headers: headerArray, someData: data, configureCell: { cell, cellData in
            cell.setCellData(cellData: cellData)
        })
        
        //update total count
        totalCount = _nasaResponse.elementCount ?? 0
        filteredCount = filterDataCount
        
        if #available(iOS 15.0, *) {
            _tableView.sectionHeaderTopPadding = 0
        }else{
            _tableView.tableFooterView = UIView()
        }
        
        _tableView.dataSource = self.tableDataSource
        _tableView.reloadData()
        _tableView.delegate = self.tableDataSource
        
        //closure called when tap on table index
        self.tableDataSource?.didSelectRow = { [weak self] cellData in
            self?.navigateToAsteroidDetail(cellData, _nasaResponse)
        }
    }
 
}

//ViewModel Delegate Extention
extension ViewModel{
    //MARK: Did select Row Method for get table index data
    func didSelectRowAt(tableView: UITableView, completion: ((AsteroidDataModelWithDate.NearEarthObject) -> Void)?) {
        tableDataSource?.didSelectRow = { asteroid in
            completion?(asteroid)
        }
        tableView.delegate = self.tableDataSource
    }
}

//ViewModel Validation Extention
extension ViewModel{
    //MARK: Method for present alert when api response failed
    func isFailureResponse(_isError: Bool) -> CustomAlert? {
        return AlertError.responseError.rawValue
    }
    
    //MARK: check distance between two dates
    func checkStartAndEndDateIf(_start: String, _end: String, _dateS: Date, _dateE: Date) -> CustomAlert?{
        let sevenDaysAfterStartDate = Calendar.current.date(byAdding: .day, value: 7, to: _dateS)
        if _end < _start {
            return AlertError.endDateLessThanStartDate.rawValue
        }else if _dateE > sevenDaysAfterStartDate!{
            return AlertError.endDateMoreThan7DaysAfterStartDate.rawValue
        }else{
            return AlertError.dateValidSuccess.rawValue
        }
    }
    
    //MARK: check if fields are empty
    func checkFieldEmpty(isEmpty: Bool) -> CustomAlert? {
        if isEmpty {
            return AlertError.emptyField.rawValue
        }else{
            return nil
        }
    }
}
