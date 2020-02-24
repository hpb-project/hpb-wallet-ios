//
//  HPBView.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit

class HPBButton: UIButton {
    
    var clickBlock: (() -> Void)? = nil
    func addClickEvent(click: (() -> Void)? = nil) {
        clickBlock = click
        self.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    @objc func clickButton() {
        if let clickBlock = clickBlock {
            clickBlock()
        }
    }
    
}

class HPBBackImgeButton: HPBButton{
    
    let normalColor: UIColor = UIColor.hpbBtnNoColor
    let selectColor: UIColor = UIColor.hpbBtnSelectColor
    //添加枚举，可以不让select的，不支持直接在xib中设置的，xib使用只能使用both
    enum HPBButtonImageType{
        case onlySelect,both
    }
    init(type: HPBButtonImageType = .both) {
        super.init(frame: CGRect.zero)
        steupButton(type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupButton()
    }

    func steupButton(_ type: HPBButtonImageType = .both){
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
         let selectImage = UIImage(color: selectColor, size: CGSize(width: 5.0, height: 5.0))
        if type == .both{
            let normalImage = UIImage(color: normalColor, size: CGSize(width: 5.0, height: 5.0))
            self.setTitleColor(UIColor.white, for: .selected)
            self.setBackgroundImage(selectImage, for: .selected)
            self.setTitleColor(UIColor.hpbBtnTitleNoColor, for: .normal)
            self.setBackgroundImage(normalImage, for: .normal)
            self.setTitleColor(UIColor.hpbBtnTitleNoColor, for: .highlighted)
            self.setBackgroundImage(normalImage, for: .highlighted)
        }else{
            self.setTitleColor(UIColor.white, for: .normal)
            self.setBackgroundImage(selectImage, for: .normal)
        }
    }
}


class HPBSelectImgeButton: HPBButton{
    //专为XIB设计
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let selectColor: UIColor = UIColor.hpbBtnSelectColor
        let selectImage = UIImage(color: selectColor, size: CGSize(width: 5.0, height: 5.0))
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setBackgroundImage(selectImage, for: .normal)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
    }

}
