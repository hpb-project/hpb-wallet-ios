//
//  HPBColdImageCodeManager.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/11/1.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation

class HPBColdImageCodeManager {
    
     static let share = HPBColdImageCodeManager()
    
    func showClodWalletImageCode(_ qrCodeArr: [Any],type: HPBScanController.HPBScanType = .coldWalletSign,nav: UINavigationController?,success: ((String)-> Void)? = nil){
             if !JSONSerialization.isValidJSONObject(qrCodeArr){
                 return
             }
             //换成json的形式
           if let data = try? JSONSerialization.data(withJSONObject: qrCodeArr, options: .prettyPrinted),let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
             guard let sinatureCodeView =  HPBViewUtil.instantiateViewWithBundeleName(HPBSinatureCodeImageView.self, bundle: nil) as? HPBSinatureCodeImageView else{return}
                 sinatureCodeView.codeStr = jsonStr as String
                 AppDelegate.shared.window?.addSubview(sinatureCodeView)
                 sinatureCodeView.snp.makeConstraints { (make) in
                     make.edges.equalToSuperview()
                 }
                 sinatureCodeView.nextStepBlock = {
                 let scanVC =  HPBScanController()
                    scanVC.scanType = type
                    scanVC.successBlock = {
                        success?($0)
                    }
                    nav?.pushViewController(scanVC, animated: true)
             }
             }
          }
    
    
}
