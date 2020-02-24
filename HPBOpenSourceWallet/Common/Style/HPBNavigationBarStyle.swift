//
//  HPBNavigationBarStyle.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/20.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBNavigationBarStyle{
    
    enum HPBBarStyle{
        case white,black
    }
    
    
    static var barStyle: HPBBarStyle = .white
    
    
    static func setupStyle() {
        // UINavigationBar
        let textAttributes: [NSAttributedStringKey: AnyObject] = [
            NSAttributedStringKey.foregroundColor: UIColor.hpbWhite,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)
        ]
        UINavigationBar.appearance().tintColor = UIColor.hpbWhite
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().barTintColor = UIColor.paNavigationColor
    }
    
    
    static func setupStyleByNavigation(_ nav: UINavigationController?,barColor: UIColor = UIColor.paNavigationColor) {
        // UINavigationBar
        let textAttributes: [NSAttributedStringKey: AnyObject] = [
            NSAttributedStringKey.foregroundColor: UIColor.hpbWhite,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)
        ]
        nav?.navigationBar.tintColor = UIColor.hpbWhite
        nav?.navigationBar.titleTextAttributes = textAttributes
        nav?.navigationBar.barTintColor = barColor
        (nav as? HPBBaseNavigationController)?.isWhiteBar = false
        (nav as? HPBBaseNavigationController)?.navigationItem.leftBarButtonItem?.customView?.isHidden = false
    }
    
    static func setupWhiteStyleByNavigation(_ nav: UINavigationController?,barColor: UIColor = UIColor.hpbWhite){
        // UINavigationBar
        let textAttributes: [NSAttributedStringKey: AnyObject] = [
            NSAttributedStringKey.foregroundColor: UIColor.init(withRGBValue: 0x283041),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)
        ]
         nav?.navigationBar.tintColor = UIColor.init(withRGBValue: 0x283041)
        nav?.navigationBar.titleTextAttributes = textAttributes
        nav?.navigationBar.barTintColor = barColor
        (nav as? HPBBaseNavigationController)?.isWhiteBar = true
        (nav as? HPBBaseNavigationController)?.navigationItem.leftBarButtonItem?.customView?.isHidden = false

    }
    
    
}
