//
//  HPBExportViewModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/18.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit

class  HPBExportViewModel{
    
    //弹出‘勿截图’的图片
    static func showAlert( vc: UIViewController,gestureEnble: Bool = true,content: String){
        let tipViewVC =   HPBTipProtectView()
        tipViewVC.content = content
        vc.navigationController?.addChildViewController(tipViewVC)
        vc.navigationController?.view.addSubview(tipViewVC.view)
        tipViewVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        vc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tipViewVC.confirmBlock = {[weak vc] in
            if gestureEnble{
                vc?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
}

