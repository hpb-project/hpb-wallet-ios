//
//  HPBScanController+ColdWallet.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/2/12.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation

extension HPBScanController{
    
    func showColdSignConfirmView(_ strResult: String?){
        //分割形式
        //"\(gaslimit)#HPB#\(gasprice)#HPB#\(money)#HPB#\(fromAddress.noneNull)#HPB#\(toAddress)#HPB#\(signStr.noneNull)"
        let signDataStrs = strResult.noneNull.components(separatedBy: HPBAPPConfig.separatorStr)
        let fromAddress = signDataStrs[3]
        let toAddress = signDataStrs[4]
        let money = HPBStringUtil.moneyFormatToString(value: signDataStrs[2]).addMicrometerLevel()
        let gaslimit = signDataStrs[0]
        let gasprice = signDataStrs[1]
        let transferFee = HPBStringUtil.converDecimal(gasprice, gaslimit, 0, type: .multiplying)
        let transferFeeStr = HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull + "HPB"
        let confirmVC =  HPBTransferConfirmView()
        confirmVC.type = .signTransfer
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
            //签名数据直接发送
            confirmVC.view.removeFromSuperview()
            confirmVC.removeFromParentViewController()
            let signature = signDataStrs[5]
            HPBMainViewModel.sendHPBSignatureRequest(self, signature: signature, type: .signTransfer, success: nil, faile: {
              self.reStartDevice()
            })
            return
        }
        confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress,toAddress,money, transferFeeStr)
    }
}
