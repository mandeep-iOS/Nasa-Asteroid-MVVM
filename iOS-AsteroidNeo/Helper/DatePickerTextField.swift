//
//  DatePickerTextField.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit

protocol DatePickerTextFieldDelegate: AnyObject {
    func datePickerTextFieldDidSelectDate(date: Date, textField: UITextField)
}

extension DatePickerTextFieldDelegate {
    func datePickerTextFieldDidSelectDate(date: Date, textField: UITextField){
        print("")
    }
}

//MARK: Custom Class DatePicker with TextField
class DatePickerTextField: UITextField {
    weak var datePickerDelegate: DatePickerTextFieldDelegate?
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        self.inputView = datePicker
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.text = formatter.string(from: datePicker.date)
        datePickerDelegate?.datePickerTextFieldDidSelectDate(date: datePicker.date, textField: self)
        self.endEditing(true)
    }
}

