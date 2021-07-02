//
//  ApartmentsViewModel.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import Foundation
import CoreLocation

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
    
    public var currentLocation: CLLocation? {
        didSet {
            getApartments()
        }
    }
    
    public var filter: ApartmentFilter? {
        didSet {
            self.apartments?(filterApartment())
        }
    }
            
    func getApartments() {
        self.loading?(true)
        apartmentService.getApartments { [weak self] apartmentsCallback in
            guard let self = self else { return }
            self.loading?(false)
            switch apartmentsCallback {
            case .success(let apartments):
                self.allApartments.append(contentsOf: apartments)
                self.findDistances()
            case .failure(let error):
                self.errorHandler?(error.localizedDescription)
            }
        }
    }
    
    private func findDistances() {
        allApartments.indices.forEach {
            let apartmentLocation = CLLocation(latitude: allApartments[$0].latitude ?? 0.0, longitude: allApartments[$0].longitude ?? 0.0)
            allApartments[$0].distance = Int(currentLocation?.distance(from: apartmentLocation) ?? 0.0)
        }
        sortBasedOnDistance()
    }
    
    private func sortBasedOnDistance() {
        allApartments.sort { ($0.distance ?? 0) < ($1.distance ?? 0) }
        self.apartments?(self.allApartments)
    }
    
    private func filterApartment() -> [Apartment] {
        guard let filter = filter else {
            return self.allApartments
        }
        
        var beds = [Int]()
        if filter.oneBed ?? false {
            beds.append(1)
        }
        if filter.twoBeds ?? false {
            beds.append(2)
        }
        if filter.threeBeds ?? false {
            beds.append(3)
        }
        
        if beds.isEmpty {
            return self.allApartments
        } else {
            filterdApartments = allApartments
                .filter({ (apartment) -> Bool in
                    return beds.contains(apartment.bedrooms ?? 0)
                })
        }
        
        return self.filterdApartments
    }
}
