//
//  HPBNewsViewModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/21.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation


class HPBNewsViewModel{
    
    static let bottomDatelineColor = UIColor.init(withRGBValue: 0xC5C9CD)
    
    
    static func timeAttributeStrColor(_ ddHHMM: (String,String,String)) -> NSAttributedString{
        let titileAttr = "News-Governance-Time-Left".localizable.attributeStrColorAndFont(bottomDatelineColor)
        let ddContentAttr = ddHHMM.0.attributeStrColorAndFont()
        let hhContentAttr = ddHHMM.1.attributeStrColorAndFont()
        let mmContentAttr = ddHHMM.2.attributeStrColorAndFont()
        
        var ddText = " 天 "
        var hhText = " 小时 "
        var mmText = " 分钟 "
        if HPBLanguageUtil.share.language == .english{
            ddText = " d "
            hhText = " h "
            mmText = " m "
        }
        let  ddTextAttr = ddText.attributeStrColorAndFont(bottomDatelineColor)
        let  hhTextAttr = hhText.attributeStrColorAndFont(bottomDatelineColor)
        let  mmTextAttr = mmText.attributeStrColorAndFont(bottomDatelineColor)
        
        let attrStr =  NSMutableAttributedString()
        attrStr.append(titileAttr)
        attrStr.append(ddContentAttr)
        attrStr.append(ddTextAttr)
        attrStr.append(hhContentAttr)
        attrStr.append(hhTextAttr)
        attrStr.append(mmContentAttr)
        attrStr.append(mmTextAttr)
        return attrStr
    }

}

