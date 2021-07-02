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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
        getData()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.title = "Apartments"
        
        // apartmentsTableViewDataSource
        apartmentsTableViewDataSource = AirmeeTableViewDataSource(cellHeight: 100, items: [], tableView: apartmentsTableView, delegate: self, animationType: .type2(0.5))
        apartmentsTableView.delegate = apartmentsTableViewDataSource
        apartmentsTableView.dataSource = apartmentsTableViewDataSource
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
    
    private func getData() {
        apartmentsViewModel.getApartments()
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
