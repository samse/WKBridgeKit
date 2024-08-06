//
//  Preference.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

@objc open class WKPreferenceHelper: NSObject  {
    static public func get(_ key: String) -> String? {
        if let value = UserDefaults.standard.string(forKey: key) {
            return value.data(using: .utf8)?.base64EncodedString()
        }
        return nil
    }

    static public func get(_ key: String, defaultValue: String) -> String? {
        if let value = UserDefaults.standard.string(forKey: key) {
            return value.data(using: .utf8)?.base64EncodedString()
        }
        return defaultValue
    }

    static public func set(_ value: String, key: String) {
        UserDefaults.standard.set(nullToNil(value: value), forKey: key)
    }
        
    static public func remove(_ key: String) {
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
