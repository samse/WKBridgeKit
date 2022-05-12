//
//  PluginManager.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

open class PluginManager {
    
    var plugins: Dictionary = [String : PluginBase]()
    
    public func addPlugin(service: String, plugin: PluginBase) {
        plugins[service] = plugin
    }
    
    public func findPlugin(service: String) -> PluginBase? {
        return plugins[service];
    }
    
    
}
