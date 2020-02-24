//
//  HPBLanguageUtil.swift
//  LXLTest1
//
//  Created by 刘晓亮 on 2018/6/4.
//  Copyright © 2018年 朝夕网络. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift


class HPBLanguageUtil{
    
    //其他语言默认是英文
    enum LanguageType: String{
        case chinese   =  "zh-Hans"
        case english   =  "en"
        var index: Int{
            switch self {
            case .chinese:
                return 0
            case .english:
                return 1
            }
        }
        var name: String{
            switch self {
            case .chinese:
                return "LanguageUtil-Chinese"
            case .english:
                return "English"
            }
        }
        
        var redPacketStr: String{
            switch self {
            case .chinese:
                return "zh"
            case .english:
                return "en"
            }
        }
    }
    fileprivate var bundle: Bundle?
    static let share = HPBLanguageUtil()
    var language: LanguageType = .chinese    //只是个默认值，初始化就直接会更新
}

extension HPBLanguageUtil{
    
    func getStringForKey(_ key: String, _ table: String = "Localizable") -> String{
        
        if self.bundle != nil{
            return  NSLocalizedString(key, tableName: table, bundle: self.bundle!, comment: "")
        }
        return NSLocalizedString(key,comment: "")
        
    }
    
   fileprivate func localSetLanguage() -> LanguageType? {
        if let language = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.appLanguageKey) as? String{
            return LanguageType(rawValue: language)
        }
        return nil
    }
    
     func systemLanguage(){
        //["en-GB", "zh-Hans-GB", "zh-Hant-GB", "fr-GB", "pl-GB"]
        if let languageCodes = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String]{
            guard  !languageCodes.isEmpty else{ return}
            let code = languageCodes[0]
            if code.hasPrefix("zh-Hans"){
                // 第一次下载的时候是中文系统,显示中文和人民币
                language = .chinese
                HPBMoneyStyleUtil.share.setMoneyStyleUserDefault(.rmb)
            }else{
                language = .english
                HPBMoneyStyleUtil.share.setMoneyStyleUserDefault(.usd)

            }
        }
    }
}

extension HPBLanguageUtil{
    
    func initLanguage(){
        if let localSetlanguage = localSetLanguage(){
            language = localSetlanguage
        }else{
            self.systemLanguage()
        }
        let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj")
        if path != nil{
            self.bundle = Bundle(path: path!)
        }
    }
    
    func resetLanguage(_ language: LanguageType){
        setLanguageUserDefault(language)
        initLanguage()
        AppDelegate.shared.showMainViewController()
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Common-IQ-Done".localizable
    }
    
    
    func setLanguageUserDefault(_ language: LanguageType){
        UserDefaults.standard.set(language.rawValue, forKey: HPBUserDefaultsKey.appLanguageKey)
        UserDefaults.standard.synchronize()
    }
}
