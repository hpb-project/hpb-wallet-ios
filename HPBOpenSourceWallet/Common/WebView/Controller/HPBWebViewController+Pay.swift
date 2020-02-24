//
//  HPBWebViewController+Pay.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/7.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import HPBWeb3SDK

extension HPBWebViewController{

    /// 支付
    func startToPay(_ param: Any){
        guard let model = HPBBaseModel.mp_effectiveModel(result: param) as HPBPayReqModel? else {
            showBriefMessage(message: "Parameter error")
            return
        }
        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
        showConfirmView(model,fromAddress: fromAdd)
        
    }
    
    /// 弹框
    private func showConfirmView(_ model: HPBPayReqModel,fromAddress: String?){
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
            //验证支付白名单,通过后才能输入密码
            self.cheackPayWhiteList(toAddr: model.to){
                HPBAlertView.showPasswordAlert(in: self) {
                    guard let password = $0 else {return}
                    confirmVC.view.removeFromSuperview()
                    confirmVC.removeFromParentViewController()
                    self.creatTradeRequest(model, password: password)
                }
            }
        }
        confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,model.to,model.amount,"Vote-Confirm-Receive".localizable,desc: model.dappName + model.desc)
        //HPB获取手续费，显示手续费
        HPBMainViewModel.getTradeFeeRequest(account: fromAddress, type: .transfer, success: { (feeModel) in
            let transferFee = HPBStringUtil.converDecimal(feeModel.gasPrice, feeModel.gasLimit, 0, type: .multiplying)
            let feeStr =  HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull + "HPB"
            confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,model.to,model.amount,feeStr,desc: model.dappName + model.desc)
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    /// 创建签名请求
    fileprivate func creatTradeRequest(_ model: HPBPayReqModel, password: String){
        showHudText( view: self.view)
        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
        //获取Nonce,防止界面停留
        HPBMainViewModel.getTradeFeeRequest(account: fromAdd, type: .transfer, success: {
            var otherParam: [String] = []
            otherParam.append(model.orderId)
            otherParam.append(model.notifyUrl)
            otherParam.append(model.desc)
            // 签名并发送
            let money =  HPBStringUtil.moneyFormatToString(value: model.amount)
            HPBMainViewModel.signContractTransaction(fromAddress: fromAdd, toAddress: model.to, constractAdd: HPBAPPConfig.webPayContractAddr, money: money, feeModel: $0, password: password,otherParam: otherParam,type: .webPay, success: { (signature) in
                //判断是否需要发送到主网
                if model.isSend{
                   self.sendSignatureRequest(model, signature: signature.addHexPrefix())
                }else{
                    hideHUD()
                    self.giveDataForPay(model, additon: signature.addHexPrefix())
                }
            }, failure: { (errorMsg) in
                showBriefMessage(message: errorMsg, view: self.view)
            })
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    
    /// 发送钱包签名
    fileprivate func sendSignatureRequest(_ model: HPBPayReqModel,signature: String){
        let (requestUrl,param) = HPBAppInterface.getCreatTrade(signature: signature)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD()
            if errorMsg != nil{
                showBriefMessage(message: errorMsg, view: self.view)
            }else{
                guard let txHash = result as? String else{return}
                hideHUD(view: self.view)
                 //调用H5成功回调
                self.giveDataForPay(model, additon: txHash)
                showBriefMessage(message: "Transfer-Submit".localizable, after: 1.5)
                NotificationCenter.default.post(name: Notification.Name.HPBTransferSuccess, object: nil)
            }
        }
    }
    
    
    /// 回传给HPB Sever订单信息
    fileprivate func callBackHPBSeverOrderInfo(_ model: HPBPayReqModel,hash: String){
        let (requestUrl,param) = HPBAppInterface.callBackOrderInfo(hash: hash, backUrl: model.notifyUrl, orderId: model.orderId)
        HPBNetwork.default.request(requestUrl,  parameters: param) { (result, errorMsg) in
            if errorMsg != nil{
                debugLog(errorMsg)
            }else{
                debugLog("Success")
            }
        }
    }
    
    /// 查看支付白名单
    fileprivate func cheackPayWhiteList(toAddr: String,success: (()->Void)? = nil){
        let (requestUrl,param) = HPBAppInterface.getCheckWhiteList(to: toAddr)
        HPBNetwork.default.request(requestUrl,  parameters: param) { (result, errorMsg) in
            if errorMsg != nil{
                showBriefMessage(message: errorMsg)
            }else{
                guard let state = result as? String else{return}
                if state == "1"{
                    success?()
                }else{
                  showBriefMessage(message: "Common-Pay-WhiteList-error".localizable)
                }
            }
        }
    }
    

}
