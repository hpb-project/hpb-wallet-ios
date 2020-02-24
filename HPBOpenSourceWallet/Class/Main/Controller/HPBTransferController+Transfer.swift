//
//  HPBTransferController+Transfer.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/15.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import BigInt
import HPBWeb3SDK

extension HPBTransferController{
    
    //HPB公链普通交易手续费
    func configHPBChainTradeFee(){
        HPBMainViewModel.getTradeFeeRequest(account: currentWalletInfo?.addressStr, type: .transfer, success: { (model) in
            self.transferFeeModel = model
            let transferFee = HPBStringUtil.converDecimal(model.gasPrice, model.gasLimit, 0, type: .multiplying)
            self.transferFeeContentLabel.text = HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull + "HPB"
            self.transferGas = transferFee
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    
    ///创建交易
    func creatTradeRequest(_ toAddress: String,money: String,password: String){
        showHudText( view: self.view)
        //获取Nonce
        HPBMainViewModel.getTradeFeeRequest(account: currentWalletInfo?.addressStr, type: .transfer, success: {
            guard let nonce = Web3Utils.parseToBigUInt("\($0.nonce)", units: .wei)else{return}
            switch self.recordTokenType{
            case .mainNet:
                //  主网签名并发送
                HPBMainViewModel.signNomorlTransaction(nonce: nonce, fromAddress: self.currentWalletInfo?.addressStr, toAddress: toAddress, money: money, feeModel: self.transferFeeModel, password: password, success: { (signature) in
                    self.sendSignatureRequest(signature.addHexPrefix())
                }, failure: { (errorMsg) in
                    showBriefMessage(message: errorMsg, view: self.view)
                })
            case .HRC20:
                HPBMainViewModel.signContractTransaction(fromAddress: self.currentWalletInfo?.addressStr, toAddress: toAddress, constractAdd:  self.hrcContractAddress.noneNull, money: "0", feeModel: self.transferFeeModel, password: password,otherParam:["\(self.recordTokenDecimals)",money] ,type:.hrc20Transfer, success: { (signature) in
                    self.sendSignatureRequest(signature.addHexPrefix())
                }, failure: { (errorMsg) in
                    showBriefMessage(message: errorMsg, view: self.view)
                })
            case .HRC721:
                let tokenID = self.selectERC721IDField.text.noneNull
                HPBMainViewModel.signContractTransaction(fromAddress: self.currentWalletInfo?.addressStr, toAddress: toAddress, constractAdd:  self.hrcContractAddress.noneNull, money: "0", feeModel: self.transferFeeModel, password: password,otherParam:[tokenID] ,type:.hrc721Transfer, success: { (signature) in
                    self.sendSignatureRequest(signature.addHexPrefix())
                }, failure: { (errorMsg) in
                    showBriefMessage(message: errorMsg, view: self.view)
                })
            }
            
            
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    
    ///发送HPB钱包签名
    func sendSignatureRequest(_ signature: String,type: HPBMainViewModel.HPBTransferType = .transfer){
        HPBMainViewModel.sendHPBSignatureRequest(self, signature: signature, type: type, success: {(sinature) in
            NotificationCenter.default.post(name: Notification.Name.HPBTransferSuccess, object: nil)
        }, faile: nil)
    }

    
}


extension HPBTransferController{
    
    func hrc20TokenTransferClick(){
        if commonJudgeTransferClick() == false{
          return
        }
        let formatRemandToken = HPBStringUtil.moneyFormatToString(value: self.remandToken.noneNull)
        let maxTransfer = HPBStringUtil.converCustomDigitsFormat(formatRemandToken,decimalCount: self.recordTokenDecimals).noneNull
        let formatMaxTransfer = HPBStringUtil.moneyFormatToString(value: maxTransfer)
        let nonmarlMoney = HPBStringUtil.moneyFormatToString(value: moneyTextfield.text.noneNull)
        if  nonmarlMoney.doubleValue == 0{
            showBriefMessage(message: "Transfer-Amount-Empty".localizable, view: self.view)
            return
        }else if HPBStringUtil.compare(nonmarlMoney, formatMaxTransfer) == .orderedDescending{
            showBriefMessage(message: "Transfer-Beyound-Amount".localizable, view: self.view)
            return
        }
        self.view.endEditing(true)
        let addressStr = addressfield.text.noneNull
        ///冷钱包转账
        if self.currentWalletInfo?.isColdAddress == "1"{
            
            guard let feeModel = transferFeeModel else{
                showBriefMessage(message: "Transfer-Get-Fee-Faile".localizable, view: self.view)
                return
            }
            
            let money = HPBStringUtil.moneyFormatToString(value: self.moneyTextfield.text.noneNull)
            let dataStr = HPBMainViewModel.transactionSinature(otherParam: ["\(self.recordTokenDecimals)",money,addressStr], constractAdd: self.hrcContractAddress.noneNull, type: .hrc20Transfer)
            let currentAddress = self.currentWalletInfo?.addressStr
            var qrCodeArr: [Any] = ["0"]
            let qrCodeDic: [String: String] = ["coin": self.recordTokenName,
                                               "cointype": "HRC-20",
                                               "from": currentAddress.noneNull,
                                               "to": addressStr,
                                               "gaslimt": feeModel.gasLimit,
                                               "gasprice": feeModel.gasPrice,
                                               "nonce": "\(feeModel.nonce)",
                "money": nonmarlMoney,
                "data": dataStr.noneNull,
                "contractAddress": self.hrcContractAddress.noneNull]
            qrCodeArr.append(qrCodeDic)
            if !JSONSerialization.isValidJSONObject(qrCodeArr){
                return
            }
            //换成json的形式
            if let data = try? JSONSerialization.data(withJSONObject: qrCodeArr, options: .prettyPrinted),let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                guard let sinatureCodeView =  HPBViewUtil.instantiateViewWithBundeleName(HPBSinatureCodeImageView.self, bundle: nil) as? HPBSinatureCodeImageView else{return}
                sinatureCodeView.codeStr = jsonStr as String
                AppDelegate.shared.window?.addSubview(sinatureCodeView)
                sinatureCodeView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                sinatureCodeView.nextStepBlock = {[weak self] in
                    let scanVC =  HPBScanController()
                    scanVC.scanType = .coldwalletTransfer
                    scanVC.successBlock = {
                        let signatureStr = $0
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                            self?.showColdCTransferConfirmView(signatureStr)
                        }
                    }
                    self?.navigationController?.pushViewController(scanVC, animated: true)
                }
                return
            }
        }
        showConfirmView(fromAddress: self.currentWalletInfo?.addressStr, toAddress: addressStr)
    }
    
    

    func hrc721TokenTransferClick(){
        if commonJudgeTransferClick() == false{
            return
        }
        let tokenID = self.selectERC721IDField.text.noneNull
        if tokenID.isEmpty{
            showBriefMessage(message: "Transfer-721-Transfer-ID-Empty-Tip".localizable, view: self.view)
            return
        }
         self.view.endEditing(true)
         let addressStr = addressfield.text.noneNull
        ///冷钱包转账
            if self.currentWalletInfo?.isColdAddress == "1"{
        
                guard let feeModel = transferFeeModel else{
                    showBriefMessage(message: "Transfer-Get-Fee-Faile".localizable, view: self.view)
                    return
                }
                
                let currentAddress = self.currentWalletInfo?.addressStr
                let dataStr = HPBMainViewModel.transactionSinature(otherParam: [tokenID,currentAddress.noneNull,addressStr], constractAdd: self.hrcContractAddress.noneNull, type: .hrc721Transfer)
                var qrCodeArr: [Any] = ["0"]
                let qrCodeDic: [String: String] = ["coin": self.recordTokenName,
                                                   "cointype": "HRC-721",
                                                   "from": currentAddress.noneNull,
                                                   "to": addressStr,
                                                   "gaslimt": feeModel.gasLimit,
                                                   "gasprice": feeModel.gasPrice,
                                                   "nonce": "\(feeModel.nonce)",
                    "money": tokenID,
                    "data": dataStr.noneNull,
                    "contractAddress": self.hrcContractAddress.noneNull]
                qrCodeArr.append(qrCodeDic)
                if !JSONSerialization.isValidJSONObject(qrCodeArr){
                    return
                }
                
                //换成json的形式
              if let data = try? JSONSerialization.data(withJSONObject: qrCodeArr, options: .prettyPrinted),let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                guard let sinatureCodeView =  HPBViewUtil.instantiateViewWithBundeleName(HPBSinatureCodeImageView.self, bundle: nil) as? HPBSinatureCodeImageView else{return}
                    sinatureCodeView.codeStr = jsonStr as String
                    AppDelegate.shared.window?.addSubview(sinatureCodeView)
                    sinatureCodeView.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                    sinatureCodeView.nextStepBlock = {[weak self] in
                    let scanVC =  HPBScanController()
                        scanVC.scanType = .coldwalletTransfer
                       scanVC.successBlock = {
                            let signatureStr = $0
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                                self?.showColdCTransferConfirmView(signatureStr)
                            }
                        }
                    self?.navigationController?.pushViewController(scanVC, animated: true)
                }
                return
                }
            }
         showConfirmView(fromAddress: self.currentWalletInfo?.addressStr, toAddress: addressStr)
    }
    
    /// 普通转账校验
    func nomalHPBTokenTransferClick(){
        let addressStr = addressfield.text.noneNull
        //输入的金额，转化为乘以18个0的数字
        let nonmarlMoney = HPBStringUtil.moneyFormatToString(value: moneyTextfield.text.noneNull)
        let transferFeeStr = self.transferFeeContentLabel.text
        if nonmarlMoney.doubleValue == 0{
            showBriefMessage(message: "Transfer-Amount-Empty".localizable, view: self.view)
            return
        }else if transferFeeStr == "kBI-lc-vb7.text".MainLocalizable{
            showBriefMessage(message: "Transfer-Get-Fee-Faile".localizable, view: self.view)
            return
        }
        let money = HPBStringUtil.converEthMoneyStr(nonmarlMoney)
        
        let maxTransfer = HPBStringUtil.converDecimal(self.remandToken.noneNull, transferGas, 0, type: .subtracting)
        if addressStr.isEmpty{
            showBriefMessage(message: "Transfer-Address-Empty".localizable, view: self.view)
            return
        }else if !HPBStringUtil.isValidAddress(addressStr){
            showBriefMessage(message: "Transfer-Address-inValid".localizable, view: self.view)
            return
        } else if HPBStringUtil.compare(money, maxTransfer) == .orderedDescending{
            showBriefMessage(message: "Transfer-Beyound-Amount".localizable, view: self.view)
            return
        }else if addressStr.lowercased() == currentWalletInfo?.addressStr?.lowercased(){
            showBriefMessage(message: "Transfer-No-ToMyself".localizable, view: self.view)
            return
        }
        self.view.endEditing(true)
        
        ///冷钱包转账
        if self.currentWalletInfo?.isColdAddress == "1"{
    
            guard let feeModel = transferFeeModel else{
                showBriefMessage(message: "Transfer-Get-Fee-Faile".localizable, view: self.view)
                return
            }
               
            let currentAddress = self.currentWalletInfo?.addressStr
            var qrCodeArr: [Any] = ["0"]
            let qrCodeDic: [String: String] = ["coin": "HPB",
                                               "cointype": "HPB",
                                               "from": currentAddress.noneNull,
                                               "to": addressStr,
                                               "gaslimt": feeModel.gasLimit,
                                               "gasprice": feeModel.gasPrice,
                                               "nonce": "\(feeModel.nonce)",
                "money": nonmarlMoney,
                "data": "",
                "contractAddress": self.hrcContractAddress.noneNull]
            qrCodeArr.append(qrCodeDic)
            if !JSONSerialization.isValidJSONObject(qrCodeArr){
                return
            }
            
            //换成json的形式
            if let data = try? JSONSerialization.data(withJSONObject: qrCodeArr, options: .prettyPrinted),let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                if let sinatureCodeView =  HPBViewUtil.instantiateViewWithBundeleName(HPBSinatureCodeImageView.self, bundle: nil) as? HPBSinatureCodeImageView{
                    sinatureCodeView.codeStr = jsonStr as String
                    AppDelegate.shared.window?.addSubview(sinatureCodeView)
                    sinatureCodeView.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                    sinatureCodeView.nextStepBlock = {[weak self] in
                        let scanVC =  HPBScanController()
                        scanVC.scanType = .coldwalletTransfer
                       scanVC.successBlock = {
                            let signatureStr = $0
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                                self?.showColdCTransferConfirmView(signatureStr)
                            }
                        }
                        self?.navigationController?.pushViewController(scanVC, animated: true)
                    }
                }
                return
            }
        }
        showConfirmView(fromAddress: self.currentWalletInfo?.addressStr, toAddress: addressStr)
    }
    
    
    private func commonJudgeTransferClick() -> Bool{
        
        let addressStr = addressfield.text.noneNull
        let transferFeeStr = self.transferFeeContentLabel.text
        if transferFeeStr == "kBI-lc-vb7.text".MainLocalizable{
            showBriefMessage(message: "Transfer-Get-Fee-Faile".localizable, view: self.view)
            return false
        }else if addressStr.isEmpty{
            showBriefMessage(message: "Transfer-Address-Empty".localizable, view: self.view)
            return false
        }else if !HPBStringUtil.isValidAddress(addressStr){
            showBriefMessage(message: "Transfer-Address-inValid".localizable, view: self.view)
            return false
        }else if addressStr.lowercased() == currentWalletInfo?.addressStr?.lowercased(){
            showBriefMessage(message: "Transfer-No-ToMyself".localizable, view: self.view)
            return false
        }else if self.recordTokenName.isEmpty{
            showBriefMessage(message: "Transfer-First-Select-Tip".localizable, view: self.view)
            return false
        }
        return true
    }
}

