//
//  ApartmentsViewController.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit
import CoreLocation

class ApartmentsViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet var apartmentsTableView: UITableView!
    @IBOutlet var loading: UIActivityIndicatorView! {
        didSet {
            loading.hidesWhenStopped = true
        }
    }
    
    private var apartmentsTableViewDataSource: AirmeeTableViewDataSource<ApartmentCell>!
    
    weak var coordinator: AppCoordinator?
    
    let apartmentsViewModel = ApartmentsViewModel(apartmentService: ApartmentService.shared)
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.title = "Apartments"
        
        // apartmentsTableViewDataSource
        apartmentsTableViewDataSource = AirmeeTableViewDataSource(cellHeight: 100, items: [], tableView: apartmentsTableView, delegate: self, animationType: .type2(0.5))
        apartmentsTableView.delegate = apartmentsTableViewDataSource
        apartmentsTableView.dataSource = apartmentsTableViewDataSource
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        // Subscribe to Loading
        apartmentsViewModel.loading = { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.loading.startAnimating() : self.loading.stopAnimating()
        }
        
        // Subscribe to apartments
        apartmentsViewModel.apartments = { [weak self] apartments in
            guard let self = self else { return }
            // Add new apartments to tableView dataSource.
            self.apartmentsTableViewDataSource.appendItemsToTableView(apartments)
        }
        
        // Subscribe to errors
        apartmentsViewModel.errorHandler = { [weak self] error in
            guard let self = self else { return }
            self.showAlertWith(error)
        }
    }
}

// MARK: - AirmeeTableViewDelegate
extension ApartmentsViewController: AirmeeTableViewDelegate {
    func tableView(willDisplay cellIndexPath: IndexPath, cell: UITableViewCell) {
        if let apartmentCell = cell as? ApartmentCell {
            apartmentCell.apartmentDetailButtonDelegate = self
        }
    }
}

extension ApartmentsViewController: ApartmentCellDetailButtonDelegate {
    func apartmentDetail(for apartment: Apartment) {
        self.coordinator?.navigateToMap(apartment)
    }
}


extension ApartmentsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.locationManager.stopUpdatingLocation()
        if self.apartmentsViewModel.currentLocation == nil {
            self.apartmentsViewModel.currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        }
    }
}
