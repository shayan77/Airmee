//
//  MapViewController.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/2/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet var map: MKMapView!
    @IBOutlet var bookBtn: UIButton!
    @IBOutlet var departureTextField: UITextField! {
        didSet {
            departureTextField.datePicker(target: self, doneAction: #selector(fromDoneAction), cancelAction: #selector(fromCancelAction))
        }
    }
    @IBOutlet var returnTextField: UITextField! {
        didSet {
            returnTextField.isUserInteractionEnabled = false
        }
    }
    
    weak var coordinator: AppCoordinator?
    
    let mapViewModel = MapViewModel()
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.title = mapViewModel.name
        
        // bookBtn
        bookBtn.layer.cornerRadius = 10.0
        bookBtn.addTarget(self, action: #selector(didSelectBookButton), for: .touchUpInside)
        
        let location = CLLocation(latitude: mapViewModel.latitude, longitude: mapViewModel.longitude)
        updateLocationOnMap(to: location, with: mapViewModel.name)
        
        toggleButton()
    }
    
    @objc func didSelectBookButton() {
        print("HELLLLO")
    }
    
    private func updateLocationOnMap(to location: CLLocation, with title: String?) {
        
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotation(point)
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        self.map.setRegion(viewRegion, animated: true)
    }
    
    @objc func fromDoneAction() {
        if let datePickerView = self.departureTextField.inputView as? UIDatePicker {
            self.mapViewModel.setDateWith(datePickerView.date, isDeparture: true)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMMM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.departureTextField.text = dateString
            self.departureTextField.resignFirstResponder()
            self.returnTextField.datePicker(target: self, doneAction: #selector(toDoneAction), cancelAction: #selector(toCancelAction), minimumDate: mapViewModel.apartment?.departureDate ?? Date())
            self.returnTextField.isUserInteractionEnabled = true
        }
    }
    
    @objc func fromCancelAction() {
        departureTextField.resignFirstResponder()
    }
    
    @objc func toDoneAction() {
        if let datePickerView = self.returnTextField.inputView as? UIDatePicker {
            self.mapViewModel.setDateWith(datePickerView.date, isDeparture: false)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMMM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.returnTextField.text = dateString
            self.returnTextField.resignFirstResponder()
            self.toggleButton()
        }
    }
    
    @objc func toCancelAction() {
        returnTextField.resignFirstResponder()
    }
    
    private func toggleButton() {
        if mapViewModel.toggleButton() {
            bookBtn.alpha = 1.0
            bookBtn.isUserInteractionEnabled = true
        } else {
            bookBtn.alpha = 0.5
            bookBtn.isUserInteractionEnabled = false
        }
    }
}
