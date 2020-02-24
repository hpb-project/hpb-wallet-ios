//
//  APPDelegate+Lock.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/25.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation

extension AppDelegate{
    
    func unlockAccount(finish: (()->Void)?){
        if HPBLockManager.shared.secureLoginState{
            
            //发现在iPhonex开机面容识别后,剪切板会意外被清空,不知道何原因,因此在此处仅从纪录一下
             let pasteboard = UIPasteboard.general
            HPBRedPacketManager.share.markCommandStr =  pasteboard.string.noneNull
            
            
            self.isEnterMainPage = false
            lockVC  = HPBControllerUtil.instantiateControllerWithIdentifier("HPBLockController") as? HPBLockController
            guard let `lockVC` = lockVC else{return}
            self.window?.rootViewController?.view.addSubview(lockVC.view)
            lockVC.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            lockVC.toWeakup()   //调用
            lockVC.finish = {[weak self] in
                self?.isEnterMainPage = true
                finish?()
            }
        }else{
            finish?()  //没有开启的话直接验证通过
        }
    }
   
}
