//
//  PluginManager.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

@objc open class PluginManager: NSObject {
    
    public override init() {
    }
    
    public init(plugins: Dictionary<String, PluginBase>) {
        self.plugins = plugins
    }
    
    private var plugins: Dictionary = [String : PluginBase]()
    
    open func addPlugin(service: String, plugin: PluginBase) {
        plugins[service] = plugin
    }
    
    open func findPlugin(service: String) -> PluginBase? {
        return plugins[service];
    }

}
