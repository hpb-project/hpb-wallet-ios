//
//  HPBInputLimitField.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/26.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBInputLimitField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        steupView()
    }
    
    var limitCount: Int = 12
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    func steupView(){
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
    }
    
    @objc func textFieldChange(userInfo: NSNotification){
        let str = self.text.noneNull
        if  str.count > limitCount {
            let index = str.index(str.startIndex, offsetBy:limitCount)
            let result = str.substring(to: index)
            self.text = result
        }
        
    }

}
