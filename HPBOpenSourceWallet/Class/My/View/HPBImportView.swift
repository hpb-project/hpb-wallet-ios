//
//  HPBImportMnemonicView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBImportView: UIView {

    @IBOutlet weak var newPasswordView: HPBPasswordView!
    @IBOutlet weak var confirmPasswordView: HPBPasswordView!
    @IBOutlet weak var textViewBackView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placehoderLabel: UILabel!
    @IBOutlet weak var startImportBtn: UIButton!
    @IBOutlet weak var introduceBtn: UIButton!
    
    
    var content: String = ""{
        willSet{
            placehoderLabel.isHidden = !newValue.isEmpty
            textView.text = newValue
        }
    }
    
    
    var introduceBlock: (()->Void)?
    var importBlock: ((String,String,String)->Void)?
    var severBlock: (()->Void)?

    override func awakeFromNib() {
        placehoderLabel.text = "ImportWallet-PK-Placehoder".localizable
        introduceBtn.setTitle("ImportWallet-What-PK".localizable, for: .normal)
        placehoderLabel.textColor = UIColor.hpbPlacehoderColor
        introduceBtn.setTitleColor(UIColor.hpbBlueColor, for: .normal)
        startImportBtn.setTitle("ImportWallet-Btn-Title".localizable, for: .normal)
        textViewBackView.backgroundColor = UIColor.hpbInputBackground
        textView.backgroundColor = UIColor.hpbInputBackground
        textView.tintColor = UIColor.paNavigationColor
        textView.textColor = UIColor.paNavigationColor
        textView.delegate = self
        self.backgroundColor = UIColor.white
        steupView()
    }
    
    fileprivate func  steupView(){
        newPasswordView.passwordViewModel = HPBPasswordView.HPBPasswordViewModel(strengtype: .had, tipType: .had)
        confirmPasswordView.passwordViewModel = HPBPasswordView.HPBPasswordViewModel("Common-Confirm-Title".localizable, "Common-Confirm-Placehoder".localizable)
        
        let policyView = HPBPrivacyPolicyView()
        self.addSubview(policyView)
        policyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(confirmPasswordView.snp.bottom).offset(50)
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
    

    
    @IBAction func startImportClick(_ sender: UIButton) {
        
        let content = textView.text ?? ""
        let password = newPasswordView.textFieldContent
        let confirmPassword = confirmPasswordView.textFieldContent
        
        if content.isEmpty{
            showBriefMessage(message: "ImportWallet-Mnemonic-Empty".localizable, view: self)
            return
        }
        if password.isEmpty{
            showBriefMessage(message: "Common-Password-Empty".localizable, view: self)
            return
        }else if password != confirmPassword{
            showBriefMessage(message: "Common-Notmatch".localizable, view: self)
            return
        }else if HPBPasswordStrengthUtil.verificatPassword(password) == false{
            showBriefMessage(message: "Common-Password-8wei".localizable, view: self)
            return
        }else if HPBPasswordStrengthUtil.verificatMaxPassword(password) == false{
            showBriefMessage(message: "Common-Password-20wei".localizable, view: self)
            return
        }
        importBlock?(content.removeHexPrefix(),password,"")
    }
    
    @IBAction func introduceBtnClick(_ sender: UIButton) {
        introduceBlock?()
    }
}


extension HPBImportView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.placehoderLabel.isHidden = !textView.text.isEmpty
    }
}



