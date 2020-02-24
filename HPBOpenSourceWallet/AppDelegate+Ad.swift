//
//  AppDelegate+Ad.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/5.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import SDWebImage

extension AppDelegate{
    
    
    func initAdView(_ loadState: Bool){
        
        //如果有引导页的话就不执行(牵涉红包的问题,所以分开判断)
        if HPBGuideManager.shared.isShowGuideView(){
            return
        }else{
            //广告图没有下载成功 + 没有广告图
            //防止重叠,首次打开的时候就在所有加载完毕后再去检测
            if loadState == false{
                self.unlockAccount{                            //解锁界面,成功后显示广告页
                    HPBRedPacketManager.share.receiveRedPacket()
                }
                return
            }
        }
        //判断是否显示
        if HPBAdManager.share.isShowAd() == false{
            self.unlockAccount{                               //解锁界面,成功后显示广告页
                HPBRedPacketManager.share.receiveRedPacket()  //防止重叠,首次打开的时候就在所有加载完毕后再去检测
            }
            return
        }
        
        adController = HPBAdController()
        guard let adVC = adController else{return}
        self.window?.rootViewController?.view.addSubview(adVC.view)
        adVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        //加载成功后，记录当天日期
        HPBAdManager.share.recordTodayDate()
        //点击跳转界面的逻辑
        adVC.pushBlock = {[weak self] in
            self?.jumpPage()
        }
    }
    
    
    fileprivate func jumpPage(){
        guard let tabbarController =  self.window?.rootViewController as? HPBTabBarController else{ return}
        switch HPBAdManager.share.skipType {
            
        case .h5:
            //webview网页
            let  pushwebView = HPBWebViewController()
            pushwebView.url = HPBAdManager.share.model?.skipUrl ?? "http://hpb.io"
            pushwebView.webTitle = HPBStringUtil.noneNull(HPBAdManager.share.model?.name)
            pushwebView.hidesBottomBarWhenPushed = true
            pushwebView.animationNavgation = true
            let mainNav = tabbarController.viewControllers?[0] as? HPBBaseNavigationController
            mainNav?.pushViewController(pushwebView, animated: true)
        case .page:
            //新闻界面
            
            switch HPBAdManager.share.pageType{
            case .redPacket:
                tabbarController.selectedIndex = 1
                let newsNav = tabbarController.viewControllers?[1] as? HPBBaseNavigationController
                let newVC =  newsNav?.viewControllers[0] as? HPBNewsController
                newVC?.pushToIntealPage(type: .redPacket)
            case .transfer:
                tabbarController.selectedIndex = 0
                let mainNav = tabbarController.viewControllers?[0] as? HPBBaseNavigationController
                let mainVC =  mainNav?.viewControllers[0] as? HPBMainController
                mainVC?.pushToNextController(type: .transfer)
            }
            
        }
    }
    
 
    
}
