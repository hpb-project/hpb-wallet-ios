//
//  APPDelegate+AnimationLogo.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import SDWebImage

extension AppDelegate{
    
    func initAnimationLogo(finish: ((Bool)-> Void)?){
        
        animationLogoVC = HPBAnimationLogoController()
        guard let logoVC = animationLogoVC else{return}
        self.window?.rootViewController?.view.addSubview(logoVC.view)
        logoVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        logoVC.animationFinishBlock = {[weak logoVC] in
           
            if HPBAdManager.share.model?.state != "2" && HPBAdManager.share.model != nil{  //没上架广告图
                logoVC?.view.removeFromSuperview()
                finish?(false)
            }else if HPBAdManager.share.adImage != nil{  //广告图片已经下载好了
                logoVC?.view.removeFromSuperview()
                finish?(true)
            }else{
                //此次最多等待8s
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
                    if HPBAdManager.share.adImage == nil{  //还没下载好,或者没上架广告图
                        logoVC?.view.removeFromSuperview()
                       finish?(false)
                    }else{
                        logoVC?.view.removeFromSuperview()
                       finish?(true)
                    }
                }
            }
        }
    }
    
}
