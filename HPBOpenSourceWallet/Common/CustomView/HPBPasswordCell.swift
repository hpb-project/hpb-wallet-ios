//
//  HPBPawwordCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPasswordCell: HPBBaseTableCell {

    struct HPBPasswordCellModel {
        var title: String?
        var placehoder: String?
        var strengType: HPBPasswordView.HPBStrengViewType = .no
        var tipType: HPBPasswordView.HPBPasswordTipType = .no
        
        init(_ title: String? = nil, _ placehoder: String?,strengType: HPBPasswordView.HPBStrengViewType = .no,
             tipType: HPBPasswordView.HPBPasswordTipType = .no) {
            self.title = title
            self.placehoder = placehoder
            self.strengType = strengType
            self.tipType = tipType
        }
        
    }

    var textFieldContent: String{
        return passwordView.textFieldContent
    }

    var model: HPBPasswordCellModel?{
        willSet{
            guard let `newValue` = newValue else {
                return
            }
        passwordView.passwordViewModel = HPBPasswordView.HPBPasswordViewModel(newValue.title, newValue.placehoder,strengtype: newValue.strengType,tipType: newValue.tipType)
        }
    }
    
    lazy var passwordView: HPBPasswordView = {
     let passwordView =  HPBPasswordView(strengViewType: .no)
        return passwordView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         steupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         steupView()
    }
    
    func steupView(){
        self.selectionStyle = .none
        self.contentView.addSubview(passwordView)
        passwordView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    
}
