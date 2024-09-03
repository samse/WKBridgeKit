//
//  AppPlugin.swift
//  HLFMOBRC
//
//  Created by Hyunjun Kwak on 2022/03/12.
//

import Foundation
import UIKit
import WebKit
import KeychainAccess

@objc open class AppPlugin: PluginBase {
    let ACTION_APP_INFO     = "appInfo"
    let ACTION_DEVICE_INFO  = "deviceInfo"
    let ACTION_EXIT         = "exit"
    let ACTION_GO_SETTINGS  = "goSettings"
    let ACTION_CLEARCACHE   = "clearCache"
    let ACTION_OPEN_BROWSER = "openBrowser"
        
    open override func execute(command: [String : Any]) {
        let promiseId = command[PluginBase.PROMISEID] as? String
        guard let action = command[PluginBase.ACTION] as? String else {
            invalidActionError(promiseId)
            return
        }
        
        if action == ACTION_APP_INFO {
            appInfo(promiseId: promiseId)
        } else if action == ACTION_DEVICE_INFO {
            deviceInfo(promiseId: promiseId)
        } else if action == ACTION_EXIT {
            exit(command: command)
        } else if action == ACTION_GO_SETTINGS {
            goSetting(command: command)
        } else if action == ACTION_CLEARCACHE {
            clearCache(promiseId: promiseId)
        } else if action == ACTION_OPEN_BROWSER {
            openBrowser(command: command)
        } else {
            invalidActionError(promiseId)
        }
    }
    
    open func appInfo(promiseId: String?) {
        
        var displayName = getBundleString(withKey: "CFBundleDisplayName")
        if displayName.isEmpty {
            displayName = getBundleString(withKey: "CFBundleName")
        }
        let version = getBundleString(withKey: "CFBundleShortVersionString")
        let build = getBundleString(withKey: "CFBundleVersion")

        sendSuccessResult(promiseId, message: ["name" : displayName,
                                               "version" : version,
                                               "build" : build])
    }
    
    open func deviceInfo(promiseId: String?) {
        let device = UIDevice.current
        let identifier = Locale.preferredLanguages.first
        
        sendSuccessResult(promiseId, message: ["deviceId" : AppPlugin.deviceId,
                                               "version" : device.systemVersion,
                                               "model" : AppPlugin.model,
                                               "region" : Locale(identifier: identifier!).regionCode as Any,
                                               "language" : Locale(identifier: identifier!).languageCode?.lowercased() as Any])
    }
    
    open func clearCache(promiseId: String?) {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set, modifiedSince: Date(), completionHandler: {
            print("clear")
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
        })
        sendDefaultSuccessResult(promiseId)
    }
    
    open func goSetting(command: [String: Any]) {
        // 설정앱으로 이동, 설정관련 상세한 안내를 해주어야 함.
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSetting)
        }
    }
    
    open func openBrowser(command: [String: Any]) {
        guard let url = URL(string: urlStr) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (result) in
                handler?()
            }
        } else {
            UIApplication.shared.openURL(url)
            handler?()
        }
    }
    
    /// 앱 종료
    open func exit(command: [String : Any]) {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Darwin.exit(0)
        }
    }
    
}

//MARK: deviceId
extension AppPlugin {
    static let KeychainService = "WKBridgeKitKeychain"
    static let KeychainDeviceId = "WKBridgeKitKeychainDeviceId"
    
    public static var deviceId: String = {
        let keychain = Keychain(service: KeychainService)
        if let uuid = try? keychain.get(KeychainDeviceId) {
            return uuid
        }
        
        let uuidForVendor = AppPlugin.uuidForVendor
        try? keychain.set(uuidForVendor, key: KeychainDeviceId)
        return uuidForVendor
    }()
    
    public static var uuidForVendor: String = {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        return UUID().uuidString.lowercased()
    }()

}

//MARK: Model
extension AppPlugin {
    public enum Device : String {
        //Simulator
        case simulator     = "simulator",

        //iPod
        iPod1              = "iPod 1",
        iPod2              = "iPod 2",
        iPod3              = "iPod 3",
        iPod4              = "iPod 4",
        iPod5              = "iPod 5",
        iPod6              = "iPod 6",
        iPod7              = "iPod 7",

        //iPad
        iPad2              = "iPad 2",
        iPad3              = "iPad 3",
        iPad4              = "iPad 4",
        iPadAir            = "iPad Air ",
        iPadAir2           = "iPad Air 2",
        iPadAir3           = "iPad Air 3",
        iPadAir4           = "iPad Air 4",
        iPadAir5           = "iPad Air 5",
        iPad5              = "iPad 5", //iPad 2017
        iPad6              = "iPad 6", //iPad 2018
        iPad7              = "iPad 7", //iPad 2019
        iPad8              = "iPad 8", //iPad 2020

