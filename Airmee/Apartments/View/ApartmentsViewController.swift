//
//  ApartmentsViewController.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit

class ApartmentsViewController: UIViewController, Storyboarded {
    
    weak var coordinator: AppCoordinator?
    
    let apartmentsViewModel = ApartmentsViewModel(apartmentService: ApartmentService.shared)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        getData()
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        
        // Subscribe to Loading
        apartmentsViewModel.loading = { [weak self] isLoading in
            guard let self = self else { return }
//            isLoading ? self.loading.startAnimating() : self.loading.stopAnimating()
        }
        
        // Subscribe to apartments
        apartmentsViewModel.apartments = { [weak self] apartments in
            guard let self = self else { return }
            print(apartments)
            // Add new apartments to tableView dataSource.
//            self.citiesTableViewDataSource.refreshWithNewItems(cities)
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
