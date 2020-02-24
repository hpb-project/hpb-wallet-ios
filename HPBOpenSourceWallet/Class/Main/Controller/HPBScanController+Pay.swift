//
//  HPBScanController+Pay.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/18.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import HPBWeb3SDK

extension HPBScanController{
    
    /// 支付
    func startToPay(_ scanResult: String){
        let jsonStr = scanResult.replacingOccurrences(of: "https://www.hpb.io/client?pay=", with: "")
        guard let model = HPBPayReqModel(JSONString: jsonStr)else{
            self.reStartDevice()
            showBriefMessage(message: "参数错误,请重新扫描")
            return
        }
        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
        showConfirmView(model,fromAddress: fromAdd)
        
    }
    /// 弹框
   fileprivate func showConfirmView(_ model: HPBPayReqModel,fromAddress: String?){
        let confirmVC =  HPBTransferConfirmView()
        confirmVC.type = .transfer
        navigationController?.addChildViewController(confirmVC)
        navigationController?.view.addSubview(confirmVC.view)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        confirmVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        confirmVC.closeBlock = {[weak self] in
            guard let `self` = self else{return}
             self.reStartDevice()
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        confirmVC.confirmBlock = { [weak self] in
            guard let `self` = self else{return}
            HPBAlertView.showPasswordAlert(in: self) {
                guard let password = $0 else {return}
                confirmVC.view.removeFromSuperview()
                confirmVC.removeFromParentViewController()
                self.creatTradeRequest(model, password: password)
            }
        }
        confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,model.to,model.amount,"Vote-Confirm-Receive".localizable)
        //HPB获取手续费，显示手续费
        HPBMainViewModel.getTradeFeeRequest(account: fromAddress, type: .transfer, success: { (feeModel) in
            let transferFee = HPBStringUtil.converDecimal(feeModel.gasPrice, feeModel.gasLimit, 0, type: .multiplying)
            let feeStr =  HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull + "HPB"
            confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,model.to,model.amount,feeStr)
        }) { (errorMsg) in
             self.reStartDevice()
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    /// 创建签名请求
   fileprivate func creatTradeRequest(_ model: HPBPayReqModel, password: String){
        showHudText( view: self.view)
        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
        //获取Nonce,防止界面停留
        HPBMainViewModel.getTradeFeeRequest(account: fromAdd, type: .transfer, success: {
            guard let nonce = Web3Utils.parseToBigUInt("\($0.nonce)", units: .wei)else{return}
            // 签名并发送
            let money =  HPBStringUtil.moneyFormatToString(value: model.amount)
            HPBMainViewModel.signNomorlTransaction(nonce: nonce, fromAddress: fromAdd, toAddress: model.to, money: money, feeModel: $0, password: password, success: { (signature) in
                self.sendSignatureRequest(model, signature: signature.addHexPrefix())
            }, failure: { (errorMsg) in
                 self.reStartDevice()
                showBriefMessage(message: errorMsg, view: self.view)
            })
        }) { (errorMsg) in
             self.reStartDevice()
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    
    /// 发送钱包签名
   fileprivate func sendSignatureRequest(_ model: HPBPayReqModel,signature: String){
        let (requestUrl,param) = HPBAppInterface.getCreatTrade(signature: signature)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD()
            if errorMsg != nil{
                 self.reStartDevice()
                showBriefMessage(message: errorMsg, view: self.view)
            }else{
                guard let txHash = result as? String else{return}
                hideHUD(view: self.view)
                //调用H5成功回调
                showImage(text: "Transfer-Submit".localizable, statue: .success,after: 1.5)
                NotificationCenter.default.post(name: Notification.Name.HPBTransferSuccess, object: nil)
            }
        }
    }

}
