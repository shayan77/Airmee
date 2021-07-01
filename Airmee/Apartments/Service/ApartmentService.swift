//
//  ApartmentService.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import Foundation

/*

 This is Apartment Service, responsible for making api calls of getting apartments.
 
 */

typealias ApartmentsCompletionHandler = (Result<[Apartment], RequestError>) -> Void

protocol ApartmentServiceProtocol {
    func getApartments(completionHandler: @escaping ApartmentsCompletionHandler)
}

/*
 
 ApartmentEndpoint is URLPath of Apartment Api calls
 
*/

private enum ApartmentEndpoint {
    
    case apartments
    
    var path: String {
        switch self {
        case .apartments:
            return "apartments.json"
        }
    }
}

class ApartmentService: ApartmentServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: ApartmentServiceProtocol = ApartmentService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getApartments(completionHandler: @escaping ApartmentsCompletionHandler) {
        self.requestManager.performRequestWith(url: ApartmentEndpoint.apartments.path, httpMethod: .get) { (result: Result<[Apartment], RequestError>) in
            completionHandler(result)
        }
    }
}
