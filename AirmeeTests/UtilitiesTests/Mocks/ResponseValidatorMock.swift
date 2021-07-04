//
//  ResponseValidatorMock.swift
//  GlobalTestTests
//
//  Created by Shayan Mehranpoor on 4/22/21.
//

import Foundation
@testable import Airmee

struct MockResponseValidator: ResponseValidatorProtocol {
    
    func validation<T: Codable>(response: HTTPURLResponse? = nil, data: Data?) -> (Result<T, RequestError>) {
        guard let data = data else {
            return .failure(RequestError.connectionError)
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return .success(model)
        } catch {
            print("JSON Parse Error")
            print(error)
            return .failure(.jsonParseError)
        }
    }
}
