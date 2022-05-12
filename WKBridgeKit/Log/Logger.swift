//
//  Logger.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation

class Logger {
    /// 디버그 로그
    static func debug(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "🐛 DEBUG", message: message, clazz: file, function: function, line: line)
    }
    
    /// 경고 로그
    static func warning(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "⚠️ WARNING", message: message, clazz: file, function: function, line: line)
    }
    
    /// 오류 로그
    static func error(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "🚫 ERROR", message: message, clazz: file, function: function, line: line)
    }
    
    /// 정보 로그
    static func info(_ message: String?, file: String = #file, function: String = #function, line: UInt = #line) {
        printLog(level: "ℹ️ INFO", message: message, clazz: file, function: function, line: line)
    }
    
    /// 요청 로그
    static func request(_ message: String? = "", request: URLRequest? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
        var msg = message
        if let req = request {
            msg?.append("\(req)")
//            msg?.append("\n\(req.headers)")
        }
        printLog(level: "⬆️ REQUEST", message: msg, clazz: file, function: function, line: line)
    }
    
    /// 응답 로그
    static func response(_ message: String? = "", response: URLResponse? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
        var msg = message
        if let res = response {
            msg?.append("\(res)")
        }
        printLog(level: "⬇️ RESPONSE", message: msg, clazz: file, function: function, line: line)
    }
    
    /// 로그 출력
    /// - Parameters:
    ///   - level: 로그 레벨
    ///   - message: 로그 메세지
    ///   - clazz: 클래스
    ///   - function: 메서드
    ///   - line: 라인
    private static func printLog(level: String, message: String?, clazz: String, function: String, line: UInt) {
        #if DEBUG
        print("================================================================================================")
        print("[\(level)] \(timeStamp())")
        print("C: \(className(clazz))")
        print("F: \(function) [\(line)]")
        print("================================================================================================")
        print("\(message ?? "")\n")
        #endif
    }
    
    /// 클래스 이름 반환
    /// - Parameter file: 파일 경로
    /// - Returns: 클래스 이름
    private static func className(_ file: String) -> String {
        if let name = file.split(separator: "/").last {
            return String(name.split(separator: ".").first ?? "Undefined Class")
        }
        return "Undefined Class"
    }
    
    /// 현재 시간 반환
    /// - Returns: 시간
    private static func timeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
