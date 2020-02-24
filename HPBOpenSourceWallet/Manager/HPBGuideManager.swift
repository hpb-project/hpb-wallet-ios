//
//  HPBGuideManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/8/8.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class  HPBGuideManager{
    
    static let shared: HPBGuideManager = HPBGuideManager()
    var appVersion: String {
           if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
               return String(describing: appVersion)
           }
           return "1"
       }
    
    func isShowGuideView() -> Bool{
        let userDefault = UserDefaults.standard
        let recordeVersion = userDefault.string(forKey: "firstLaunch")
        let currentVersion = appVersion
        return recordeVersion != currentVersion
        
    }
    
    
    func showGuideView(_ view: UIView?) {
       
        if isShowGuideView(){
            if let window = view {
               let userDefault = UserDefaults.standard
               let currentVersion = appVersion
                userDefault.set(currentVersion, forKey: "firstLaunch")
                userDefault.synchronize()
                let guardView = HPBGuideView(frame:UIScreen.main.bounds)
                window.addSubview(guardView)
                guardView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
}
