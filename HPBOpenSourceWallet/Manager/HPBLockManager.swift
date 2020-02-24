//
//  HPBLockManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/14.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import LocalAuthentication

class HPBLockManager{
    
    enum HPBSupportType {
        case faceID,touchID,none
    }
    
    static let shared: HPBLockManager = HPBLockManager()
    
    var secureLoginState: Bool{ //是否开启密码保护
        if let state = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.secureLoginKey) as? Bool{
            return state
        }
        return false
    }
    
    static func unlockApp(_ controller: UIViewController? = AppDelegate.shared.window?.rootViewController,success: @escaping ()->Void,faile: @escaping (String)->Void){
        let context = LAContext.init()
        let policy = LAPolicy.deviceOwnerAuthentication
        var error: NSError? = nil
        let isSupport = context.canEvaluatePolicy(policy, error: &error)
        if isSupport{
            let message = UIDevice.isIPHONE_X ? "Common-FaceID-Message".localizable : "Common-TouchID-Message".localizable
            context.evaluatePolicy(policy, localizedReason: message) { (state, error) in
                if state{
                  success()
                }else{
                    guard let errorCode = (error as NSError?)?.code else{return}
                    if errorCode == LAError.userCancel.rawValue{
                       faile("cancel")
                    }
                }
            }
        }else{
            guard let errorCode = (error as NSError?)?.code else{return}
            if #available(iOS 11.0, *) {
                if errorCode == LAError.biometryNotEnrolled.rawValue{
                   faile("TouchIdNotEnrolled") //未注册
                    touchIdOrFaceIDNotEnroll()
                }
            } else {
                if errorCode == LAError.touchIDNotEnrolled.rawValue{
                    faile("TouchIdNotEnrolled") //未注册
                     touchIdOrFaceIDNotEnroll()
                }
            }
          if errorCode == LAError.touchIDNotAvailable.rawValue{
                faile("The Device is not available")
            }
            faile("Not Support FaceID Or Touch ID")
        }
    }
    
    
    static func deviceSupport() -> HPBSupportType{
        let context = LAContext.init()
        let policy = LAPolicy.deviceOwnerAuthentication
        var error: NSError? = nil
        let isSupport = context.canEvaluatePolicy(policy, error: &error)
        if isSupport{
            if #available(iOS 11.0, *) {
                if context.biometryType == .faceID{
                    return .faceID
                }else{
                    return .touchID
                }
            } else {
                return .touchID
            }
        }else{
            return .none
        }
    }
    
    
    fileprivate static func touchIdOrFaceIDNotEnroll(){
        HPBAlertView.showNomalAlert(in: AppDelegate.shared.window?.rootViewController, title: "Common-Tip".localizable, message: "Common-TouchID-NotSet".localizable) {
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
    }
    
}


extension HPBLockManager{
    
     static func setSecureLoginState(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: HPBUserDefaultsKey.secureLoginKey)
        UserDefaults.standard.synchronize()
    }
}
