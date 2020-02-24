//
//  HPBWebViewController+Callback.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/26.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//  HPBOpenSourceWallet -》-》 DAPP  对接传值回调

import Foundation


extension HPBWebViewController{

    ///  传递账户信息
    func requestAccount(){
        let address = (HPBUserMannager.shared.currentWalletInfo?.addressStr).noneNull
        var languageStr = "en"
        let languageType = HPBLanguageUtil.share.language
        if languageType == .chinese{
            languageStr = "cn"
        }
        
      let model =  HPBRequestAccountModel()
        model.language = languageStr
        model.account = address
        model.type = "getAccount"
        //原生调用h5或者请求接口
        self.webView.evaluateJavaScript("window.hpbweb3.getCallback('\(model.toJSONString().noneNull)')") { (response, error) in
            debugLog(response)
            debugLog(error ?? "success")
        }
    }

    
    /// 传递授权授权登录信息
    func giveDataToVerifyLogin(_ model: HPBLoginReqModel,signaure: String,timestamp: String){
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let nativeToh5Model = HPBLoginRespModel(model: model, sign: signaure, account: currentAddress.noneNull,timestamp: timestamp)
        let jsonStr = nativeToh5Model.toJSONString().noneNull
        //原生调用h5或者请求接口
        self.webView.evaluateJavaScript("window.hpbweb3.getCallback('\(jsonStr)')") { (response, error) in
            debugLog(response)
            debugLog(error ?? "success")
        }
    }
    
    /// 传递支付信息
    func giveDataForPay(_ model: HPBPayReqModel,additon: String?){
        let nativeToh5Model = HPBPayRespModel(model: model,
                                              txHash: additon,
                                              signature: additon,
                                              result: "1")
        let jsonStr = nativeToh5Model.toJSONString().noneNull
        //原生调用h5或者请求接口
        self.webView.evaluateJavaScript("window.hpbweb3.getCallback('\(jsonStr)')") { (response, error) in
            debugLog(response)
            debugLog(error ?? "success")
        }
    }
    
    
    /// 传递交易
    func giveDataForTransation(_ model: HPBTransationReqModel,additon: String?){
        
        let nativeToh5Model = HPBTransationRespModel()
        nativeToh5Model.txID = additon.noneNull
        nativeToh5Model.action = model.action
        let jsonStr = nativeToh5Model.toJSONString().noneNull
        //原生调用h5或者请求接口
        self.webView.evaluateJavaScript("window.hpbweb3.getCallback('\(jsonStr)')") { (response, error) in
            debugLog(response)
            debugLog(error ?? "success")
        }
    }
}


