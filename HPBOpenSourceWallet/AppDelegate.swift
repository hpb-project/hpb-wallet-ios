//
//  AppDelegate.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var interfaceOrientation: UIInterfaceOrientation = .portrait
    var window: UIWindow?
    var adController: HPBAdController?
    var animationLogoVC: HPBAnimationLogoController?
    var lockVC: HPBLockController?
    var isEnterMainPage: Bool = false
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         
         HPBLanguageUtil.share.initLanguage()      //国际化语言初始化
         HPBMoneyStyleUtil.share.initLocalStyle()  // 美元和人民币初始化
         HPBNumberStyleUtil.share.initLocalStyle()
         HPBTokenManager.share.initLocalRecordTokenIDs()
         HPBNavigationBarStyle.setupStyle()
         IQKeyboardManager.shared.enable = true
         IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Common-IQ-Done".localizable
         configRealmDatabase()
        HPBAdManager.share.requestAdNetwork()   //请求开屏广告
        self.initAnimationLogo { (loadState) in //加载动画logo
           self.isEnterMainPage = true                //已经进入主页,状态位,要不进来就会显示红包
           self.initAdView(loadState)                 //显示广告页
           HPBGuideManager.shared.showGuideView(self.window?.rootViewController?.view) //显示引导页,有广告图的话,先显示引导页
        }
        //配置分享平台
        configUSharePlatforms()
        //注册通知
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
        }
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: nil) { (granted, error) in
        }

        return true
    }
    
    
    func showMainViewController() {
        let mainTabbarVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBTabBarController")
        window?.rootViewController = mainTabbarVC
    }
    
    func configRealmDatabase() {
        var config = Realm.Configuration(
            // 设置新的架构版本。必须大于之前所使用的，首次为0
            schemaVersion: 12,migrationBlock:{ migration, oldSchemaVersion in
                if (oldSchemaVersion < 12) {
                    // enumerateObjects(ofType:_:) 方法将会遍历
                    // 所有存储在 Realm 文件当中的 `Person` 对象
                    migration.enumerateObjects(ofType: HPBWalletRealmModel.className()) { oldObject, newObject in
                        newObject?["headName"] = HPBHeaderManager.randomGeneratHeadimageName(oldObject?["walletName"] as? String, address: oldObject?["addressStr"] as? String)
                    }
                }
        })
        config.fileURL = URL(fileURLWithPath: HPBFileManager.getRealmDataBasePath())
        // 通知 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
    }
    
    
    func configUSharePlatforms(){
        
        UMConfigure.initWithAppkey(HPBShareParamsStruct.kUMSocialKey, channel: "appstore")
        //微信聊天
        UMSocialManager.default().setPlaform(.wechatSession, appKey: HPBShareParamsStruct.kWXAppId, appSecret: HPBShareParamsStruct.kWXAppSecret, redirectURL: HPBAPPConfig.appDownloadUrl)
        
        //朋友圈
        UMSocialManager.default().setPlaform(UMSocialPlatformType(rawValue: 2)! , appKey: HPBShareParamsStruct.kWXAppId, appSecret: HPBShareParamsStruct.kWXAppSecret, redirectURL: HPBAPPConfig.appDownloadUrl)
        
        //QQ
        UMSocialManager.default().setPlaform(.QQ, appKey: HPBShareParamsStruct.kQQAppId, appSecret: HPBShareParamsStruct.kQQAppKey, redirectURL: HPBAPPConfig.appDownloadUrl)
        //新浪微博
        UMSocialManager.default().setPlaform(.sina, appKey: HPBShareParamsStruct.kSinaAppKey, appSecret: HPBShareParamsStruct.kSinaAppSecret, redirectURL: HPBAPPConfig.appDownloadUrl)
        
    }
    
   
    

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        if self.interfaceOrientation == .unknown{
            return .allButUpsideDown
        }else if self.interfaceOrientation == .landscapeRight{
            //Dapp横屏小游戏
           return .landscapeRight
        }else{
            return .portrait
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("EnterForeground")
        if self.isEnterMainPage{
            HPBRedPacketManager.share.receiveRedPacket()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("DidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

