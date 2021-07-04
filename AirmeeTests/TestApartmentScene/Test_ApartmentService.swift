//
//  Test_ApartmentService.swift
//  AirmeeTests
//
//  Created by Shayan Mehranpoor on 7/4/21.
//

import XCTest
@testable import Airmee

final class ApartmentServiceTests: XCTestCase {
    
    var sut: ApartmentService?
    var apartmentsJson: Data?
    
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "apartments", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.apartmentsJson = data
            } catch {
                
            }
        }
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_getApartmentsList() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = apartmentsJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = ApartmentService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async next path test")
        var apartmentsList: [Apartment]?
        
        // When
        sut?.getApartments(completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let apartments):
                apartmentsList = apartments
            case .failure:
                XCTFail()
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(apartmentsList?.count == 10)
        XCTAssertTrue(apartmentsList?.first?.id == "0x1")
    }
}
