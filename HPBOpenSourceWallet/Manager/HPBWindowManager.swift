//
//  HPBWindowManager.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/24.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//  因为领取红包的时候
//  1. 如果有分享的界面,就先隐藏分享的界面(因为分享的界面也是加载在window.rootview)
//  2. 如果正在输密码的alert框的话,就隐藏alert框
//  3. 如果上个红包没领的话,就把上一个顶掉,只显示当前的最新的

import Foundation


class HPBWindowManager{
    
    static let share = HPBWindowManager()

    
     func hideAllViews(){
        
        //隐藏红包界面
        HPBRedPacketManager.share.hideRedpacketView()  //tag 60000 rootview
        
        //隐藏所有的密码弹框
        HPBPasswordAlertRecordAlert?.dismiss(animated: false, completion: nil)
        
       //隐藏分享
        HPBShareManager.shared.hideShareView() //tag 60001 rootview
        
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name.HPBReceiveRedPacketPage, object: nil) //tag 60002 window
    }
    
}
