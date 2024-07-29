//
//  PluginManager.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

open class PluginManager {
    
    init() {
        
    }
    
    init(plugins: Dictionary<String, PluginBase>) {
        self.plugins = plugins
    }
    
    open var plugins: Dictionary = [String : PluginBase]()
    
    public func addPlugin(service: String, plugin: PluginBase) {
        plugins[service] = plugin
    }
    
    public func findPlugin(service: String) -> PluginBase? {
        return plugins[service];
    }
    
    
}
