//
//  HPBAlertController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/27.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class HPBPasswordAlertController: UIViewController {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordBackView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    
    var isAutoShowKeyBoard: Bool = false
    var statusBarStyle: UIStatusBarStyle = .lightContent
    var recordKeybordHeight: CGFloat = 0
    var confirmBlock: ((String)->Void)?
    var heightValue: CGFloat{
        get{ ///防止出错
            return self.bottomBackView.sd_height > 222 ?  self.bottomBackView.sd_height : 222
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return statusBarStyle
    }
    
    func configData(title: String?,
                    message: String?,
                    placehoderStr: String?){
        
        self.topTitleLabel.text  = title
        self.passwordTitleLabel.text = message
        self.passwordField.placeholder = placehoderStr
        configInitLayout()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        steupView()
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    
    @IBAction func confirmClick(_ sender: UIButton) {
        self.tapDismiss()
        let passwordStr = passwordField.text
        confirmBlock?(passwordStr.noneNull)
    }
    
    
    @IBAction func cencelClick(_ sender: UIButton) {
        
        self.tapDismiss()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
         self.tapDismiss()
    }
    
    func steupView(){
        confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
        cancelBtn.setTitle("Common-Cancel".localizable, for: .normal)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        topView.addGestureRecognizer(tapgesture)
        bottomBackView.backgroundColor = UIColor.white
        bottomBackView.layer.cornerRadius = 12
        bottomBackView.layer.masksToBounds = false
        passwordBackView.layer.borderWidth = 1
        passwordBackView.layer.borderColor = UIColor.init(withRGBValue: 0xDCDCDC).cgColor
        passwordBackView.layer.cornerRadius = 3
        passwordBackView.backgroundColor = UIColor.white
         NotificationCenter.default.addObserver(self, selector: #selector(frameChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func configInitLayout(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.bottomConstraint.constant = UIScreen.height
        self.view.layoutIfNeeded()
        if isAutoShowKeyBoard{
            self.passwordBackView.becomeFirstResponder()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.bottomConstraint.constant = self.heightValue
            self.view.layoutIfNeeded()
            self.passwordField.becomeFirstResponder()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (state) in
                
            })
        }
    }
    
    
    @objc fileprivate  func frameChange(_ notification:Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: TimeInterval((recordKeybordHeight / heightValue) * 0.3)) {
            if offsetY == 0 {
                self.recordKeybordHeight = 0
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }else{
                self.recordKeybordHeight = offsetY
                self.view.transform = CGAffineTransform(translationX: 0, y: offsetY)
            }
        }
    }


    
    @objc func tapDismiss(){
        self.view.endEditing(true)
        UIView.animate(withDuration: TimeInterval(0.3 + (recordKeybordHeight / heightValue) * 0.3), animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint.constant = self.heightValue
            self.view.layoutIfNeeded()
        }) {(state) in
             IQKeyboardManager.shared.enableAutoToolbar = true
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
}
