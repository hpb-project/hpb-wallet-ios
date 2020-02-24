//
//  UIColor+Extension.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/25.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /**
     创建颜色
     - parameter R: 红
     - parameter G: 绿
     - parameter B: 蓝
     - parameter A: 透明度
     */
    
    convenience init(R: Int, G: Int, B: Int, A: Float = 1.0) {
        self.init(red:   CGFloat(Float(R) / 255.0),
                  green: CGFloat(Float(G) / 255.0),
                  blue:  CGFloat(Float(B) / 255.0),
                  alpha: CGFloat(A))
    }
    
    convenience init(withRGBValue rgbValue: Int, alpha: Float = 1.0) {
        let r = ((rgbValue & 0xFF0000) >> 16)
        let g = ((rgbValue & 0x00FF00) >> 8)
        let b =  (rgbValue & 0x0000FF)
        self.init(R: r,
                  G: g,
                  B: b,
                  A: alpha)
    }
    
    static let paBackground         = UIColor.init(withRGBValue: 0xF5F5F5)  // controller 页面背景颜色
    static let hpbInputBackground   = UIColor.init(withRGBValue: 0xF5F5F8)  //输入控件的背景颜色
    static let paNavigationColor    = UIColor.init(withRGBValue: 0x2E2F47)  //导航条的背景颜色
  
    static let hpbCellSelectColor   = UIColor.init(withRGBValue: 0xF5F6F8)  // 点击cell颜色,和背景色搭配
    static let hpbPurpleColor       = UIColor.init(withRGBValue: 0x9C9EB9)  // 常用label的字体偏紫色颜色
    static let hpbBlueColor         = UIColor.init(withRGBValue: 0x4A5FE2)  // 常用蓝色字体
    static let hpbYellowColor       = UIColor.init(withRGBValue: 0xF5FF30)  // 常用label的字体黄色颜色
    static let hpbInputColor        = UIColor.init(withRGBValue: 0x66688F)  // 常用label的字体输入颜色
    static let paDividing           = UIColor.init(withRGBValue: 0xEAECEE)  // 分割线/边框/标签颜色
    static let hpbPlacehoderColor   =  UIColor.init(withRGBValue: 0xbebec3)
    static let hpbGrayColor        = UIColor.init(withRGBValue: 0x999999) 
    static let paBlack              = UIColor.init(withRGBValue: 0x353535)  // 黑色
    
    // UI改版1.5.0
    static let hpbNavigationColor    = UIColor.init(withRGBValue: 0x283041)   //新的导航条的背景颜色
    static let hpbSwitchTabNormalColor    = UIColor.init(withRGBValue: 0xBABDC1)   //Switch栏目未选中颜色
    static let hpbSwitchTabSelectColor    = UIColor.init(withRGBValue: 0x333333)   //Switch栏目选中颜色
    static let hpbNewInputColor           = UIColor.init(withRGBValue: 0x54658B)
    static let hpbBtnSelectColor          = UIColor.init(withRGBValue: 0x334364)  //按钮选中颜色
    static let hpbBtnNoColor              = UIColor.init(withRGBValue: 0x707b92)  //按钮不可点击颜色
    static let hpbBtnTitleNoColor         = UIColor.init(withRGBValue: 0xD4D7DE)  //按钮不可点击文字颜色
    
    //iOS13
    static let hpbWhite              = UIColor.init(withRGBValue: 0xFFFFFF)  // 白色

}
