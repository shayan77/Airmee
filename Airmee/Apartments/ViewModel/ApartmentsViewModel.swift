//
//  ApartmentsViewModel.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import UIKit
import CoreData
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
    private var fetchedApartments: [Apartment] = []
        
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
                self.fetchObject(completion: nil)
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
            filterdApartments = allApartments
        } else {
            filterdApartments = allApartments
                .filter({ (apartment) -> Bool in
                    return beds.contains(apartment.bedrooms ?? 0)
                })
        }
        
        fetchedApartments.forEach { apartment in
            if checkDepartureDateIsInFilterDates(apartment: apartment) {
                removeApartment(apartment: apartment)
            }
            if checkReturnDateIsInFilterDates(apartment: apartment) {
                removeApartment(apartment: apartment)
            }
        }

        return self.filterdApartments
    }
    
    private func checkDepartureDateIsInFilterDates(apartment: Apartment) -> Bool {
        if apartment.departureDate?.isBetween(filter?.departureDate, and: filter?.returnDate) ?? false {
            return true
        }
        return false
    }
    
    private func checkReturnDateIsInFilterDates(apartment: Apartment) -> Bool {
        if apartment.returnDate?.isBetween(filter?.departureDate, and: filter?.returnDate) ?? false {
            return true
        }
        return false
    }
    
    private func removeApartment(apartment: Apartment) {
        filterdApartments.removeAll { $0.id == apartment.id }
    }
    
    public func reload() {
        if filter == nil {
            self.apartments?(self.allApartments)
        } else {
            self.fetchObject {
                self.apartments?(self.filterApartment())
            }
        }
    }
    
    private func fetchObject(completion: Completion) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ApartmentModel")
        
        // 3
        do {
            let objects = try managedContext.fetch(fetchRequest)
            if !objects.isEmpty {
                self.mapManagedObjectToModel(objects: objects, completion: completion)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func mapManagedObjectToModel(objects: [NSManagedObject], completion: Completion) {
        self.fetchedApartments.removeAll()
        objects.forEach { object in
            let apartment = Apartment(id: object.value(forKey: "id") as? String, bedrooms: object.value(forKey: "bedrooms") as? Int, name: object.value(forKey: "name") as? String, latitude: object.value(forKey: "latitude") as? Double, longitude: object.value(forKey: "longitude") as? Double, distance: object.value(forKey: "distance") as? Int, departureDate: object.value(forKey: "departureDate") as? Date, returnDate: object.value(forKey: "returnDate") as? Date)
            self.fetchedApartments.append(apartment)
        }
        
        completion?()
    }
}

protocol ReloadApartments: AnyObject {
    func reloadApartments()
}
