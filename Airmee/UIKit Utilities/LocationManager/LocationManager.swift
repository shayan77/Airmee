//
//  LocationManager.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/4/21.
//

import UIKit
import CoreLocation

enum  LMError: Error {
    case authorizationFailed(String)
    case locationUpdationFailed(String)
}

enum LMResponse {
    case success(CLLocation)
    case failure(LMError)
}

enum LMLocationAccuracy {
    case kilometer
    case best
    case nearestTenMeters
    case hundredMeter
    case threeKilometers
    case bestForNavigation
}

class LocationManager: NSObject {
    
    typealias LMHandler = (LMResponse) -> Void
    typealias LMUntilHandler = (LMResponse) -> Bool
    
    // MARK: - Variable
    private var oneTimeUse: Bool = true
    private let locationManager = CLLocationManager()
    private var callback: LMHandler?
    private var trackingHandler: LMUntilHandler?
    
    /// MARK: - Initializer
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    convenience init(withAccuracy accuracy: LMLocationAccuracy) {
        self.init()
        locationManager.desiredAccuracy = getCLAccuracy(forLMAccurcy: accuracy)
    }
    
    // MARK: - Helpers
    private func getCLAccuracy(forLMAccurcy lmAccuracy: LMLocationAccuracy) -> CLLocationAccuracy {
        switch  lmAccuracy {
        case .best:
            return kCLLocationAccuracyBest
        case .bestForNavigation:
            return kCLLocationAccuracyBestForNavigation
        case .hundredMeter:
            return kCLLocationAccuracyHundredMeters
        case .kilometer:
            return kCLLocationAccuracyKilometer
        case .nearestTenMeters:
            return kCLLocationAccuracyNearestTenMeters
        case .threeKilometers:
            return kCLLocationAccuracyThreeKilometers
        }
    }
    
    private func trackingHandle (response: LMResponse) {
        if let callback = self.callback {
            callback(response)
            locationManager.stopUpdatingLocation()
        }
        if let trackingHandler = self.trackingHandler {
            if trackingHandler(response) {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    // MARK: - Public Fuctions
    public func getCurrentLocation(handler: @escaping LMHandler) {
        locationManager.requestWhenInUseAuthorization()
        self.callback = handler
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatinglocation () {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func  locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            let error = LMError.authorizationFailed("Failed to get Authorisation from user.")
            let resposne = LMResponse.failure(error)
            _ = trackingHandler?(resposne)
            callback?(resposne)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let lmError = LMError.locationUpdationFailed(error.localizedDescription)
        let response = LMResponse.failure(lmError)
        callback?(response)
        _ = trackingHandler?(response)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            print("Location Not fetched")
            return
        }
        let responseSuccess = LMResponse.success(lastLocation)
        trackingHandle(response: responseSuccess)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}
