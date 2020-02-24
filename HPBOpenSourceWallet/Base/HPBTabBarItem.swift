//
//  HPBTabBarItem.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/7.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTabBarItem: UITabBarItem {

    init(with title: String,normalImage: UIImage,selectImage: UIImage) {
        super.init()
        self.title = title
        setTextColor(colorValue: 0x999999, selectedColorValue: 0x252735)
        setTabImage(normalImage, selectImage)
        self.titlePositionAdjustment = UIOffsetMake(0, -3)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTabImage(_ normalImage: UIImage, _ selectedImage: UIImage){
        self.image = normalImage.withRenderingMode(.alwaysOriginal)
        self.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
    }
    
    func setTextColor(colorValue: Int, selectedColorValue: Int){
        let textColor = UIColor.init(withRGBValue: colorValue)
        let selectColor = UIColor.init(withRGBValue: selectedColorValue)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor:selectColor], for: .selected)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor:textColor], for: .normal)
        
    }
}
