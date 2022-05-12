//
//  LocationHelper.swift
//  HLFMOBRC
//
//  Created by Samse on 2022/04/25.
//

import Foundation
import CoreLocation

public enum LocationWatchingStatus: Int {
    case idle = 0, running = 1, watching = 2
}

class LocationHelper: NSObject {
    static let shared = LocationHelper()
    private override init() {}
    
    private var requestCompletion: ((_ status: CLAuthorizationStatus) -> Void)?
    private var locationCompletion: ((_ locaion: [String: Any]) -> Void)?
    private var lastLocation: CLLocation? = nil
    var status: LocationWatchingStatus = .idle
    
    lazy var locationManager: CLLocationManager = {
                let manager = CLLocationManager()
                return manager
         }()

    func requestAuthorization(_ completion: ((_ status: CLAuthorizationStatus) -> Void)?) {
        let status = authorizationStatus()
        guard status == .notDetermined else {
            if let completion = completion {
                completion(status)
            }
            return
        }

        requestCompletion = completion
        if let _ = locationManager.delegate {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.delegate = self
        }
    }
    
    func locationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    func startUpdatingLocation(_ completion: ((_ locaion: [String: Any]) -> Void)?) {
        if status == .idle {
            locationCompletion = completion
            
            if locationManager.delegate == nil {
                locationManager.delegate = self
            }
            locationManager.requestLocation()
            status = .running
        }
    }
    
    func startWatchingLocation(_ completion: ((_ location: [String: Any]) -> Void)?) {
        if self.status == .idle {
            if locationManager.delegate == nil {
                locationManager.delegate = self
            }
            locationManager.startUpdatingLocation()
            status = .watching
        }
    }
    
    func clearWatching() {
        locationManager.stopUpdatingLocation()
        self.status = .idle
    }
    
    
    
    
    
//    func updateLocationPermission() {
//        guard locationServicesEnabled() else {
//            PreferenceHelper.set(Constants.Value.N, key: Constants.Key.Pref.locationPermission)
//            return
//        }
//        
//        switch authorizationStatus() {
//        case .authorizedAlways, .authorizedWhenInUse, .authorized:
//            PreferenceHelper.set(Constants.Value.Y, key: Constants.Key.Pref.locationAgree)
//            PreferenceHelper.set(Constants.Value.Y, key: Constants.Key.Pref.locationPermission)
//            
//        default:
//            PreferenceHelper.set(Constants.Value.N, key: Constants.Key.Pref.locationPermission)
//        }
//    }
}

extension LocationHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else {
            manager.requestWhenInUseAuthorization()
            return
        }
        
        if let completion = self.requestCompletion {
            completion(status)
            self.requestCompletion = nil
        }
//        updateLocationPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let location = locations.last {
                self.lastLocation = location
            }
            Logger.info("updated location : \(self.lastLocation.debugDescription)")
        }

        if let location = self.lastLocation {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            if let completion = self.locationCompletion {
                completion(["latitude" : String(latitude),
                            "longitude" : String(longitude)])
                if status == .running {
                    self.locationCompletion = nil
                    status = .idle
                }
            }
//            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let completion = self.locationCompletion {
            completion([:])
            self.locationCompletion = nil
        }
    }
}
