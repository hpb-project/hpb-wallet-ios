//
//  HPBUserMannager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/20.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import RealmSwift

class HPBUserMannager {
    
    static let shared: HPBUserMannager = HPBUserMannager()
    //当前钱包信息
    var currentWalletInfo: HPBWalletRealmModel? = HPBWalletManager.getCurrentWalletInfo()
    
    //所有钱包信息
    var  walletInfos: Results<HPBWalletRealmModel>?  =  HPBWalletManager.getAllWalletInfo()
    
    
    init() {
        registerNotifation()
    }
    
    fileprivate func registerNotifation(){
        NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBCreatWalletSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBImportWalletSuccess, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBDeleteWalletSuccess, object: nil)
    }

    @objc fileprivate func walletHandel(){
        
        //realm数据库检索结果会实时更新，所以获取所有全部钱包这一步可以去掉的
        //walletInfos =  HPBWalletManager.getAllWalletInfo()
        
        currentWalletInfo = HPBWalletManager.getCurrentWalletInfo()

    }
}
