//
//  HPBPasswordTipView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/28.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPasswordTipLabel: UILabel {

    init() {
        super.init(frame: CGRect.zero)
        steupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    fileprivate func steupView(){
        self.font = UIFont.systemFont(ofSize: 11)
        self.text = "Common-Recomend-Password".localizable
        self.textColor = UIColor.red
    }

}
