//
//  HPBOpenSourceWalletNumnerManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/12.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation

class HPBWalletNumnerManager{
    
    //获取最近的使用的编号
    @discardableResult
    static func getRecentNumner() -> String {
        if let recentNumner = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.walletNumberKey) as? Int{
            setRecentNumner(recentNumner)
            return "\(recentNumner + 1)"
        }else{
            setRecentNumner(0)
            return "1"
        }
    }

    private static func setRecentNumner(_ recentNumner: Int) {
        UserDefaults.standard.set(recentNumner + 1, forKey: HPBUserDefaultsKey.walletNumberKey)
        UserDefaults.standard.synchronize()
    }
    
}
