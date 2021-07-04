//
//  AppCoordinatorTest.swift
//  AirmeeTests
//
//  Created by Shayan Mehranpoor on 7/4/21.
//

import XCTest
@testable import Airmee

final class AppCoordinatorTest: XCTestCase {

    var sut: AppCoordinator?
    var window: UIWindow?
    
    override func tearDownWithError() throws {
        sut = nil
        window = nil
        try? super.tearDownWithError()
    }
    
    override func setUp() {
        let nav = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        sut = AppCoordinator(navigationController: nav, window: window)
    }
    
    override func tearDown() {
        sut = nil
        window = nil
    }
    
    func test_start() throws {
        // given
        guard let sut = sut else {
            throw UnitTestError()
        }
        
        // when
        sut.start(animated: false)
        
        
        // then
        XCTAssertEqual(sut.navigationController.viewControllers.count, 1)
        let rootVC = sut.navigationController.viewControllers[0] as? ApartmentsViewController
        XCTAssertNotNil(rootVC, "Check if root vsc is CitiesViewController")
    }
    
    func test_NavigateToMap() throws {
        // given
        guard let sut = sut else {
            throw UnitTestError()
        }
        // when
        sut.navigateToMap(Apartment(id: "0x0", bedrooms: 2, name: "Horel Apartment", latitude: 35.124125, longitude: 65.2424))
        
        // then
        XCTAssertEqual(sut.navigationController.viewControllers.count, 1)
        let visibleVC = sut.navigationController.visibleViewController as? MapViewController
        XCTAssertNotNil(visibleVC, "Check if presented vc is MapViewController")
    }
}
