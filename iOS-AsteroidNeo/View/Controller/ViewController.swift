//
//  ViewController.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit

class ViewController: UIViewController, DatePickerTextFieldDelegate {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startDateTF: DatePickerTextField!
    @IBOutlet weak var endDateTF: DatePickerTextField!
    @IBOutlet weak var totalCountLbl: UILabel!
    @IBOutlet weak var filteredCountLbl: UILabel!
    @IBOutlet weak var commonView: UIView!
    @IBOutlet weak var viewChartBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var clearBtn: UIButton!
    
    //MARK: variables
    var viewModels = ViewModel()
    var chartDataWithEachDate: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Call setupUI method
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: Setup custom Nib and called delegates
    func setupUI(){
        commonView.isHidden = true
        viewModels.registerNib(for: tableView)
        startDateTF.datePickerDelegate = self
        endDateTF.datePickerDelegate = self
        viewModelMethodCalledBasedPropertyUpdate()
    }
    
    //MARK: delegate method of datepicker selection
    func datePickerTextFieldDidSelectDate(date: Date, textField: UITextField){
        if textField == startDateTF {
            hideShowClearBtnBasedOnFieldValue(text: textField.text)
        }else if textField == endDateTF {
            hideShowClearBtnBasedOnFieldValue(text: textField.text)
        }else{
            print("not matched")
        }
    }
    
    //MARK: method for clear button hide and show based on textfield text
    func hideShowClearBtnBasedOnFieldValue(text: String?){
        if text != "" {
            clearBtn.isHidden = false
        }else{
            clearBtn.isHidden = true
        }
    }
    
    //MARK: method for viewmodel custom closure based on update property
    func viewModelMethodCalledBasedPropertyUpdate(){
        //closure called when tap on list index, it will redirect to Detail screen
        viewModels.navigateToAsteroidDetail = { [weak self] _asteroidData, _asteroidCollection in
            guard let self = self else {return}
            //navigation method called
            self.navigateToDetailVC(data: _asteroidData, asteroidWithEachDate: self.chartDataWithEachDate, isChartTapped: false)
        }
        
        //MARK: ViewModel Closure called when api response success and count is updated in computed property
        viewModels.updateCounts = { [weak self] totalElementCount, filteredTotalCount in
            guard let self = self else {return}
            self.totalCountLbl.text = "Total Count: \(filteredTotalCount)"
            self.filteredCountLbl.text = "Filterd Count: \(totalElementCount)"
            self.commonView.isHidden = false
        }
        
        //MARK: ViewModel Closure called when api response filterd based on date
        viewModels.updateChartData = { [weak self] updatedChartData in
            guard let self = self else {return}
            self.chartDataWithEachDate = updatedChartData
        }
        
        //MARK: ViewModel Closure called when response in progress or completed
        viewModels.updateLoadingStatus = { [weak self] isShow in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loadingState(_isShow: isShow)
            }
        }
    }
    
    //MARK: Method for show hide loader
    func loadingState(_isShow: Bool){
        if _isShow {
            Loader.shared.showLoader(self.view)
            self.userIneractionOffWhileLoading(isEnabled: _isShow)
        }else{
            Loader.shared.hideLoader()
            self.userIneractionOffWhileLoading(isEnabled: _isShow)
        }
    }
    
    //MARK: Method for handling UI intreaction based on loader activity
    func userIneractionOffWhileLoading(isEnabled: Bool){
        if isEnabled {
            bgImage.alpha = 0.85
            startDateTF.isUserInteractionEnabled = false
            endDateTF.isUserInteractionEnabled = false
            submitBtn.isUserInteractionEnabled = false
            viewChartBtn.isUserInteractionEnabled = false
            tableView.isUserInteractionEnabled = false
            clearBtn.isUserInteractionEnabled = false
        }else{
            bgImage.alpha = 1.0
            startDateTF.isUserInteractionEnabled = true
            endDateTF.isUserInteractionEnabled = true
            submitBtn.isUserInteractionEnabled = true
            viewChartBtn.isUserInteractionEnabled = true
            tableView.isUserInteractionEnabled = true
            clearBtn.isUserInteractionEnabled = true
        }
    }
    
    //submit button action
    @IBAction func submitBtnAction(_ sender: UIButton){
        guard let date1 = startDateTF.text, let date2 = endDateTF.text else {return}
        if date1 != "" && date2 != "" {
            updateDateAlert(start: date1, end: date2, dateS: startDateTF.datePicker.date, dateE: endDateTF.datePicker.date)
        }else{
            if let alert = viewModels.checkFieldEmpty(isEmpty: true) {
                alert.show(on: self)
            }
        }
    }
    
    //MARK: Show alert for date validation
    func updateDateAlert(start: String, end: String, dateS: Date?, dateE: Date?){
        guard let unwrapStart = dateS, let unwrapEnd = dateE else {return}
        guard let dateAlert = viewModels.checkStartAndEndDateIf(_start: start, _end: end, _dateS: unwrapStart, _dateE: unwrapEnd) else {return}
        if dateAlert.title == "validDate" {
            fetchData(startDateText: start, endDateText: end)
        }else{
            dateAlert.show(on: self)
        }
    }
    
    //MARK: setup method for start and end date
    func fetchData(startDateText: String, endDateText: String){
        //call viewmodel fetchdata method
        viewModels.fetchData(_startDate: startDateText, _endDate: endDateText) { [weak self] (_nasaResponse) in
            guard let self = self else {return}
            guard let safeResponse = _nasaResponse else {return}
            if safeResponse.elementCount == nil && safeResponse.nearEarthObjects == nil {
                //show alret based on api response
                if let alert = self.viewModels.isFailureResponse(_isError: true) {
                    DispatchQueue.main.async {
                        alert.show(on: self)
                    }
                }
            }else{
                self.viewModels.filterDataBasedOnStats(tableView: self.tableView, startDateText: startDateText, endDateText: endDateText, nasaResponse: safeResponse)
            }
        }
    }
    
    //MARK: Setup method for navigate to screen based on button selection
    func navigateToDetailVC(data: AsteroidDataModelWithDate.NearEarthObject?, asteroidWithEachDate: [String: Int], isChartTapped: Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Check if chart button tap the navigate to chart screen
        if isChartTapped{
            if let barVC = storyboard.instantiateViewController(withIdentifier: "BarVC") as? BarVC {
                barVC.asteroidWithEachDate = chartDataWithEachDate
                self.navigationController?.pushViewController(barVC, animated: true)
            }
        }else{
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "AsteroidDetailVC") as? AsteroidDetailVC {
                detailVC.asteroidData = data
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    //chart button action
    @IBAction func viewChartBtnAction(_ sender: UIButton){
        navigateToDetailVC(data: nil, asteroidWithEachDate: [:], isChartTapped: true)
    }
    
    //clear text field button action
    @IBAction func clearFieldsBtnAction(_ sender: UIButton){
        startDateTF.text = ""
        endDateTF.text = ""
        clearBtn.isHidden = true
    }
}
