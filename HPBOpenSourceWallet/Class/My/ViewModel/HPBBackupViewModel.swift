//
//  HPBBackupViewModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/20.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit

protocol HPBCustomPopProtocol where Self: UIViewController{
    func popTodestinationVC()
}


extension HPBCustomPopProtocol {
    
    func popTodestinationVC(){
        guard let nav = self.navigationController else{return}
        if nav.viewControllers.count > 1{    //适配领取红包界面
            if ((nav.viewControllers[0] as? HPBStartReceiveController) != nil){
                 nav.popToRootViewController(animated: true)  //返回领取红包界面
            }else if ((nav.viewControllers[0] as? HPBMainController) != nil){
                nav.popToRootViewController(animated: true)  //返回钱包管理页
            }else if ((nav.viewControllers[2] as? HPBWalletHandelController) != nil){
                nav.popToViewController(nav.viewControllers[2], animated: true) //返回钱包操作
            }else if ((nav.viewControllers[1] as? HPBManageWalletController) != nil){
                nav.popToViewController(nav.viewControllers[1], animated: true)
            }else if (nav.viewControllers[0] as? HPBMyController) != nil{ //返回我的页面
                nav.popToRootViewController(animated: true)
            }else{
                nav.popToRootViewController(animated: true)
            }
        }
    }
}


