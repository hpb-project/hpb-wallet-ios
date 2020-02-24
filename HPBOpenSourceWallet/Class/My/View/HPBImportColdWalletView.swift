//
//  HPBImportColdWalletView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/22.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBImportColdWalletView: UIView {

    
    @IBOutlet weak var topAttentionLabel: UILabel!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var textView: HPBTextView!
    @IBOutlet weak var nameInputView: HPBInputView!
    @IBOutlet weak var startImportBtn: HPBBackImgeButton!
    @IBOutlet weak var introduceBtn: UIButton!
    var importBlock: ((String,String)->Void)?
    var introduceBlock: (()->Void)?
    var severBlock: (()->Void)?
    
    var content: String = ""{
        willSet{
            textView.placehoder = newValue.isEmpty ? "AddressBook-textView-Placehoder".localizable: ""
             textView.content = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        introduceBtn.setTitleColor(UIColor.hpbBlueColor, for: .normal)
        steupLocalizable()
        steupView()
    }
    
    fileprivate func  steupLocalizable(){
        topAttentionLabel.text = "ImportWallet-What-Cold-attention".localizable
        topTitleLabel.text = "ImportWallet-What-Cold-TopTip".localizable
        startImportBtn.setTitle("ImportWallet-Btn-Title".localizable, for: .normal)
        introduceBtn.setTitle("ImportWallet-What-ColdWallet".localizable, for: .normal)
        textView.placehoder = "ImportWallet-Cold-Placehoder".localizable
        nameInputView.inputModel = HPBInputView.HPBInputModel(nil, "CreatWallet-Name-Placehoder".localizable)
    }

    
    fileprivate func  steupView(){
        nameInputView.backgroundColor = UIColor.white
        textView.backgroundColor = UIColor.hpbInputBackground
        textView.textViewTextColor = UIColor.paNavigationColor
        let policyView = HPBPrivacyPolicyView()
        self.addSubview(policyView)
        policyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(startImportBtn.snp.top).offset(-20)
            make.height.equalTo(37)
        }
        policyView.agreeBlock = { [weak self] in
            self?.startImportBtn.isSelected = $0
            self?.startImportBtn.isUserInteractionEnabled = $0
        }
        policyView.policyBlock = { [weak self] in
            self?.severBlock?()
        }
    }
    
    
    @IBAction func importBtnClick(_ sender: UIButton) {
        
        let addressStr = textView.content.noneNull
        let nickName = nameInputView.textFieldContent
        if addressStr.isEmpty{
            showBriefMessage(message: "Common-Address-Empty-Tip".localizable, view: self)
            return
        }else if nickName.isEmpty{
            showBriefMessage(message: "Common-Name-Empty".localizable, view: self)
            return
        }else if !HPBStringUtil.isValidAddress(addressStr){
            showBriefMessage(message: "ImportWallet-Address-inValid".localizable, view: self)
            return
        }
        importBlock?(addressStr,nickName)
    }
    
    
    @IBAction func introuceBtnClick(_ sender: UIButton) {
        
       introduceBlock?()
    }
    
    
}
