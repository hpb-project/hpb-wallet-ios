//
//  HPBOpenSourceWalletHandelController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import MBProgressHUD
import AESCrypto
import RealmSwift

class HPBWalletHandelController: HPBBaseTableController {
    
    enum HPBFromSource{
        case managerWallet,other,coldWallet
    }
    var addressStr: String = ""
    fileprivate var walletModel: HPBWalletRealmModel?
    var from: HPBFromSource = .managerWallet
    @IBOutlet weak var walletNameField: HPBInputLimitField!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var backupMnemonicLabel: UILabel!
    @IBOutlet weak var deleteWalletLabel: UILabel!
    @IBOutlet weak var coldDeleteWalletLabel: UILabel!
    @IBOutlet weak var isBackupShow: UIButton!
    //本地化配置
    @IBOutlet weak var modifyPasswordLabel: UILabel!
    @IBOutlet weak var exportPrivateKeyLabel: UILabel!
    @IBOutlet weak var exportKstoreLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private var rowNumbers: [Int] = [Int](repeating: 0, count: 4)
    override func viewDidLoad() {
        super.viewDidLoad()
        walletNameField.keyboardToolbar.addDoneOnKeyboardWithTarget(self, action: #selector(iQDoneModifyName))
        steupLocalizable()
        baseInfoConfig()
        registerNotifation()
        if from == .other{
            autoSelectRow()
        }
    }
    
    @objc fileprivate func iQDoneModifyName(){
        
       _ = textFieldShouldReturn(self.walletNameField)
    }
    
    func autoSelectRow(){
        //自动选择备份助记词
        if self.tableView.numberOfRows(inSection: 0) == 3{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let index = IndexPath(row: 2, section: 0)
                self.tableView(self.tableView, didSelectRowAt: index)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func steupLocalizable(){
        self.modifyPasswordLabel.text = "WalletHandel-Change-Password".localizable
        self.exportPrivateKeyLabel.text = "WalletHandel-Export-PK".localizable
        self.exportKstoreLabel.text = "WalletHandel-Export-KS".localizable
        backupMnemonicLabel.text = "Mnemonics-Backup".localizable
        isBackupShow.setTitle("WalletHandel-No-Backup".localizable, for: .normal)
        deleteWalletLabel.text = "WalletHandel-Delete-Wallet".localizable
        coldDeleteWalletLabel.text = "WalletHandel-Delete-Wallet".localizable
    }
  
    
    private func baseInfoConfig(){
        do {
            let realm = try Realm()
            walletModel =  realm.object(ofType: HPBWalletRealmModel.self, forPrimaryKey: self.addressStr)
        }catch{
            return
        }
        guard let model = walletModel else{return}
        if model.isInvalidated{
            return
        }
        self.title =  "WalletHandel-Title".localizable
        self.addressLabel.text = model.addressStr
        self.walletNameField.text = model.walletName
        self.walletNameField.isEnabled = false
        self.walletNameField.delegate = self
        self.headImage.image = UIImage(contentsOfFile:HPBFileManager.getHeadImageDirectory() + model.headName.noneNull)
        if model.mnemonics.noneNull.isEmpty{
            self.isBackupShow.setTitle(nil, for: .normal)
            self.isBackupShow.isHidden = true
        }
         tableView.reloadData()
    }
    
    
    @IBAction func copyBtnClick(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.addressStr
        showBriefMessage(message: "Common-Copy-Success".localizable, view: self.view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HPBChangePasswordController{
            let mnemonicsVC = segue.destination as! HPBChangePasswordController
            mnemonicsVC.walletModel = self.walletModel
        }
    }
    
}


extension HPBWalletHandelController{
    
    fileprivate func registerNotifation(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeNameSuccess), name: Notification.Name.HPBChangeNameSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeNameSuccess), name: Notification.Name.HPBBackupWalletSuccess, object: nil)
    }
    
    @objc fileprivate func changeNameSuccess(){
        /* ”获取钱包基本信息，指针类型，所以不必重新赋值“，但是实际情况会发生错误，realm会出错，
         保险起见，还是重新回去*/
        baseInfoConfig()
    }
    
}


extension HPBWalletHandelController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch  from {
        case .managerWallet:
            return 2
        case .other:
            return 2
        case .coldWallet:
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  from {
        case .coldWallet:
            if section == 2{
                return 1
            }
            return 0
        default:
            if section == 0{
                if  HPBStringUtil.noneNull(self.walletModel?.mnemonics).isEmpty{
                    return 2
                }
                return 3
            }else{
                return 3
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch  from {
        case .coldWallet:
            deleteAlert()
        default:
            if indexPath.section == 0{
                //导出私钥
                if indexPath.row == 0 {
                    exportPrivateKey()
                }else if indexPath.row == 1{
                    exportKstore()
                }else if indexPath.row == 2{
                    backupWallet()
                }
            }else{
                if indexPath.row == 2 {
                    deleteAlert()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0 
    }
}


extension HPBWalletHandelController{
    
    @IBAction func modifyNameClick(_ sender: UIButton) {
        self.walletNameField.isEnabled = true
        self.walletNameField.becomeFirstResponder()
    }
    
    
}


extension HPBWalletHandelController{


    fileprivate func exportPrivateKey(){
        HPBAlertView.showPasswordAlert(in: self) {
            guard let model = self.walletModel,let password = $0 else {return}
            
            let  privateKeyDataResult = HPBWalletManager.exportPrivateKey(model.kstoreName.noneNull, password: password)
            if let privateKeyData = privateKeyDataResult.data{
                let exportVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBExportPrivateKeyController.self)) as!  HPBExportPrivateKeyController
                exportVC.privateKeyStr = privateKeyData.hexString
                self.navigationController?.pushViewController(exportVC, animated: true)
            }else{
                showBriefMessage(message: privateKeyDataResult.errorMsg, view: self.view)
            }
        }
    }
    
    
    fileprivate func exportKstore(){

         HPBAlertView.showPasswordAlert(in: self) {
            guard let model = self.walletModel,let password = $0 else {return}
            let KeystoreDataResult =  HPBWalletManager.exportKstore(model.kstoreName.noneNull, password: password)
            guard let KeystoreData = KeystoreDataResult.data else{
                showBriefMessage(message: KeystoreDataResult.errorMsg, view: self.view)
                return
            }
            let exportVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBExportKstoreController.self)) as!  HPBExportKstoreController
            let keystoreStr = NSString(data: KeystoreData, encoding: String.Encoding.utf8.rawValue) as String?
            exportVC.kstoreStr = keystoreStr
            self.navigationController?.pushViewController(exportVC, animated: true)

        }
    }
    
    
   fileprivate func backupWallet() {
        HPBAlertView.showPasswordAlert(in: self) {
            guard let model = self.walletModel,let password = $0 else {return}
            let decryptMne =  AESCrypt.decrypt(model.mnemonics.noneNull, password: password)
            let mnemosArr = decryptMne?.components(separatedBy: " ")
            if mnemosArr?.count == 12{    //为保持正确性更高，判断是否能生成12个单词的助记词字符串
                let mnemonicsVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBMnemonicsController.self)) as! HPBMnemonicsController
                mnemonicsVC.mnemonics = decryptMne
                mnemonicsVC.walletAddress = model.addressStr
                self.navigationController?.pushViewController(mnemonicsVC, animated: true)
            }else{
                showBriefMessage(message:  "WalletHandel-Password-Error".localizable, view: self.view)
            }
        }
    }
    
    
    fileprivate func deleteAlert(){
        switch  from {
        case .coldWallet:
            HPBAlertView.showNomalAlert(in: self, title: "Common-Tip".localizable, message: "WalletHandel-Delete-ColdWallet-Tip".localizable) {
                self.deleteWallet()
            }
        default:
            HPBAlertView.showPasswordAlert(in: self,title: "Common-Tip".localizable,message: "WalletHandel-Delete-Tip".localizable) {
                self.deleteWallet($0.noneNull)
            }
        }
    }

    
    private func deleteWallet(_ password: String = "") {
        guard let model = self.walletModel else{return}
        let _  = model.headName.noneNull
        var deleteResult: HPBWalletManager.WalletManagerResult?
        switch  from {
        case .coldWallet:
            deleteResult = HPBWalletManager.deleteColdWallet(model.addressStr.noneNull)
            self.navigationController?.popViewController(animated: true)

        default:
            showHudText(string: "WalletHandel-Deleting".localizable,view: self.view)
            deleteResult = HPBWalletManager.deleteWallet(model.kstoreName.noneNull,
                                                         address: model.addressStr.noneNull,
                                                         password: password)
            guard let result = deleteResult else{return}
            if result.state{
                //发送删除成功通知，刷新mannager
                NotificationCenter.default.post(name: Notification.Name.HPBDeleteWalletSuccess, object: nil)
                hideHUD(view: self.view)
                showImage(text: "WalletHandel-Delete-Success".localizable, statue: .success)
                self.navigationController?.popViewController(animated: true)
            }else{
                showBriefMessage(message: result.errorMsg, view: self.view)
            }
        }
    }

}

extension HPBWalletHandelController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.endEditing(true)
        if textField.text.noneNull.isEmpty{
            showBriefMessage(message: "Common-Name-Empty".localizable, view: self.view)
            textField.text = walletModel?.walletName
        }else{
            let updataNameResult = HPBWalletManager.updataWalletName(address: HPBStringUtil.noneNull(walletModel?.addressStr), walletName: textField.text.noneNull)
            if updataNameResult.state{
                guard let model = self.walletModel else{return true}
                let _  = model.headName.noneNull
                HPBHeaderManager.randomGeneratHeadimageName(textField.text.noneNull, address: model.addressStr.noneNull)
                NotificationCenter.default.post(name: Notification.Name.HPBChangeNameSuccess, object: nil)
                showImage(text: "WalletHandel-Modify-Success".localizable, statue: .success, view: self.view)
            }else{
                showImage(text: "WalletHandel-Modify-Faile".localizable, statue: .faile, view: self.view)
            }
        }
        return true
    }
}
