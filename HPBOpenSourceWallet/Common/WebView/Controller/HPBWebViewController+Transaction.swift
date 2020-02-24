//
//  HPBWebViewController+Transaction.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/15.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import BigInt
import HPBWeb3SDK

extension HPBWebViewController{
    
    
    /// 支付
    func sendTransaction(_ param: Any){
        guard let model = HPBBaseModel.mp_effectiveModel(result: param) as HPBTransationReqModel? else {
            showBriefMessage(message: "Parameter error")
            return
        }
        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
        showTransactionConfirmView(model,fromAddress: fromAdd)
        
    }
    
    
    /// 弹框
    private func showTransactionConfirmView(_ model: HPBTransationReqModel,fromAddress: String?){
        let confirmVC =  HPBTransferConfirmView()
        confirmVC.type = .transfer
        confirmVC.isDappPay = true
        navigationController?.addChildViewController(confirmVC)
        navigationController?.view.addSubview(confirmVC.view)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        confirmVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        confirmVC.closeBlock = {[weak self] in
            guard let `self` = self else{return}
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        confirmVC.confirmBlock = { [weak self] in
            guard let `self` = self else{return}
            HPBAlertView.showPasswordAlert(in: self) {
                guard let password = $0 else {return}
                confirmVC.view.removeFromSuperview()
                confirmVC.removeFromParentViewController()
                self.creatTransactionSignature(model, password: password)
            }
        }
        confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,model.to,model.value,"Vote-Confirm-Receive".localizable,desc: model.dappName + model.desc)
        //HPB获取手续费，显示手续费
        HPBMainViewModel.getTradeFeeRequest(account: fromAddress, type: .transfer, success: { (feeModel) in
            let transferFee = HPBStringUtil.converDecimal(feeModel.gasPrice, feeModel.gasLimit, 0, type: .multiplying)
            let feeStr =  HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull + "HPB"
            confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,model.to,model.value,feeStr,desc: model.dappName + model.desc)
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    
    
    /// 创建签名请求
    fileprivate func creatTransactionSignature(_ model: HPBTransationReqModel, password: String){
        showHudText( view: self.view)
        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
        //获取Nonce,防止界面停留
        HPBMainViewModel.getTradeFeeRequest(account: fromAdd, type: .transfer, success: {
            // 签名并发送
            guard let nonce = Web3Utils.parseToBigUInt("\($0.nonce)", units: .wei)else{return}
            let data = Data.fromHex(model.data) ?? Data()
            var feeModel = $0
            feeModel.gasPrice = model.gasPrice
            feeModel.gasLimit = model.gas
            HPBMainViewModel.signNomorlTransaction(nonce: nonce, fromAddress: model.from, toAddress: model.to, money: model.value,data: data, feeModel: feeModel, password: password, success: { (signature) in
                //判断是否需要发送到主网
                if model.isSend{
                    self.sendTransationSignatureRequest(model, signature: signature.addHexPrefix())
                }else{
                    hideHUD()
                    self.giveDataForTransation(model, additon: signature.addHexPrefix())
                }
            }, failure: { (errorMsg) in
                showBriefMessage(message: errorMsg, view: self.view)
            })
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    
    /// 发送钱包签名
    fileprivate func sendTransationSignatureRequest(_ model: HPBTransationReqModel,signature: String){
        let (requestUrl,param) = HPBAppInterface.getCreatTrade(signature: signature)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD()
            if errorMsg != nil{
                showBriefMessage(message: errorMsg, view: self.view)
            }else{
                guard let txHash = result as? String else{return}
                hideHUD(view: self.view)
                //调用H5成功回调
                self.giveDataForTransation(model, additon: txHash)
                showBriefMessage(message: "Transfer-Submit".localizable, after: 1.5)
                NotificationCenter.default.post(name: Notification.Name.HPBTransferSuccess, object: nil)
            }
        }
    }
}



