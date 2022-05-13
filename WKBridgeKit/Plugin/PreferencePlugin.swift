//
//  PreferencePlugin.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

open class PreferencePlugin: PluginBase {
    let ACTION_GET_PREFERENCE =         "get"
    let ACTION_SET_PREFERENCE =         "set"
    let ACTION_REMOVE_PREFERENCE =      "remove"
    
    open override func execute(command: [String : Any]) {
        let promiseId = command[PluginBase.PROMISEID] as? String
        guard let action = command[PluginBase.ACTION] as? String else {
            invalidActionError(promiseId)
            return
        }
        
        if action == ACTION_GET_PREFERENCE {
            getPreference(command: command)
        } else if action == ACTION_SET_PREFERENCE {
            setPreference(command: command)
        } else if action == ACTION_REMOVE_PREFERENCE {
            removePreference(command: command)
        } else {
            invalidActionError(promiseId)
        }
    }
    
    open func getPreference(command: [String : Any]) {
        
        let promiseId = command[PluginBase.PROMISEID] as? String
        if let option = command[PluginBase.OPTION] as? [String : Any] {
            if let key = option["key"] as? String, let defaultValue = option["defaultValue"] as? String {
                if let value = PreferenceHelper.get(key) {
                    self.sendSuccessResult(promiseId, message: value)
                } else {
                    self.sendSuccessResult(promiseId, message: defaultValue)
                }
            } else {
                self.invalidParamError(promiseId)
            }
        } else {
            self.invalidParamError(promiseId)
        }
    }
    
    open func setPreference(command: [String : Any]) {
        
        let promiseId = command[PluginBase.PROMISEID] as? String
        if let option = command[PluginBase.OPTION] as? [String : Any] {
            if let key = option["key"] as? String, let value = option["value"] as? String {
                PreferenceHelper.set(value, key: key)
                self.sendDefaultSuccessResult(promiseId)
            } else {
                self.invalidParamError(promiseId)
            }
        } else {
            self.invalidParamError(promiseId)
        }
    }
    
    open func removePreference(command: [String : Any]) {
        
        let promiseId = command[PluginBase.PROMISEID] as? String
        if let option = command[PluginBase.OPTION] as? [String : Any] {
            if let key = option["key"] as? String {
                PreferenceHelper.remove(key)
                self.sendDefaultSuccessResult(promiseId)
            } else {
                self.invalidParamError(promiseId)
            }
        } else {
            self.invalidParamError(promiseId)
        }
    }
}
