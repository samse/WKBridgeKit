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
            if let encData = Data(base64Encoded: value) {
                return String(data: encData, encoding: .utf8)
            }
        }
        return nil
    }

    static public func get(_ key: String, defaultValue: String) -> String? {
        if let value = get(key) {
            return value
        }
        return defaultValue
    }

    static public func set(_ value: String?, key: String) {
        if let val = value {
            let encoded = val.data(using: .utf8)?.base64EncodedString()
            UserDefaults.standard.set(encoded, forKey: key)
        }
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
