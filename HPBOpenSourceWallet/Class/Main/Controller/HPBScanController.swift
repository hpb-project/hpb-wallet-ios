//
//  HPBScanController.swift
//  LXLTest1
//
//  Created by 刘晓亮 on 2018/5/29.
//  Copyright © 2018年 朝夕网络. All rights reserved.
//

import UIKit
import LBXScan
import SnapKit
import LBXPermission
import AudioToolbox

class HPBScanController: LBXScanViewController {
    
    enum HPBScanType{
        case scan              //首页的扫码
        case transfer          //转账界面的扫码
        case importKeyStore    //导入keystore时候的
        case importColdWallet  //导入冷钱包时候的
        case coldWalletSign    //冷钱包的签名(除了转账)
        case coldwalletTransfer //冷钱包转账
        case stringSinature    //字符串签名
        case addContract       //添加联系人地址
        case authorizedLogin   //扫码授权登录
        case qrCodePay         //扫码支付
    }
    
    ///通过扫描地址后，弹出选项
    enum HPBActionSheetType{
        case addContract       //选项卡-添加联系人
        case transfer          //选项卡-转账
        case seeInfo           //选项卡-查看信息
    }
    
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Scan-Top-Tip".localizable
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.width.equalTo(200)
            make.top.equalTo(40)
        }
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var remainMoney: String?  //剩余钱
    var locolPhoto: Bool = false
    var scanType: HPBScanType = .scan
    var isColdWallet: Bool = false
    var successBlock: ((String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scan-Title".localizable
        configScanView()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
             self.judgeAuthorize()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         HPBNavigationBarStyle.setupStyleByNavigation(self.navigationController)
         navigationController?.setNavigationBarHidden(false, animated: true)
        view.bringSubview(toFront: msgLabel)
        
    }
    
    
    fileprivate func judgeAuthorize(){
        LBXPermission.authorize(with: LBXPermissionType.camera) { (grand, first) in
            if !grand{
                let alertView = HPBPermissionView()
                self.view.addSubview(alertView)
                alertView.snp.makeConstraints{ (make) in
                    make.edges.equalToSuperview()
                }
                self.view.bringSubview(toFront: alertView)
            }
        }
    }
    
    fileprivate func judgeQrcodeLegality(_ result: String?) -> Bool{
        guard let `result` = result else{return false}
        
        if result.starts(with: HPBAPPConfig.appDownloadUrl + "?login="){
            self.scanType = .authorizedLogin
            return true
        }else if result.starts(with: HPBAPPConfig.appDownloadUrl + "?pay="){
            self.scanType = .qrCodePay
            return true
        }
    
        switch scanType {
        case .scan,.transfer,.addContract:
            if HPBStringUtil.isValidAddress(result){
                return true
            }else{
                showAlert(title: "Common-Tip".localizable, message: "HPBScanController-WrongCode-Tip".localizable)
                return false
            }
        case .coldWalletSign,.coldwalletTransfer:
            return true
        default:
            return true
        }
    }
}


extension HPBScanController{
    
    fileprivate func configNavigationItem(){
        let barButtonItem = HPBBarButton.init(title: "Scan-Album".localizable)
        barButtonItem.clickBlock = {[weak self] in
            self?.rightItemClicked()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func rightItemClicked() {
        self.locolPhoto = true
        self.openLocalPhoto(true)
    }
    
    
    fileprivate func configScanView(){
        self.libraryType = .SLT_ZXing
        self.style = HPBScanStyle.qrCodeScanStyle()
        self.isOpenInterestRect = true
        self.cameraInvokeMsg = "Scan-Start".localizable
    }
    
    fileprivate func showAlert(title: String?,message: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Scan-Confirm".localizable, style: .default) {(action) in
            self.reStartDevice()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func pushToNextController(type: HPBActionSheetType,strResult: String?){
        var destinationVC: UIViewController?
        switch type{
        case .transfer:
            let transferVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBTransferController.self)) as! HPBTransferController
            transferVC.scanResult = strResult
            transferVC.remandToken = self.remainMoney
            destinationVC = transferVC
        case .addContract:
            let addressBookVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBAddNewContractController.self))
            (addressBookVC as? HPBAddNewContractController)?.scanAddress = strResult
            (addressBookVC as? HPBAddNewContractController)?.sourceFrom = .scan
            destinationVC = addressBookVC
        case .seeInfo:
            let webView =   HPBWebViewController()
            webView.url = HPBAPPConfig.hpbscanAccountUrl + strResult.noneNull
            webView.webTitle = "Scan-ActionSheet-AccountInfo".localizable
            destinationVC = webView
        }
        if let `destinationVC` = destinationVC{
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
    }
}


