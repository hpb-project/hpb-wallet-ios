//
//  HPBAuthorizatManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/26.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation


class HPBAuthorizatManager{
    
    static func getAuthorrizaState(_ address: String,appid: String) -> Bool{
       let key = address.md5() + appid
       var listDic =  getAuthorizatList()
        if listDic.keys.contains(key) {
            return listDic["key"] ?? true
        }else{
            return false
        }
    }
    
    static func setAuthorrizaState(_ address: String,appid: String){
        let key = address.md5() + appid
        var listDic =  getAuthorizatList()
         listDic.updateValue(true, forKey: key)
        setAuthorizatList(listDic)
    }
    
    fileprivate static func setAuthorizatList(_ list: [String: Bool]) {
        UserDefaults.standard.set(list, forKey: HPBUserDefaultsKey.authorizListKey)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate static func getAuthorizatList() -> [String: Bool]{
        if let authorizatList = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.authorizListKey) as? [String: Bool]{
            return authorizatList
        }else{
            return [:]
        }
    }
    
}
