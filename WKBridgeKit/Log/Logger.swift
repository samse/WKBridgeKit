//
//  Logger.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

class Logger {
    /// debug log
    static func debug(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "🐛 DEBUG", message: message, clazz: file, function: function, line: line)
    }
    
    /// warning log
    static func warning(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "⚠️ WARNING", message: message, clazz: file, function: function, line: line)
    }
    
    /// error log
    static func error(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "🚫 ERROR", message: message, clazz: file, function: function, line: line)
    }
    
    /// info log
    static func info(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "ℹ️ INFO", message: message, clazz: file, function: function, line: line)
    }
    
    /// request log
    static func request(_ message: String? = "", request: URLRequest? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
        var msg = message
        if let req = request {
            msg?.append("\(req)")
//            msg?.append("\n\(req.headers)")
        }
        printLog(level: "⬆️ REQUEST", message: msg, clazz: file, function: function, line: line)
    }
    
    /// responsel og
    static func response(_ message: String? = "", response: URLResponse? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
        var msg = message
        if let res = response {
            msg?.append("\(res)")
        }
        printLog(level: "⬇️ RESPONSE", message: msg, clazz: file, function: function, line: line)
    }
    
    /// print log
    /// - Parameters:
    ///   - level: log level
    ///   - message: message
    ///   - clazz: class name
    ///   - function: function name
    ///   - line: line of code
    private static func printLog(level: String, message: String?, clazz: String, function: String, line: UInt) {
        #if DEBUG
        print("===================================================================")
        print("[\(level)] \(timeStamp())")
        print("C: \(className(clazz))")
        print("F: \(function) [\(line)]")
        print("\(message ?? "")\n")
        print("====================================================================")
        #endif
    }
    
    /// return class name
    /// - Parameter file: file path
    /// - Returns: class name
    private static func className(_ file: String) -> String {
        if let name = file.split(separator: "/").last {
            return String(name.split(separator: ".").first ?? "Undefined Class")
        }
        return "Undefined Class"
    }
    
    /// return current time
    /// - Returns: time
    private static func timeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
