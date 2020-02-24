//
//  HPBImportViewModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/26.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class  HPBImportViewModel{

    //弹出‘超过钱包最大数量的’的提示框
    static func showAboveWalletsNumberAlert( vc: UIViewController) -> Bool{
        if let models = HPBUserMannager.shared.walletInfos{
            if models.count == 10{
                HPBAlertView.showNomalAlert(in: vc, message: "Common-Max-Wallet".localizable, onlyConfirm: true, complation: nil)
                return false
            }
            return true
        }
        return true
    }

}
