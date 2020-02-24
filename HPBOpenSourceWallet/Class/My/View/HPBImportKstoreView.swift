//
//  HPBImportKstoreView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBImportKstoreView: UIView {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textBackView: UIView!
    @IBOutlet weak var passwordBackView: HPBPasswordView!
    
    //本地化配置
    @IBOutlet weak var placehoderLabel: UILabel!
    @IBOutlet weak var importBtn: UIButton!
    @IBOutlet weak var introduceBtn: UIButton!
    @IBOutlet weak var topTipsLabel: UILabel!
    var importBlock: ((String,String)->Void)?
    var introduceBlock: (()->Void)?
    var severBlock: (()->Void)?
   
    
    var content: String = ""{
        willSet{
            placehoderLabel.isHidden = !newValue.isEmpty
            textView.text = newValue.localizable
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        steupLocalizable()
        textBackView.backgroundColor = UIColor.hpbInputBackground
        textView.backgroundColor = UIColor.hpbInputBackground
        textView.textColor = UIColor.paNavigationColor
        textView.tintColor = UIColor.paNavigationColor
        textView.delegate = self
        self.backgroundColor = UIColor.white
        let policyView = HPBPrivacyPolicyView()
        self.addSubview(policyView)
        policyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(passwordBackView.snp.bottom).offset(50)
            make.height.equalTo(37)
        }
        policyView.agreeBlock = { [weak self] in
            self?.importBtn.isSelected = $0
            self?.importBtn.isUserInteractionEnabled = $0
        }
        policyView.policyBlock = { [weak self] in
            self?.severBlock?()
        }
    }
    
    
    private func steupLocalizable(){
        
        importBtn.setTitle("ImportWallet-Btn-Title".localizable, for: .normal)
        passwordBackView.passwordViewModel = HPBPasswordView.HPBPasswordViewModel("Common-Confirm-Title".localizable, "Common-Password-enter-Placehoder".localizable)
        introduceBtn.setTitle("ImportWallet-What-Keystore".localizable, for: .normal)
        introduceBtn.setTitleColor(UIColor.hpbBlueColor, for: .normal)
        //topTipsLabel.text = "ImportKstore-Top-Tips".localizable
        placehoderLabel.textColor = UIColor.hpbPlacehoderColor
        placehoderLabel.text = "ImportKstore-Placehoder".localizable
    }
    
    
    @IBAction func importClick(_ sender: UIButton) {
        let kstore = textView.text ?? ""
        let password = passwordBackView.textFieldContent
        if kstore.isEmpty{
            showBriefMessage(message: "ImportWallet-Keystore-Empty".localizable, view: self)
            return
        }else if password.isEmpty{
            showBriefMessage(message: "Common-Password-Empty".localizable, view: self)
            return
        }
        importBlock?(kstore,password)
    }
 
    
    @IBAction func introduceBtnClick(_ sender: UIButton) {

        self.introduceBlock?()
    }
    
    
}

extension HPBImportKstoreView: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        self.placehoderLabel.isHidden = !textView.text.isEmpty
    }
}
