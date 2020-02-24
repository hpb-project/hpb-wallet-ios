//
//  HPBNumberStyleUtil.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/6.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation


class HPBNumberStyleUtil{

    //金融分割符样式，一种是中国形式的，一种是德国样式的
    enum NumberStyle: String{
        case china = "comma"
        case germany = "dot"
        var index: Int{
            switch self {
            case .china:
                return 0
            case .germany:
                return 1
            }
        }
        var name: String{
            switch self {
            case .china:
                return "NumberStyle-Cell-China"
            case .germany:
                return "NumberStyle-Cell-germy"
            }
        }
        
        var example: String{
            switch self {
            case .china:
                return "12,345.67891234"
            case .germany:
                return "12.345,67891234"
            }
        }
        
        var thousandSeparator: String{
            switch self {
            case .china:
                return ","
            case .germany:
                return "."
            }
        }
        
        var dotSeparator: String{
            switch self {
            case .china:
                return "."
            case .germany:
                return ","
            }
        }
        
    }
    
    static let share = HPBNumberStyleUtil()
    var style: NumberStyle = .china       //只是个默认值，初始化就直接会更新

}


extension HPBNumberStyleUtil{

    func initLocalStyle()  {
        if let styleIndex = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.appNumberStyleKey) as? String,let localStyle = NumberStyle(rawValue: styleIndex){
            self.style = localStyle
        }else{
           self.style = .china
        }
    }
}


extension HPBNumberStyleUtil{

    
    func resetNumberStyle(_ style: NumberStyle){
        setNumberStyleUserDefault(style)
        initLocalStyle()
        AppDelegate.shared.showMainViewController()
    }

  fileprivate  func setNumberStyleUserDefault(_ style: NumberStyle){
        UserDefaults.standard.set(style.rawValue, forKey: HPBUserDefaultsKey.appNumberStyleKey)
        UserDefaults.standard.synchronize()
    }
}
