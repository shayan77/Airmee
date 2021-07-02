//
//  MapViewController.swift
//  Airmee
//
//  Created by Shayan Mehranpoor on 7/2/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    @IBOutlet var map: MKMapView!
    @IBOutlet var bookBtn: UIButton!
    
    weak var coordinator: AppCoordinator?
    
    let mapViewModel = MapViewModel()
    
    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Customizing View
    private func setupView() {
        self.title = mapViewModel.name
        
        // bookBtn
        bookBtn.layer.cornerRadius = 10.0
        bookBtn.addTarget(self, action: #selector(didSelectBookButton), for: .touchUpInside)
        
        let location = CLLocation(latitude: mapViewModel.latitude, longitude: mapViewModel.longitude)
        updateLocationOnMap(to: location, with: mapViewModel.name)
    }
    
    @objc func didSelectBookButton() {
        print("HELLLLO")
    }
    
    private func updateLocationOnMap(to location: CLLocation, with title: String?) {
        
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        self.map.removeAnnotations(self.map.annotations)
        self.map.addAnnotation(point)
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        self.map.setRegion(viewRegion, animated: true)
    }
}
