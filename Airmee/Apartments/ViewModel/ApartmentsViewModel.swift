//
//  ApartmentsViewModel.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import Foundation

class ApartmentsViewModel {
    
    private var apartmentService: ApartmentServiceProtocol
    
    init(apartmentService: ApartmentServiceProtocol) {
        self.apartmentService = apartmentService
    }
    
    var apartments: (([Apartment]) -> Void)?
    var errorHandler: ((String) -> Void)?
    var loading: ((Bool) -> Void)?
    
    public var allApartments: [Apartment] = []
    public var filterdApartments: [Apartment] = []
            
    func getApartments() {
        self.loading?(true)
        apartmentService.getApartments { [weak self] apartmentsCallback in
            guard let self = self else { return }
            self.loading?(false)
            switch apartmentsCallback {
            case .success(let apartments):
                self.allApartments.append(contentsOf: apartments)
                self.apartments?(self.allApartments)
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }
}
