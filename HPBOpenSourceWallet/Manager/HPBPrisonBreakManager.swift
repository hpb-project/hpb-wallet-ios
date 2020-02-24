//
//  HPBPrisonBreakManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/8/31.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit


class HPBPrisonBreakManager{
    
   static let prisonBreak_tool_paths = [ "/Applications/Cydia.app",
                                 "/Library/MobileSubstrate/MobileSubstrate.dylib",
                                 "/bin/bash",
                                 "/usr/sbin/sshd",
                                 "/etc/apt" ];

   
    private static func isBreakOutPrison() -> Bool{
        
        // 方式1.判断是否存在越狱文件
        for path in prisonBreak_tool_paths{
            if FileManager.default.fileExists(atPath: path){
                return true
            }
        }
        
        // 方式2.判断是否存在cydia应用
        if let url =  URL(string: "cydia://"){
            if  UIApplication.shared.canOpenURL(url){
                return true
            }
        }
        
        // 方式3.读取系统所有的应用名称
        if FileManager.default.fileExists(atPath: "/User/Applications/"){
            return true
        }
        
        // 方式4.读取环境变量
        let env = getenv("DYLD_INSERT_LIBRARIES");
        if env != nil{
            return true
        }
        return false
    }
    
    
    static func judgePrisonBreakPhone(){
        if self.isBreakOutPrison(){
            HPBAlertView.showNomalAlert(in: AppDelegate.shared.window?.rootViewController, title: "Common-Tip".localizable, message: "Common-jailbroken-Phone".localizable, onlyConfirm: true) {
            }
        }
    }
}
