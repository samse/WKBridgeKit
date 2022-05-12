//
//  Preference.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

class PreferenceHelper  {
    static func get(_ key: String) -> String? {
        if let value = UserDefaults.standard.string(forKey: key) {
            return value
        }
        return nil
    }
    
    static func set(_ value: String, key: String) {
        UserDefaults.standard.set(nullToNil(value: value), forKey: key)
    }
        
    static func remove(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    private static func nullToNil(value : Any?) -> Any? {
        if value is NSNull {
            return ""
        } else {
            return value
        }
    }
}
