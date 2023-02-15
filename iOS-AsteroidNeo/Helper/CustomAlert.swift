//
//  CustomAlert.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//


import UIKit
import Charts

//MARK: Custom Class Alert for based on validation of rquired alert in function
struct CustomAlert: RawRepresentable {
    let title: String
    let message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    typealias RawValue = CustomAlert
    
    init?(rawValue: CustomAlert) {
        self = rawValue
    }
    
    var rawValue: CustomAlert {
        return self
    }
    
    func show(on viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: Enum Alert Error with CustomAlert Class predefined title and message
enum AlertError {
    case endDateLessThanStartDate
    case endDateMoreThan7DaysAfterStartDate
    case endDateLessThanTodayWhenStartDateIsToday
    case emptyField
    case responseError
    case dateValidSuccess
    
    var rawValue: CustomAlert {
        switch self {
        case .endDateLessThanStartDate:
            return CustomAlert(title: "Error", message: "End date should not be less than start date.")
        case .endDateMoreThan7DaysAfterStartDate:
            return CustomAlert(title: "Limit!", message: "Start and End date diffrence should be maximum 7day because the Feed data limit is only 7days.")
        case .endDateLessThanTodayWhenStartDateIsToday:
            return CustomAlert(title: "Error", message: "End date cannot be less than today if start date is today.")
        case .emptyField:
            return CustomAlert(title: "Empty Field!", message: "Start Date and End date cannot be empty for getting data.")
        case .responseError:
            return CustomAlert(title: "BAD_REQUEST", message: "The Feed date limit is only 7 Days.")
        case .dateValidSuccess:
            return CustomAlert(title: "validDate", message: "date is validated successfully.")
        }
    }
}
