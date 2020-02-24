//
//  HPBLabel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBLabel: UILabel {

    init(backgroundColor: UIColor = UIColor.clear,
         titleColor: UIColor = UIColor.white,
         fontValue: CGFloat = 13,
         content: String? = "",
         alignment: NSTextAlignment = NSTextAlignment.center) {
        super.init(frame: CGRect.zero)
        self.font = UIFont.systemFont(ofSize: fontValue)
        self.textColor  = titleColor
        self.backgroundColor  = backgroundColor
        self.text = content
        self.textAlignment = alignment
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
