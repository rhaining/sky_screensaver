//
//  LocationHelper.swift
//  SkySaver
//
//  Created by Robert Tolar Haining on 6/5/20.
//  Copyright © 2020 Robert Tolar Haining. All rights reserved.
//

import Foundation
import CoreLocation

//
// Wrapper for Core Location 
//

final class LocationHelper: NSObject {
    private let locationManager = CLLocationManager()
    
    private override init() {
        super.init()
    }
    
    static let shared: LocationHelper = {
        let locationHelper = LocationHelper()
        locationHelper.locationManager.delegate = locationHelper
        return locationHelper
    }()
    
    fileprivate var onUpdate: ((Swift.Result<CLLocationCoordinate2D, Error>) -> Void)?
    
    func getLocation(onUpdate: @escaping ((Swift.Result<CLLocationCoordinate2D, Error>) -> Void)) {
        self.onUpdate = onUpdate
        locationManager.requestLocation()
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        
        onUpdate?(.success(coordinate))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onUpdate?(.failure(error))
    }
}
