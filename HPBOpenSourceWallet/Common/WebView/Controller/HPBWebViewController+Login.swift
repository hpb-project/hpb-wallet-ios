//
//  HPBWebViewController+Extension.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/21.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//  DApp的H5第三方自定义签名授权登录

import Foundation
import HPBWeb3SDK
import BigInt


extension HPBWebViewController{
    
    /// 自定义签名登录
    func signToLogin(_ param: Any){

        guard let model = HPBBaseModel.mp_effectiveModel(result: param) as HPBLoginReqModel? else {
            showBriefMessage(message: "参数错误")
            return
        }
        showConfirmView(model: model)
        
    }
    
    private func showConfirmView(model: HPBLoginReqModel){
        let authLoginVC =  HPBAuthLoginController()
        navigationController?.addChildViewController(authLoginVC)
        if  navigationController?.view == nil{
            return
        }
        navigationController?.view.addSubview(authLoginVC.view)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        authLoginVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        authLoginVC.closeBlock = {[weak self] in
            guard let `self` = self else{return}
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        authLoginVC.confirmBlock = { [weak self] in
            guard let `self` = self else{return}
           self.showPasswordAlertToVefity(model,authLoginVC: authLoginVC)
        }
        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
        authLoginVC.model = HPBAuthLoginController.HPBConfirmModel(fromAdd.noneNull,model.loginMemo,model.dappName,model.dappIcon)
    }
    
    
    private func showPasswordAlertToVefity(_ model: HPBLoginReqModel,authLoginVC: UIViewController){
        HPBAlertView.showPasswordAlert(in: self,title: "Common-Auth-Alert-Title".localizable) {
            guard let password = $0 else {return}
            authLoginVC.view.removeFromSuperview()
            authLoginVC.removeFromParentViewController()
            //签名数据
            let timestamp = "\(Int(Date().timeIntervalSince1970))"
            let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
            HPBSignerManager.signLoginMsg(password, timestamp: timestamp, uuID: model.uuID, currentAddress: currentAddress, success: { (signagure) in
                if self.isIntercept{
                   showHudText(view: self.view)
                   self.interceptURL = self.url
                }
                
                // 验证签名给H5
                self.giveDataToVerifyLogin(model, signaure: signagure, timestamp: timestamp)
            }, failure: { (errorMsg) in
                showBriefMessage(message: errorMsg ,view: self.view)
            })
        }
    }
}
