//
//  HPBPrivacyPolicyView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPrivacyPolicyView: UIView {
    
    fileprivate var agreeBtn: UIButton = UIButton(type: .custom)
    fileprivate var showLabel: UILabel = UILabel()
    fileprivate var policyBtn: UIButton = UIButton(type: .custom)
    
    var agreeBlock: ((Bool) -> Void)?
    var policyBlock: (() -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        steupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    fileprivate func steupView(){
        self.addSubview(agreeBtn)
        self.addSubview(showLabel)
        self.addSubview(policyBtn)
        agreeBtn.layer.cornerRadius = 2
        agreeBtn.layer.masksToBounds = true
        agreeBtn.setImage(#imageLiteral(resourceName: "my_policy_no_select"), for: .normal)
        agreeBtn.setImage(#imageLiteral(resourceName: "my_policy_selected"), for: .selected)
        agreeBtn.isSelected = false
        let addtionalLeftStr =  HPBLanguageUtil.share.language == .chinese ? "《" : ""
        let addtionalRightStr = HPBLanguageUtil.share.language == .chinese ? "》" : ""
        policyBtn.setTitle(addtionalLeftStr + "Common-Sever-Privacy".localizable + addtionalRightStr, for: .normal)
        policyBtn.setTitleColor(UIColor.hpbBlueColor, for: .normal)
        showLabel.text = "Common-Agree-Privacy".localizable
        showLabel.textColor = UIColor.hpbPurpleColor
        showLabel.font = UIFont.systemFont(ofSize: 14)
        policyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        agreeBtn.addTarget(self, action: #selector(agreeBtnClick), for: .touchUpInside)
        policyBtn.addTarget(self, action: #selector(policyBtnClick), for: .touchUpInside)
        agreeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(agreeBtn.snp.height)
        }
        showLabel.snp.makeConstraints { (make) in
            make.left.equalTo(agreeBtn.snp.right)
            make.top.bottom.equalToSuperview()
        }
        policyBtn.snp.makeConstraints { (make) in
             make.top.bottom.equalToSuperview()
             make.left.equalTo(showLabel.snp.right)
             make.right.lessThanOrEqualTo(0)
        }
    }
    
    
    @objc func agreeBtnClick(sender: UIButton){
        sender.isSelected = !sender.isSelected
        agreeBlock?(sender.isSelected)
    }
    
    
    @objc func policyBtnClick(sender: UIButton){
         policyBlock?()
    }

}
