//
//  LocationManager.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 12/2/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    @Published var coordinate: CLLocationCoordinate2D?
    
    private override init() { }
    
    func requestLocation() {
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyReduced
        self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        print("Location start up")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Location status changed to: \(manager.authorizationStatus.rawValue)")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
            DebugSettings.shared.longitude = -118.21241904417631
            DebugSettings.shared.lattitude = 33.83422265228964
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print(location.coordinate)
        DebugSettings.shared.longitude = location.coordinate.longitude
        DebugSettings.shared.lattitude = location.coordinate.latitude
        
        self.coordinate = location.coordinate
    }
    
}