        //iPad Mini
        iPadMini           = "iPad Mini",
        iPadMini2          = "iPad Mini 2",
        iPadMini3          = "iPad Mini 3",
        iPadMini4          = "iPad Mini 4",
        iPadMini5          = "iPad Mini 5",
        iPadMini6          = "iPad Mini 6",

        //iPad Pro
        iPadPro9_7         = "iPad Pro 9.7",
        iPadPro10_5        = "iPad Pro 10.5",
        iPadPro11          = "iPad Pro 11",
        iPadPro2_11        = "iPad Pro 11 2nd gen",
        iPadPro3_11        = "iPad Pro 11 3nd gen",
        iPadPro12_9        = "iPad Pro 12.9",
        iPadPro2_12_9      = "iPad Pro 2 12.9",
        iPadPro3_12_9      = "iPad Pro 3 12.9",
        iPadPro4_12_9      = "iPad Pro 4 12.9",
        iPadPro5_12_9      = "iPad Pro 5 12.9",

        //iPhone
        iPhone4            = "iPhone 4",
        iPhone4S           = "iPhone 4S",
        iPhone5            = "iPhone 5",
        iPhone5S           = "iPhone 5S",
        iPhone5C           = "iPhone 5C",
        iPhone6            = "iPhone 6",
        iPhone6Plus        = "iPhone 6 Plus",
        iPhone6S           = "iPhone 6S",
        iPhone6SPlus       = "iPhone 6S Plus",
        iPhoneSE           = "iPhone SE",
        iPhone7            = "iPhone 7",
        iPhone7Plus        = "iPhone 7 Plus",
        iPhone8            = "iPhone 8",
        iPhone8Plus        = "iPhone 8 Plus",
        iPhoneX            = "iPhone X",
        iPhoneXS           = "iPhone XS",
        iPhoneXSMax        = "iPhone XS Max",
        iPhoneXR           = "iPhone XR",
        iPhone11           = "iPhone 11",
        iPhone11Pro        = "iPhone 11 Pro",
        iPhone11ProMax     = "iPhone 11 Pro Max",
        iPhoneSE2          = "iPhone SE 2nd gen",
        iPhone12Mini       = "iPhone 12 Mini",
        iPhone12           = "iPhone 12",
        iPhone12Pro        = "iPhone 12 Pro",
        iPhone12ProMax     = "iPhone 12 Pro Max",
        iPhone13Mini       = "iPhone 13 Mini",
        iPhone13           = "iPhone 13",
        iPhone13Pro        = "iPhone 13 Pro",
        iPhone13ProMax     = "iPhone 13 Pro Max",
        
        unknownDevice       = "unrecognized"
    }
    
    public static var model: String = {
        var systemInfo = utsname()
        uname(&systemInfo)

        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }

        let modelMap : [String: Device] = [
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,

            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPod7,1"   : .iPod6,
            "iPod9,1"   : .iPod7,

            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            "iPad7,11"  : .iPad7, //iPad 2019
            "iPad7,12"  : .iPad7,
            "iPad11,6"  : .iPad8, //iPad 2020
            "iPad11,7"  : .iPad8,

            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            "iPad14,1"  : .iPadMini6,
            "iPad14,2"  : .iPadMini6,

            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,9"   : .iPadPro2_11,
            "iPad8,10"  : .iPadPro2_11,
            "iPad13,4"  : .iPadPro3_11,
            "iPad13,5"  : .iPadPro3_11,
            "iPad13,6"  : .iPadPro3_11,
            "iPad13,7"  : .iPadPro3_11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            "iPad8,11"  : .iPadPro4_12_9,
            "iPad8,12"  : .iPadPro4_12_9,
            "iPad13,8"  : .iPadPro5_12_9,
            "iPad13,9"  : .iPadPro5_12_9,
            "iPad13,10" : .iPadPro5_12_9,
            "iPad13,11" : .iPadPro5_12_9,

            //iPad Air
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            "iPad13,1"  : .iPadAir4,
            "iPad13,2"  : .iPadAir4,
            "iPad13,16" : .iPadAir5,
            "iPad13,17" : .iPadAir5,
            
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone12,8" : .iPhoneSE2,
            "iPhone13,1" : .iPhone12Mini,
            "iPhone13,2" : .iPhone12,
            "iPhone13,3" : .iPhone12Pro,
            "iPhone13,4" : .iPhone12ProMax,
            "iPhone14,2" : .iPhone13Pro,
            "iPhone14,3" : .iPhone13ProMax,
            "iPhone14,4" : .iPhone13Mini,
            "iPhone14,5" : .iPhone13
        ]

        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel.rawValue
                    }
                }
            }
            return model.rawValue
        }
        return Device.unknownDevice.rawValue
    }()
    
}

extension AppPlugin {
    func getBundleString(withKey key: String) -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
          let value = infoDictionary[key] as? String
          else { return "" }
        return value
    }

}
