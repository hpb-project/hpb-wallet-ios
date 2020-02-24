//
//  HPBiCouldManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/19.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation

class HPBiCouldManager{


   static func getiCouldState() -> Bool {
        if let recentNumner = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.iCouldBackupKey) as? Bool{
            return recentNumner
        }else{
            return false
        }
    }
    
   static func saveiCouldState(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: HPBUserDefaultsKey.iCouldBackupKey)
        UserDefaults.standard.synchronize()
    }



}