extension HPBScanController: LBXScanViewControllerDelegate{
    
    func scanResult(with array: [LBXScanResult]!) {
        //识别失败
        if array == nil || array.count < 1 {
            showAlert(title: "Common-Tip".localizable, message: "Scan-Failed-Ident".localizable)
            return
        }
        //识别成功（ZXing能识别多个）
        let scanResult =  array[0]
        let strResult = scanResult.strScanned
        
        if !judgeQrcodeLegality(strResult){
            return
        }
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        switch scanType {
        case .transfer,.importKeyStore,.addContract,.importColdWallet:
            successBlock?(strResult.noneNull)
            navigationController?.popViewController(animated: true)
        case .scan:
            var transferItems = ["Main-Transfer".localizable,
                                 "AddressBook-AddNew".localizable,
                                 "Scan-ActionSheet-AccountInfo".localizable]
            if isColdWallet{
                transferItems = ["AddressBook-AddNew".localizable,"Scan-ActionSheet-AccountInfo".localizable]
            }
            let actionSheet = HPBActionSheetController()
            actionSheet.showActionSheet(transferItems) { (index) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (self.locolPhoto ? 1 : 0)) {
                    switch index{
                    case 0:
                        self.reStartDevice()
                    case 1:
                        if self.isColdWallet{
                            self.pushToNextController(type: .addContract, strResult: strResult)
                        }else{
                            self.pushToNextController(type: .transfer, strResult: strResult)
                        }
                    case 2:
                        if self.isColdWallet{
                            self.pushToNextController(type: .seeInfo, strResult: strResult)
                        }else{
                            self.pushToNextController(type: .addContract, strResult: strResult)
                        }
                    case 3:
                        self.pushToNextController(type: .seeInfo, strResult: strResult)
                    default:
                        break
                    }
                }
            }
        case .coldWalletSign:
            HPBAlertView.showNomalAlert(in: self, title: "Common-Tip".localizable, message: "Common-send-Signture".localizable) {
                self.reStartDevice()
                self.navigationController?.popViewController(animated: true)
                let sinatureStr = (strResult.noneNull as NSString).replacingOccurrences(of: HPBAPPConfig.coldSigntureStart, with: "")
                self.successBlock?(sinatureStr)
            }
            
        case .coldwalletTransfer:
            self.reStartDevice()
            self.navigationController?.popViewController(animated: true)
            let sinatureStr = (strResult.noneNull as NSString).replacingOccurrences(of: HPBAPPConfig.coldSigntureStart, with: "")
            self.successBlock?(sinatureStr)
            
        case .stringSinature:
            self.successBlock?(strResult.noneNull)
            self.navigationController?.popViewController(animated: false)
        case .authorizedLogin:
            let scanLoginVC = HPBScanLoginController()
            scanLoginVC.scanResult = strResult
            self.navigationController?.pushViewController(scanLoginVC, animated: true)
        case .qrCodePay:
            self.startToPay(strResult.noneNull)
            
        }
    }
}


extension HPBScanController{
    
    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.locolPhoto = false
        picker.dismiss(animated: true, completion: nil)
    }
    
}




