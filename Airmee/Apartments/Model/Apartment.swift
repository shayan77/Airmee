//
//  Apartment.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import Foundation

struct Apartment: Codable {
    let id: String?
    let bedrooms: Int?
    let name: String?
    let latitude: Double?
    let longitude: Double?
    var distance: Int? = 0
    var departureDate: Date?
    var returnDate: Date?
}
