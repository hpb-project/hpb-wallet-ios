//
//  HPBImportMnemonicView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/10.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import HPBWeb3SDK
class HPBImportMnemonicView: UIView {
    
    @IBOutlet weak var startImportBtn: HPBBackImgeButton!
    @IBOutlet weak var mnemonicBackView: HPBMnemonicBackView!
    @IBOutlet weak var newPasswordView: HPBPasswordView!
    @IBOutlet weak var confirmPasswordView: HPBPasswordView!
    @IBOutlet weak var introduceBtn: UIButton!
    @IBOutlet var mnemonicFields: [UITextField]!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var selectMnemonicView: HPBSelectMnemonicView = {
        let selectMnemonicView = HPBViewUtil.instantiateViewWithBundeleName(HPBSelectMnemonicView.self, bundle: nil) as! HPBSelectMnemonicView
    
        mnemonicBackView.addSubview(selectMnemonicView)
      return selectMnemonicView
    }()


    
    
    var introduceBlock: (()->Void)?
    var importBlock: ((String,String,String)->Void)?
    var severBlock: (()->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "ImportWallet-Mnemonic-Top-Title".localizable
        introduceBtn.setTitleColor(UIColor.hpbBlueColor, for: .normal)
        introduceBtn.setTitleColor(UIColor.hpbBlueColor, for: .normal)
        introduceBtn.setTitle("ImportWallet-What-Mnemonic".localizable, for: .normal)

        startImportBtn.setTitle("ImportWallet-Btn-Title".localizable, for: .normal)
        mnemonicBackView.backgroundColor = UIColor.hpbInputBackground
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
        
        for textfield in mnemonicFields{
            textfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            textfield.delegate = self
            textfield.tintColor = UIColor.hpbInputColor
            textfield.textColor = UIColor.hpbInputColor
            textfield.backgroundColor = UIColor.white
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.paDividing.cgColor
            textfield.layer.cornerRadius = 4
        }
    }
    
    
    @IBAction func startImportClick(_ sender: UIButton) {
        let password = newPasswordView.textFieldContent
        let confirmPassword = confirmPasswordView.textFieldContent
        var content =  ""
        for field in self.mnemonicFields{
            if (field.text.noneNull as NSString).trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
                field.becomeFirstResponder()
                showBriefMessage(message: "ImportWallet-Mnemonic-Empty".localizable)
                return
            }
        }
        for index in 30000...30011{
            if let textField = mnemonicBackView.viewWithTag(index) as? UITextField{
             content.append((textField.text.noneNull as NSString).trimmingCharacters(in: CharacterSet.whitespaces))
            }
            if index < 30011{
                content.append(" ")
            }
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
        importBlock?(content,password,"")
    }
    
    
    @IBAction func instroduceClick(_ sender: UIButton) {
       introduceBlock?()
    }
    
    
 
}


extension HPBImportMnemonicView: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text.noneNull.isEmpty{
            selectMnemonicView.isHidden = true
        }else{
            self.textFieldDidChange(textField)
        }
        for field in mnemonicFields{
            field.layer.borderColor = UIColor.paDividing.cgColor
        }
        textField.layer.borderColor = UIColor.hpbBlueColor.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text.noneNull as NSString).trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            textField.becomeFirstResponder()
            return true
        }
        textField.resignFirstResponder()
        guard let nextField = mnemonicBackView.viewWithTag(textField.tag + 1) as? UITextField else { return true}
        nextField.becomeFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         selectMnemonicView.isHidden = true
         textField.layer.borderColor = UIColor.paDividing.cgColor
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if textField.text.noneNull.isEmpty{
           selectMnemonicView.isHidden = true
        }else{
            selectMnemonicView.isHidden = false
            let predicate = NSPredicate(format: "SELF beginswith %@",textField.text.noneNull)
            //此处报错是pod文件权限问题,在HPBWalletSDK的 words前添加public
            let fileArr = (BIP39Language.english.words as NSArray).filtered(using: predicate)
            selectMnemonicView.isHidden = fileArr.isEmpty
            selectMnemonicView.dataSource = fileArr as! [String]
            var vieHeight: CGFloat = 0
            if fileArr.count < 3{
                vieHeight = CGFloat(30 * fileArr.count)
            }else{
                vieHeight = 30 * 4
            }
            selectMnemonicView.snp.remakeConstraints { (make) in
                make.top.equalTo(textField.snp.bottom)
                make.left.right.equalTo(textField)
                make.height.equalTo(vieHeight)
            }
            selectMnemonicView.selectBlock = {[weak self] in
                self?.selectMnemonicView.isHidden = true
                textField.text = $0
            }
        }
      
    }
    
}
