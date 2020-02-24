//
//  HPBSetDividendPresentController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/10.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class HPBSetDividendPresentController: UIViewController {
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var precentField: UITextField!
    @IBOutlet weak var centerTipLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
       var confirmBlock: ((String)->Void)?
    var recordKeybordHeight: CGFloat = 0
    var recordPrecentStr: String?
    var heightValue: CGFloat{
        get{ ///防止出错
            return self.bottomBackView.sd_height > 214 ?  self.bottomBackView.sd_height : 214
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupView()
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.configInitLayout()
    }

    @IBAction func confirmClick(_ sender: UIButton) {
      
        if precentField.text.noneNull.isEmpty{
            showBriefMessage(message: "News-Dividend-Set-Precent-Empty-Tip".localizable, view: self.view)
            return
        }
          tapDismiss()
        self.confirmBlock?(precentField.text.noneNull)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        
        tapDismiss()
    }
    
    func steupView(){
        topTitleLabel.text = "News-Dividend-Set-Reward-Precent".localizable
        centerTipLabel.text = "News-Dividend-Reset-7-Days".localizable
        confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
         cancelBtn.setTitle("Common-Cancel".localizable, for: .normal)
         self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        topView.addGestureRecognizer(tapgesture)
        bottomBackView.backgroundColor = UIColor.white
        bottomBackView.layer.cornerRadius = 12
        bottomBackView.layer.masksToBounds = false
        precentField.placeholder = self.recordPrecentStr
        NotificationCenter.default.addObserver(self, selector: #selector(frameChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange), name: NSNotification.Name.UITextFieldTextDidChange, object: precentField)
        
    }
    
    func configInitLayout(){
        self.bottomConstraint.constant = -UIScreen.height
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.bottomConstraint.constant = -self.heightValue
            self.view.layoutIfNeeded()
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
            self.bottomConstraint.constant = -self.heightValue
            self.view.layoutIfNeeded()
        }) {(state) in
            IQKeyboardManager.shared.enableAutoToolbar = true
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
  

}


extension HPBSetDividendPresentController{
    
     @objc func textFieldChange(userInfo: NSNotification){
        if let textfield = userInfo.object as? UITextField{
            
            if textfield.text.noneNull.intValue > 100{
                showBriefMessage(message: "News-Dividend-Reward-percentage-0-100".localizable)
                textfield.text = "\(100)"
            }
        }
        
    }
}
