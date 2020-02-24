//
//  HPBInputCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBInputCell: UITableViewCell {

    lazy var contentInputView: HPBInputView = {
        let contentInputView =  HPBInputView(type: .had)
        return contentInputView
    }()

    var textFieldContent: String{
        return contentInputView.textFieldContent
    }
  
    var model: HPBInputView.HPBInputModel?{
        willSet{
            contentInputView.inputModel = newValue
        }
    }

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
        self.contentView.addSubview(contentInputView)
        contentInputView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}
