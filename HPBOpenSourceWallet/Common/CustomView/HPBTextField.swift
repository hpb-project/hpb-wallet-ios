//
//  HPBTextField.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/22.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        steupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    func steupView(){
        
        self.setPlaceHoder()
        self.tintColor = UIColor.hpbInputColor
        self.textColor = UIColor.hpbInputColor
        if let clearbtn = self.value(forKey: "_clearButton") as? UIButton{
           clearbtn.setImage(#imageLiteral(resourceName: "my_creat_clear"), for: .normal)
        }
    }
    
    func setPlaceHoder(_ color: UIColor = UIColor.hpbPlacehoderColor,fontScale: CGFloat = 13){
        self.attributedPlaceholder = NSAttributedString.placeHoderAttributedString(self.placeholder.noneNull, color: color, fontScale: fontScale)
    }
}
