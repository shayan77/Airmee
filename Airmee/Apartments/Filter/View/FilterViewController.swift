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
    
    weak var coordinator: AppCoordinator?
    
    var appliedFilters = ApartmentFilter()
    weak var delegate: ApartmentsAppliedFiltersProtocol?

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
        print(appliedFilters)
        delegate?.userDidSelectFilters(filters: appliedFilters)
        self.dismiss(animated: true)
    }
}
