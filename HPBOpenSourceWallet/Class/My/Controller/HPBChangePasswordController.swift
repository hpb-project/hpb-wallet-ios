//
//  HPBChangePasswordController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import AESCrypto

class HPBChangePasswordController: HPBBaseTableController {

    var walletModel: HPBWalletRealmModel?

    @IBOutlet weak var oldPasswordCell: HPBPasswordCell!
    @IBOutlet weak var newPasswordCell: HPBPasswordCell!
    @IBOutlet weak var confirmPasswordCell: HPBPasswordCell!
    @IBOutlet weak var confirmBtn: HPBSelectImgeButton!
    @IBOutlet weak var bottomView: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "WalletHandel-Change-Password".localizable
         confirmBtn.setTitle("ChangePassword-Finish".localizable, for: .normal)
        steupView()
    }
    
    fileprivate func  steupView(){
        oldPasswordCell.model = HPBPasswordCell.HPBPasswordCellModel(nil
            , "ChangePassword-Current".localizable)
        newPasswordCell.model = HPBPasswordCell.HPBPasswordCellModel(nil,"ChangePassword-New".localizable, strengType: .had, tipType: .had)
        confirmPasswordCell.model = HPBPasswordCell.HPBPasswordCellModel(nil,"ChangePassword-Re-Enter".localizable)
        
        bottomView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height - UIScreen.navigationHeight - 250)
    }

    
    @IBAction func finishBtnClick(_ sender: UIButton) {
        
        let oldPassword = oldPasswordCell.textFieldContent
        let newPassword = newPasswordCell.textFieldContent
        let confimPassword = confirmPasswordCell.textFieldContent
        if oldPassword.isEmpty{
            showBriefMessage(message: "ChangePassword-Current-Empty".localizable, view: view)
            return
        }else if newPassword.isEmpty{
             showBriefMessage(message: "ChangePassword-New-Empty".localizable, view: view)
            return
        }else if oldPassword == newPassword{
            showBriefMessage(message: "ChangePassword-Cant-Same".localizable, view: view)
            return
        }else if confimPassword != newPassword{
            showBriefMessage(message: "Common-Notmatch".localizable, view: view)
            return
        }else if HPBPasswordStrengthUtil.verificatPassword(newPassword) == false{
            showBriefMessage(message: "Common-Password-8wei".localizable, view: view)
            return
        }else if HPBPasswordStrengthUtil.verificatMaxPassword(newPassword) == false{
            showBriefMessage(message: "Common-Password-20wei".localizable, view: view)
            return
        }
        //更新信息
        updateWalletInfo(oldPassword,newPassword)
    }
    
}

extension HPBChangePasswordController{
    
    fileprivate func updateWalletInfo(_ oldPassword: String,_ newPassword: String){
        guard let `walletModel` = walletModel else{return}
        showHudText(view: self.view)
        let result = HPBWalletManager.updataWalletPassword(walletModel, oldPassword: oldPassword, newPassword: newPassword) { (state, errorMsg) in
            if state{
                hideHUD(view: self.view)
                showImage(text: "ChangePassword-Change-Success".localizable)
                self.navigationController?.popViewController(animated: true)
                
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
        if !result.state{
             showBriefMessage(message: result.errorMsg, view: self.view)
        }
    }
    
}


