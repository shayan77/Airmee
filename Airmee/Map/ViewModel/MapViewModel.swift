//
//  MapViewModel.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/2/21.
//

import UIKit
import CoreData

typealias Completion = (() -> Void)?
typealias ErrorHandler = ((String) -> Void)?

final class MapViewModel {
    
    private var _longitude: Double = 0.0
    public var longitude: Double {
        get {
            return _longitude
        } set {
            _longitude = newValue
        }
    }
    
    private var _latitude: Double = 0.0
    public var latitude: Double {
        get {
            return _latitude
        } set {
            _latitude = newValue
        }
    }
    
    private var _name: String = ""
    public var name: String {
        get {
            return _name
        } set {
            _name = newValue
        }
    }
        
    public var apartment: Apartment? {
        didSet {
            _longitude = apartment?.longitude ?? 0.0
            _latitude = apartment?.latitude ?? 0.0
            _name = apartment?.name ?? ""
        }
    }
        
    public func setDateWith(_ date: Date, isDeparture: Bool) {
        if isDeparture {
            apartment?.departureDate = date
        } else {
            apartment?.returnDate = date
        }
    }
    
    public func toggleButton() -> Bool {
        if (apartment?.departureDate != nil) && (apartment?.returnDate != nil) {
            return true
        } else {
            return false
        }
    }
    
    public func saveApartment(completion: Completion, saveError: ErrorHandler) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "ApartmentModel", in: managedContext)!
        let apartmentModel = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        apartmentModel.setValue(apartment?.id, forKey: "id")
        apartmentModel.setValue(apartment?.bedrooms, forKey: "bedrooms")
        apartmentModel.setValue(apartment?.name, forKey: "name")
        apartmentModel.setValue(apartment?.latitude, forKey: "latitude")
        apartmentModel.setValue(apartment?.longitude, forKey: "longitude")
        apartmentModel.setValue(apartment?.distance, forKey: "distance")
        apartmentModel.setValue(apartment?.departureDate, forKey: "departureDate")
        apartmentModel.setValue(apartment?.returnDate, forKey: "returnDate")
        
        // 4
        do {
            try managedContext.save()
            completion?()
        } catch let error as NSError {
            saveError?("Could not save. \(error), \(error.userInfo)")
        }
    }
}
