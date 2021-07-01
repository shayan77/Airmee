//
//  RequestManager.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/1/21.
//

import Foundation

enum RequestError: Error, LocalizedError {
    case connectionError
    case authorizationError
    case notFound(String)
    case serverUnavailable
    case jsonParseError
}

extension RequestError {
    public var errorDescription: String? {
        switch self {
        case .connectionError:
            return "Internet Connection Error"
        case .notFound(let errorMessage):
            return errorMessage
        case .jsonParseError:
            return "JSON parsing problem, make sure response has a valid JSON"
        case .authorizationError:
            return "401 user not valid"
        case .serverUnavailable:
            return "Server Unavailable"
        }
    }
}
