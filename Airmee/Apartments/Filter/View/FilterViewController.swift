//
//  FilterViewController.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/2/21.
//

import UIKit

protocol ApartmentsAppliedFiltersProtocol: AnyObject {
    func userDidSelectFilters(filters: ApartmentFilter?)
}

class FilterViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet var oneBedSwitch: UISwitch! {
        didSet {
            oneBedSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
    }
    @IBOutlet var twoBedsSwitch: UISwitch! {
        didSet {
            twoBedsSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
    }
    @IBOutlet var threeBedsSwitch: UISwitch! {
        didSet {
            threeBedsSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
    }
    @IBOutlet var applyBtn: UIButton! {
        didSet {
            applyBtn.layer.cornerRadius = 8.0
            applyBtn.addTarget(self, action: #selector(didSelectApplyButton), for: .touchUpInside)
        }
    }
    @IBOutlet var cancelBtn: UIButton! {
        didSet {
            cancelBtn.layer.cornerRadius = 8.0
            cancelBtn.layer.borderWidth = 1.0
            cancelBtn.layer.borderColor = UIColor.black.cgColor
            cancelBtn.addTarget(self, action: #selector(didSelectCancelButton), for: .touchUpInside)
        }
    }
    @IBOutlet var fromTextField: UITextField! {
        didSet {
            fromTextField.datePicker(target: self, doneAction: #selector(fromDoneAction), cancelAction: #selector(fromCancelAction))
        }
    }
    @IBOutlet var toTextField: UITextField! {
        didSet {
            toTextField.isUserInteractionEnabled = false
        }
    }
    
    weak var coordinator: AppCoordinator?
    
    var appliedFilters = ApartmentFilter()
    weak var delegate: ApartmentsAppliedFiltersProtocol?
    
    var fromDate: Date? {
        didSet {
            toTextField.isUserInteractionEnabled = true
            toTextField.datePicker(target: self, doneAction: #selector(toDoneAction), cancelAction: #selector(toCancelAction), minimumDate: fromDate ?? Date())

        }
    }
    var toDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.title = "Filter"
        
        oneBedSwitch.setOn(appliedFilters.oneBed ?? false, animated: true)
        twoBedsSwitch.setOn(appliedFilters.twoBeds ?? false, animated: true)
        threeBedsSwitch.setOn(appliedFilters.threeBeds ?? false, animated: true)
    }
    
    @objc func didSelectCancelButton() {
        appliedFilters = ApartmentFilter()
        delegate?.userDidSelectFilters(filters: appliedFilters)
        self.dismiss(animated: true)
    }
    
    @objc func didSelectApplyButton() {
        appliedFilters.oneBed = oneBedSwitch.isOn
        appliedFilters.twoBeds = twoBedsSwitch.isOn
        appliedFilters.threeBeds = threeBedsSwitch.isOn
        appliedFilters.fromDate = fromDate
        appliedFilters.toDate = toDate
        delegate?.userDidSelectFilters(filters: appliedFilters)
        self.dismiss(animated: true)
    }
    
    @objc func fromDoneAction() {
        if let datePickerView = self.fromTextField.inputView as? UIDatePicker {
            self.fromDate = datePickerView.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMMM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.fromTextField.text = dateString
            self.fromTextField.resignFirstResponder()
        }
    }
    
    @objc func fromCancelAction() {
        fromTextField.resignFirstResponder()
    }
    
    @objc func toDoneAction() {
        if let datePickerView = self.toTextField.inputView as? UIDatePicker {
            self.toDate = datePickerView.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMMM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.toTextField.text = dateString
            self.toTextField.resignFirstResponder()
        }
    }
    
    @objc func toCancelAction() {
        toTextField.resignFirstResponder()
    }
}
