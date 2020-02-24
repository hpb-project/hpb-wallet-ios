//
//  Notification+Extension.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation


extension Notification.Name{
    
    //创建钱包成功
    static let HPBCreatWalletSuccess: Notification.Name = Notification.Name(rawValue: "HPBCreatWalletSuccess")
    
    //导入钱包成功
    static let HPBImportWalletSuccess: Notification.Name = Notification.Name(rawValue: "HPBImportWalletSuccess")
    
    //备份钱包成功 
    static let HPBBackupWalletSuccess: Notification.Name = Notification.Name(rawValue: "HPBBackupWalletSuccess")
    
    //修改名称成功
    static let HPBChangeNameSuccess: Notification.Name = Notification.Name(rawValue: "HPBChangeNameSuccess")
    
    //转账成功
    static let HPBTransferSuccess: Notification.Name = Notification.Name(rawValue: "HPBTransferSuccess")
    
    //删除成功
    static let HPBDeleteWalletSuccess: Notification.Name = Notification.Name(rawValue: "HPBDeleteWalletSuccess")
    
    //隐藏资产状态
    static let HPBHiddenAssert: Notification.Name = Notification.Name(rawValue: "HPBHiddenAssert")
    
    //更新系统消息小红点
     static let HPBHiddenRedPoint: Notification.Name = Notification.Name(rawValue: "HPBHiddenRedPoint")
    
    //显示悬浮红包
    static let HPBShowRedPacketButton: Notification.Name = Notification.Name(rawValue: "HPBShowRedPacketButton")
    
    //领取红包的时候,刚好在领取红包界面的时候,dismiss一下
    static let HPBReceiveRedPacketPage: Notification.Name = Notification.Name(rawValue: "HPBReceiveRedPacketPage")
    
    
}
