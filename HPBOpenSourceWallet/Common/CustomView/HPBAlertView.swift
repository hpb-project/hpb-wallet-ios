//
//  HPBAlertView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/18.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit


weak var HPBPasswordAlertRecordAlert: HPBPasswordAlertController?

class HPBAlertView{
    
    
    ///  带密码弹出框的Alert
    static func showPasswordAlert(in vc: UIViewController,
                                  title: String? = "Common-Password-Title".localizable,
                                  message: String? = "Common-Password-Title".localizable,
                                  statusBarStyle: UIStatusBarStyle = .lightContent,
                                  complation:((String?) -> Void)? = nil){
        
        HPBPasswordAlertRecordAlert?.dismiss(animated: false, completion: nil)
        let passwordAlertVC = HPBPasswordAlertController()
        passwordAlertVC.statusBarStyle = statusBarStyle
        AppDelegate.shared.window?.rootViewController?.addChildViewController(passwordAlertVC)
        AppDelegate.shared.window?.addSubview(passwordAlertVC.view)
        passwordAlertVC.configData(title: title, message: message, placehoderStr:  "Common-Password-enter-Placehoder".localizable)
        passwordAlertVC.confirmBlock = {
            complation?($0)
        }
        HPBPasswordAlertRecordAlert = passwordAlertVC
        passwordAlertVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
    }
    
    
    
      ///  普通Alert
    static func showNomalAlert(in vc: UIViewController?,
                               title:String? = nil,
                               okBtnTitle: String? = "Common-Confirm".localizable,
                               message: String? = nil,
                               onlyConfirm: Bool = false,
                               isLeftShow: Bool = false,
                               complation: (() -> Void)? = nil){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okBtnTitle, style: .destructive) { (action) in
            complation?()
        }
        alertController.addAction(okAction)

        
        //https://www.jianshu.com/p/51a7896d8f1c 文本左对齐
        if isLeftShow{
            var messageLabel: UILabel? = nil
            var messageSuperView: UIView? = alertController.view
            for _ in 0...4{
                messageSuperView = subView(view: messageSuperView)
            }
            if let superView = messageSuperView{
                if superView.subviews.count > 1{
                    messageLabel =  superView.subviews[1] as? UILabel
                }
            }
            messageLabel?.textAlignment = .left
        }
        
    
        if !onlyConfirm{
            let cancelAction = UIAlertAction(title: "Common-Cancel".localizable, style: .cancel){ (action) in
            }
            alertController.addAction(cancelAction)
        }
       
        vc?.present(alertController, animated: true, completion: nil)
    }
    
    
    static func subView(view: UIView?) -> UIView?{
        guard let view = view else{return nil}
        if !view.subviews.isEmpty{
            return view.subviews[0]
        }
        return nil
    }
    
}


