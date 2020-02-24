//
//  HPBMoneyStyleUtil.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/10.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation


class HPBMoneyStyleUtil{

    enum MoneyStyle: String{
        case rmb = "rmb"
        case usd = "usd"
        var index: Int{
            switch self {
            case .rmb:
                return 0
            case .usd:
                return 1
            }
        }
        
        var name: String{
            switch self {
            case .rmb:
                return "Common-Money-RMB"
            case .usd:
                return "Common-Money-USD"
            }
        }
    }
    
    
    static let share = HPBMoneyStyleUtil()
    var style: MoneyStyle = .rmb       //只是个默认值，初始化就直接会更新
    
    func showFormatMoney(_ cnyMoney: String?,_ usdMoney: String?) -> String{
        
        var showBalance = "≈ ¥ " + HPBStringUtil.converCustomMoneyFormat(cnyMoney.noneNull).noneNull
        if HPBMoneyStyleUtil.share.style == .usd{
            showBalance = "≈ $ " +  HPBStringUtil.converCustomMoneyFormat(usdMoney.noneNull).noneNull
        }
        return showBalance
    }

}


extension HPBMoneyStyleUtil{
    
    func initLocalStyle()  {
        if let styleIndex = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.appMoneyStyleKey) as? String,let localStyle = MoneyStyle(rawValue: styleIndex){
            self.style = localStyle
        }else{
            self.style = .rmb
        }
    }
}


extension HPBMoneyStyleUtil{
    
    
    func resetMoneyStyle(_ style: MoneyStyle){
        setMoneyStyleUserDefault(style)
        initLocalStyle()
        AppDelegate.shared.showMainViewController()
    }
    
    func setMoneyStyleUserDefault(_ style: MoneyStyle){
        UserDefaults.standard.set(style.rawValue, forKey: HPBUserDefaultsKey.appMoneyStyleKey)
        UserDefaults.standard.synchronize()
    }
}
