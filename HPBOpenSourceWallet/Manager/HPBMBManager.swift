//
//  PAMBManager.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/23.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import MBProgressHUD

let HPBMBProgressMsgTimeInterval : TimeInterval = 2.0

enum HPBMBProgressStatue{
    case success,faile
}


@discardableResult
func showHudText(string: String = "",view: UIView? = AppDelegate.shared.window) -> MBProgressHUD?{
    
    MBProgressHUD.hideAllHUDs(for: view, animated: false)
    let hud: MBProgressHUD = MBProgressHUD.showAdded(to: view!, animated: true)
    hud.detailsLabelText = string
    //hud.isUserInteractionEnabled = false
    hud.detailsLabelFont = UIFont.systemFont(ofSize: 14)
    hud.removeFromSuperViewOnHide = true
    return hud
}

func hideHUD(view: UIView? = AppDelegate.shared.window){
    
    MBProgressHUD.hideAllHUDs(for: view, animated: false)
}



@discardableResult
func showBriefMessage(message: String?, view: UIView? = AppDelegate.shared.window, after delay: TimeInterval =
    HPBMBProgressMsgTimeInterval) -> MBProgressHUD? {
    
    MBProgressHUD.hideAllHUDs(for: view, animated: false)
    let hud: MBProgressHUD = MBProgressHUD.showAdded(to: view ?? AppDelegate.shared.window, animated: true)
    hud.detailsLabelText = message ?? "网络请求失败，请检查网络"
    //hud.isUserInteractionEnabled = false
    hud.mode = .text
    hud.detailsLabelFont = UIFont.systemFont(ofSize: 14)
    hud.removeFromSuperViewOnHide = true
    hud.hide(true, afterDelay: delay)
    
    return hud
}


///显示图片
func showImage(text: String?,statue: HPBMBProgressStatue = .success,view: UIView? = AppDelegate.shared.window,after delay: TimeInterval =
    HPBMBProgressMsgTimeInterval) -> Void {
   
    MBProgressHUD.hideAllHUDs(for: view, animated: false)
    let hud: MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    hud.labelText = text
    //hud.isUserInteractionEnabled = false
    hud.labelFont = UIFont.systemFont(ofSize: 15)
    if statue == .success {
        hud.customView = UIImageView.init(image:#imageLiteral(resourceName: "mbprogress_success"))
    }else{
        hud.customView = UIImageView.init(image:#imageLiteral(resourceName: "mbprogress_failed"))
    }
    hud.mode = .customView
    hud.removeFromSuperViewOnHide = true
    hud.hide(true, afterDelay: delay)
}



