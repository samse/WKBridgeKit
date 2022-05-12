//
//  GeoLocationPlugin.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25.
//

import Foundation

class GeoLocationPlugin : PluginBase {

    let ACTION_AVAILABLE_LOCATION   = "available"
    let ACTION_CURRENT_LOCATION     =   "current"
    let ACTION_WATCH_LOCATION       = "watch"
    let ACTION_CLEAR_WATCH          = "clearWatch"

    var completedHandler: ((Bool) -> Void)?

    open override func execute(command: [String : Any]) {
        let promiseId = command[PluginBase.PROMISEID] as? String
        guard let action = command[PluginBase.ACTION] as? String else {
            invalidActionError(promiseId)
            return
        }
        
        if action == ACTION_AVAILABLE_LOCATION {
            availableLocation(command: command)
        } else if action == ACTION_CURRENT_LOCATION {
            currentLocation(command: command)
        } else if action == ACTION_WATCH_LOCATION {
            watchLocation(command: command)
        } else if action == ACTION_CLEAR_WATCH {
            clearWatch(command: command)
        } else {
            invalidActionError(promiseId)
        }
    }
    
    func availableLocation(command: [String: Any]) {
        let promiseId = command[PluginBase.PROMISEID] as? String
        if LocationHelper.shared.locationServicesEnabled() {
            self.sendDefaultSuccessResult(promiseId)
        } else {
            self.sendDefaultErrorResult(promiseId)
        }
    }

    func currentLocation(command: [String: Any]) {
        let promiseId = command[PluginBase.PROMISEID] as? String
        let locationHelper = LocationHelper.shared
        guard locationHelper.locationServicesEnabled() else {
            self.sendSuccessResult(promiseId, message: PluginBase.ErrorMessage.unavailableLocation)
            return
        }
        
        let status = locationHelper.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            DispatchQueue.main.async {
                self.getLastLocation(promiseId: promiseId)
            }
        case .notDetermined:
            DispatchQueue.main.async {
                locationHelper.requestAuthorization { status in
                    if status == .denied {
                        self.sendErrorResult(promiseId, message: PluginBase.ErrorMessage.permissionDenied)
                    } else {
                        self.getLastLocation(promiseId: promiseId)
                    }
                }
            }
            
        default:
            self.sendErrorResult(promiseId, message: PluginBase.ErrorMessage.permissionDenied)
        }

    }
    
    func getLastLocation(promiseId: String?) {
        if let promiseId = promiseId {
            if LocationHelper.shared.status == .idle {
                LocationHelper.shared.startUpdatingLocation { locaion in
                    self.sendSuccessResult(promiseId, message: locaion)
                }
            } else {
                self.sendErrorResult(promiseId, message: "geolocation is aleady running")
            }
        }
    }
    
    func watchLocation(command: [String: Any]) {
        if let promiseId = command[PluginBase.PROMISEID] as? String {
            if LocationHelper.shared.status == .idle {
                LocationHelper.shared.startWatchingLocation { location in
                    self.sendSuccessResult(promiseId, message: location)
                }
            } else {
                self.sendErrorResult(promiseId, message: "geolocation is aleady running")
            }
        }
    }

    func clearWatch(command: [String: Any]) {
        if let promiseId = command[PluginBase.PROMISEID] as? String {
            if LocationHelper.shared.status != .idle {
                LocationHelper.shared.clearWatching()
                self.sendDefaultSuccessResult(promiseId)
            } else {
                self.sendErrorResult(promiseId, message: "geolocation does not running")
            }
        }
    }

}
