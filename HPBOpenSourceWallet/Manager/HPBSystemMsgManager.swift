//
//  HPBSystemMsgManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/21.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation

class HPBSystemMsgManager{
    
    static let share = HPBSystemMsgManager()
    var isShowRed: Bool = false
    var networkNumner: Int = -1

    fileprivate var localUserKey: String{
        let key = HPBLanguageUtil.share.language == .chinese ? HPBUserDefaultsKey.lastetMsgCNNumberKey : HPBUserDefaultsKey.lastetMsgENNumberKey
        return key
    }
    
    static func setRecentNumner(_ recentNumner: Int) {
        UserDefaults.standard.set(recentNumner, forKey: HPBSystemMsgManager.share.localUserKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getRecentNumber() -> Int{
        if let recentNumner = UserDefaults.standard.object(forKey: HPBSystemMsgManager.share.localUserKey) as? Int{
            return recentNumner
        }else{
            return 0
        }
    }

}
