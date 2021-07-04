//
//  ApartmentsViewController.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit

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
    
    let locationManager = LocationManager(withAccuracy: .hundredMeter)

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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))

        locationManager.getCurrentLocation { (response) in
            switch response {
            case .failure(let locationError):
                switch locationError {
                case .authorizationFailed(let description):
                    print(description)
                case .locationUpdationFailed(let description):
                    print(description)
                }
            case .success(let location):
                print("location is :", location)
                self.locationManager.stopUpdatinglocation()
                if self.apartmentsViewModel.currentLocation == nil {
                    self.apartmentsViewModel.currentLocation = location
                }
            }
        }
    }
    
    @objc func filterTapped() {
        popFilter()
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
            self.apartmentsTableViewDataSource.refreshWithNewItems(apartments)
        }
        
        // Subscribe to errors
        apartmentsViewModel.errorHandler = { [weak self] error in
            guard let self = self else { return }
            self.showAlertWith(error, title: "Error", completion: nil)
        }
    }
    
    func popFilter() {
        let filterViewController = FilterViewController.instantiate(coordinator: self.coordinator)
        filterViewController.delegate = self
        filterViewController.appliedFilters = self.apartmentsViewModel.filter ?? ApartmentFilter()
        let navigationControlr = UINavigationController(rootViewController: filterViewController)
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
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

extension ApartmentsViewController: ApartmentsAppliedFiltersProtocol {
    func userDidSelectFilters(filters: ApartmentFilter?) {
        self.apartmentsViewModel.filter = filters
    }
}

extension ApartmentsViewController: ReloadApartments {
    func reloadApartments() {
        self.apartmentsViewModel.reload()
    }
}
