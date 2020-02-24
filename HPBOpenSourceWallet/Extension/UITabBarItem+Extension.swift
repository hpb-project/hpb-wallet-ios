//
//  UITabBarItem+Extension.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import Foundation

extension UITabBarItem{
    
    func set(normalImage: UIImage, selectedImage: UIImage){
        self.image = normalImage.withRenderingMode(.alwaysOriginal)
        self.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        
    }
    
    func textColor(colorValue: Int, selectedColorValue: Int){
        let textColor = UIColor.init(withRGBValue: colorValue)
        let selectColor = UIColor.init(withRGBValue: selectedColorValue)
        setTitleTextAttributes([.foregroundColor:selectColor], for: .selected)
        setTitleTextAttributes([.foregroundColor:textColor], for: .normal)
    }
    
    convenience init(with title: String,nomal: UIImage,select: UIImage) {
        self.init()
        self.title = title
        textColor(colorValue: 0x999999, selectedColorValue: 0xFF6602)
        set(normalImage: nomal, selectedImage: select)
    }
}
