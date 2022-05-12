//
//  PluginBase.swift
//  WKBridgeKit
//
//  Created by Samse on 2022/04/25
//

import Foundation
import SwiftyJSON

open class PluginBase: NSObject {
    static let SERVICE =    "service"
    static let PROMISEID =  "promiseId"
    static let ACTION =     "action"
    static let OPTION =     "option"
    
    public struct ErrorMessage {
        static let invalidParam =           "invalid_parameter"
        static let invalidAction =          "invalid_action_name"
        static let undefinedEmail =         "undefined_email"
        static let undefinedName =          "undefined_name"
        static let userCancel =             "user_cancel"
        static let permissionDenied =       "permission_denied"
        static let unavailableLocation =    "unavailable_location"
        static let undefinedAddress =       "undefined_address"
        static let notInstalled =           "not_installed"
        static let noBiometrics =           "no_biometrics"
        static let simulatorNotSupport =    "simulator_not_support"
        static let unknownError =           "unknown_error"
    }
    
    let service: String
    var viewController: BridgeWebViewController?
    
    init(service: String, viewController: BridgeWebViewController) {
        self.service = service
        self.viewController = viewController
    }
    
    func execute(command: [String : Any]) {}
    
    open func invalidParamError(_ promiseId: String?) {
        Logger.error("Invalid Param Error")
        sendErrorResult(promiseId, message: ErrorMessage.invalidParam)
    }
    
    open func invalidActionError(_ promiseId: String?) {
        Logger.error("Invalid Action Error")
        sendErrorResult(promiseId, message: ErrorMessage.invalidAction)
    }
    
    open func sendDefaultSuccessResult(_ promiseId: String?) {
        sendSuccessResult(promiseId, message: "")
    }
    
    open func sendDefaultErrorResult(_ promiseId: String?) {
        sendErrorResult(promiseId, message: "")
    }
    
    open func sendSuccessResult(_ promiseId: String?, message: String?) {
        if let message = message, message.isEmpty == false {
            Logger.debug("Success result: \(message)")
        }
        guard let promiseId = promiseId else { return }
        if let message = message {
            viewController?.onPromiseResolve(promiseId: promiseId, result: "\"\(message)\"")
        } else {
            viewController?.onPromiseResolve(promiseId: promiseId, result: "\"\"")
        }
    }
    
    open func sendErrorResult(_ promiseId: String?, message: String?) {
        if let message = message, message.isEmpty == false {
            Logger.debug("Failure result: \(message)")
        }
        guard let promiseId = promiseId else { return }
        if let message = message {
            viewController?.onPromiseReject(promiseId: promiseId, result: "\"\(message)\"")
        } else {
            viewController?.onPromiseReject(promiseId: promiseId, result: "\"\"")
        }
    }
    
    open func sendSuccessResult(_ promiseId: String?, object message: String?) {
        guard let promiseId = promiseId else { return }
        let result = JSON(parseJSON: message ?? "").rawString([.castNilToNSNull: true])
        viewController?.onPromiseResolve(promiseId: promiseId, result: result)
    }
    
    open func sendSuccessResult(_ promiseId: String?, message: [String: Any]?) {
        guard let promiseId = promiseId else { return }
        let result = JSON(message ?? [:]).rawString([.castNilToNSNull: true])
        viewController?.onPromiseResolve(promiseId: promiseId, result: result)
    }
    
    open func sendSuccessResult(_ promiseId: String?, message: Array<Any>?) {
        guard let promiseId = promiseId else { return }
        let result = JSON(message ?? []).rawString([.castNilToNSNull: true])
        viewController?.onPromiseResolve(promiseId: promiseId, result: result)
    }
    
    // finally
    open func sendSuccessFinallyResult(_ promiseId: String?, message: [String: Any]?) {
        guard let promiseId = promiseId else { return }
        let result = JSON(message ?? [:]).rawString([.castNilToNSNull: true])
        viewController?.onPromiseFinallyResolve(promiseId: promiseId, result: result)
    }
}
