//
//  HPBSecureLoginController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/17.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSecureLoginController: HPBBaseTableController {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "SecureLogin-Title".localizable
        switchBtn.isOn = HPBLockManager.shared.secureLoginState
        let supportType =  HPBLockManager.deviceSupport()
        switch supportType {
        case .faceID:
            self.leftLabel.text = "SecureLogin-FaceID".localizable
        case .touchID:
             self.leftLabel.text = "SecureLogin-TouchID".localizable
        default:
            self.leftLabel.text = "SecureLogin-Password".localizable
        }
    }
    
    
    @IBAction func switchChange(_ sender: UISwitch) {
        
        if sender.isOn == true{

            HPBLockManager.unlockApp(self, success: {
                DispatchQueue.main.async {
                    showBriefMessage(message: "SecureLogin-Open".localizable)
                    HPBLockManager.setSecureLoginState(sender.isOn)
                }
            }) { (errorMsg) in
                DispatchQueue.main.async {
                    sender.isOn = false
                    HPBLockManager.setSecureLoginState(false)
                }
            }
        }else{
            HPBLockManager.setSecureLoginState(false)
        }
        
        
    }
    

}
