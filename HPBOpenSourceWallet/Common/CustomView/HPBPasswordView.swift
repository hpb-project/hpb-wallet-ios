//
//  HPBPasswordView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/25.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPasswordView: UIView {

   private lazy var strengthView: HPBPasswordStrengthView =  {
        let strengthV = HPBPasswordStrengthView()
        strengthV.backgroundColor = UIColor.clear
        strengthV.frame = CGRect(x: 0, y: 0, width: 20, height: 48)
        return strengthV
    }()
    
    @IBOutlet weak var textField: HPBTextField!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var passwordTipLabel: HPBPasswordTipLabel!
    
    enum HPBStrengViewType{
        case had,no
    }
    enum HPBPasswordTipType{
        case had,no
    }
    
    struct HPBPasswordViewModel {
        var title: String?
        var placehoder: String?
        var strengViewType: HPBStrengViewType = .no
        var passwordTipType: HPBPasswordTipType = .no
        
        init(_ title: String? = "CreatWallet-Password-Title".localizable,_ placehoder: String? = "CreatWallet-Password-Placehoder".localizable.localizable,
             strengtype: HPBStrengViewType = .no,
             tipType: HPBPasswordTipType = .no){

            self.title = title
            self.placehoder = placehoder
            self.strengViewType = strengtype
            self.passwordTipType = tipType
        }
    }

    var passwordViewModel: HPBPasswordViewModel?{
        willSet{
            guard let `newValue` = newValue else {
                return
            }
            textField.placeholder = newValue.placehoder
            textField.setPlaceHoder()
            strengViewType = newValue.strengViewType
            passwordTipType = newValue.passwordTipType
        }
    }
    
    var textFieldContent: String{
        return textField.text.noneNull
    }
    fileprivate var strengViewType: HPBStrengViewType = .no
    fileprivate var passwordTipType: HPBPasswordTipType = .no
    
    init(strengViewType: HPBStrengViewType){
        super.init(frame: CGRect.zero)
         steupView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    

    func steupView(){
        let nib = UINib(nibName: "HPBPasswordView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        textField.delegate = self
        textField.leftViewMode = .always
    }
    
    
    
    @IBAction func rightBtnClick(_ sender: UIButton) {
        self.textField.isSecureTextEntry = sender.isSelected
        sender.isSelected =  !sender.isSelected
        
    }
    
}


extension HPBPasswordView: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.passwordTipType == .had{
            passwordTipLabel.isHidden = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.strengViewType == .had{
           textField.leftView = nil
        }
        
        if self.passwordTipType == .had{
            passwordTipLabel.isHidden = true
        }
    }
    
    @objc func textFieldChange(userInfo: NSNotification){
        if let textfield = userInfo.object as? UITextField{
            let strengthGrade = HPBPasswordStrengthUtil.judgePasswordStrength(password: textfield.text.noneNull)
            //没有设置就不显示
            if strengthGrade == .none || self.strengViewType == .no{
                textField.leftView = nil
            }else{
                textField.leftView = strengthView
                self.strengthView.strength = strengthGrade
            }
        }
    }
}
