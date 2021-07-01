//
//  URLRequestLoggableProtocol.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import Foundation

protocol URLRequestLoggableProtocol {
    func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, HTTPMethod: String?)
}
