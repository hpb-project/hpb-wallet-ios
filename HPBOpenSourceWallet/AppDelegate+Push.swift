//
//  AppDelegate+Push.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if !HPBAPPConfig.isFormatEnvironment{
            let deviceTokenStr = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            print(deviceTokenStr)
        }
        UMessage.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
        completionHandler(.newData)
    }
    
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //点击通知的处理(即使应用在未打开的状态，点击通知栏进入，也会走此方法)
        //ios10以上，本地通知和远程通知合并，都会走上面的两个代理方法，可根据trigger去判断
         UMessage.setAutoAlert(false)
        let userInfo = response.notification.request.content.userInfo
        UMessage.didReceiveRemoteNotification(userInfo)
        localOrAPNsPushHandel(notification: response.notification)
        completionHandler()
    }
    
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //应用在前台的时候显示通知栏时会调用
        //设置应用在前台显示通知栏
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func localOrAPNsPushHandel(notification: UNNotification){
        if notification.request.trigger is UNPushNotificationTrigger{
            let content = notification.request.content
            if UIApplication.shared.applicationState != .active{
                print("【ios10设备】点击远程通知\n",content.subtitle,content.title,content.body)
            }else{
                print("【ios10设备】前台接到通知")
            }
            //必须是string类型,前台后台同时处理
            allPushHandel(content.userInfo)
        }else{
            //处理action(代码见上面UNNotificationAction介绍)
            print("处理本地推送")
        }
    }
    
    func allPushHandel(_ userinfo: [AnyHashable : Any]){
        if (userinfo["type"] as? String) == "News"{
            if let articleId = userinfo["article_id"] as? String{
                guard let tabbarController =  self.window?.rootViewController as? HPBTabBarController else{ return}
                tabbarController.selectedIndex = 1
                let newsNav = tabbarController.viewControllers?[1] as? HPBBaseNavigationController
                let newsVC = newsNav?.viewControllers[0] as? HPBNewsController
                newsVC?.receiveAPNsNotifation(articleId: articleId)
            }
        }
    }
}
