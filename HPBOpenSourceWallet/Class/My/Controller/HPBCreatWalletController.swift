//
//  HPBCreatWalletController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/8.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import HPBWeb3SDK
import MBProgressHUD
import CryptoSwift
import AESCrypto




class HPBCreatWalletController: HPBBaseTableController {

    @IBOutlet weak var confirmPasswordCell: HPBPasswordCell!
    @IBOutlet weak var newPasswordCell: HPBPasswordCell!
    @IBOutlet weak var walletNameCell: HPBInputCell!
    @IBOutlet weak var creatBtn: HPBBackImgeButton!
    @IBOutlet weak var importBtn: UIButton!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CreatWallet-Title-Modify".localizable
        steupView()
        steupLocalizable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate func steupLocalizable(){
        creatBtn.setTitle("CreatWallet-Btn".localizable, for: .normal)
        importBtn.setTitle("ImportWallet-Import".localizable, for: .normal)
    }
    
    fileprivate func  steupView(){
    
        self.view.backgroundColor = UIColor.white
        walletNameCell.model = HPBInputView.HPBInputModel("CreatWallet-Name".localizable, "CreatWallet-Name-Placehoder".localizable, type: .had,15)
        newPasswordCell.model = HPBPasswordCell.HPBPasswordCellModel("CreatWallet-Password-Title".localizable, "CreatWallet-Password-Placehoder".localizable, strengType: .had, tipType: .had)
        confirmPasswordCell.model = HPBPasswordCell.HPBPasswordCellModel("Common-Confirm-Title".localizable, "Common-Confirm-Placehoder".localizable)
       
        let policyView = HPBPrivacyPolicyView()
        creatBtn.superview?.addSubview(policyView)
        policyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.creatBtn.snp.top).offset(-12)
            make.height.equalTo(37)
        }
        policyView.agreeBlock = { [weak self] in
            self?.creatBtn.isSelected = $0
            self?.creatBtn.isUserInteractionEnabled = $0
        }
        policyView.policyBlock = { [weak self] in
            let webView =   HPBWebViewController()
            webView.webTitle = "Common-Sever-Privacy".localizable
            webView.url = HPBWebViewURL.services.webViewUrllocalizable
            self?.navigationController?.pushViewController(webView, animated: true)
        }
        
        
    }
    @IBAction func createBtnClick(_ sender: UIButton) {
        
        let newPassword = newPasswordCell.textFieldContent
        let confimPassword = confirmPasswordCell.textFieldContent
        let  walletName = walletNameCell.textFieldContent
        if walletName.isEmpty{
            showBriefMessage(message: "Common-Name-Empty".localizable, view: view)
            return
        }else if walletName.count > 12{
            showBriefMessage(message: "CreatWallet-Name-12wei".localizable, view: view)
            return
        }else if newPassword.isEmpty{
            showBriefMessage(message: "Common-Password-Empty".localizable, view: view)
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

        //判断是否超过最大钱包数量
        if HPBImportViewModel.showAboveWalletsNumberAlert(vc: self){
            showHudText(string: "CreatWallet-Creating".localizable, view: self.view)
            self.password = newPassword
            createHPBWallet()
        }
    }
    
    @IBAction func importBtnClick(_ sender: UIButton) {
        let importVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBImportWalletController.self))
        self.navigationController?.pushViewController(importVC, animated: true)
    }
    
    
    fileprivate func createHPBWallet(){
        DispatchQueue.global().async {
            //生成助记词
            let result =  HPBWalletManager.generateMnemonics(){ (privateKey, mnemonic) in
                //Kstore存在本地
                let kstoreResult = HPBWalletManager.generateKstoreFileBy(privateKey, password: self.password) { (filename, address) in
                    self.creatSuccessCallBack(filename, address: address, mnemonic: mnemonic)
                }
                if !kstoreResult.state{
                    showImage(text: "CreatWallet-Failed-generate".localizable, statue: .faile, view: self.view)
                }
            }
            if result.state == false{
                showBriefMessage(message: result.errorMsg, view: self.view)
            }
        }
    }
    
    fileprivate func creatSuccessCallBack(_ filename: String,address: String,mnemonic: String) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            let  walletName = self.walletNameCell.textFieldContent
            //AES加密后存储在本地
            let  cryptMne =  AESCrypt.encrypt(mnemonic, password: self.password)
            let walletname = walletName
            let walletModel = HPBWalletRealmModel()
            //全部更新为小写存储在本地
            walletModel.configModel(address, kstoreName: filename, walletName: walletname, mnemonics: cryptMne,headName: HPBHeaderManager.randomGeneratHeadimageName(walletname, address: address))
            //保存到本地
            let storeResult =  HPBWalletManager.storeWalletInfo(walletModel)
            if storeResult.state{
                //保存为当前登陆的钱包,发送创建成功通知，刷新首页
                HPBWalletManager.storeCurrentWalletAddress(walletModel.addressStr)
                NotificationCenter.default.post(name: Notification.Name.HPBCreatWalletSuccess, object: nil)
                //跳转提示备份页面（Identifier在storyBoard设置）
                self.pushToBackUpWalletController(mnemonic: mnemonic, address: address)
            }else{
                showImage(text: "CreatWallet-Failed-create".localizable, statue: .faile, view: self.view)
            }
            self.view.endEditing(true)
        }
    }
    
    
    fileprivate func pushToBackUpWalletController(mnemonic: String,address: String){
        let backUpWallet = HPBControllerUtil.instantiateControllerWithIdentifier("HPBBackupWalletController") as! HPBBackupWalletController
        backUpWallet.mnemonics = mnemonic
        backUpWallet.walletAddress = address
        self.navigationController?.pushViewController(backUpWallet, animated: true)
    }
}


