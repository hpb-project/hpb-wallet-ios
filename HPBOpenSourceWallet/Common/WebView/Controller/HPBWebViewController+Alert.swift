//
//  HPBWebViewController+Alert.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/2.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import WebKit


extension HPBWebViewController: WKUIDelegate{
    // 监听通过JS调用警告框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if message.isEmpty { return }
        if let controller = AppDelegate.shared.window?.rootViewController{
            HPBAlertView.showNomalAlert(in: controller, title: nil, message: message, onlyConfirm: true) {
                completionHandler()
            }
        }
    }
    
    // 监听通过JS调用提示框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        if message.isEmpty { return }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Common-Confirm".localizable, style: .default) { alertAction in
            completionHandler(true)
        }
        alert.addAction(action)
        let cancelAction = UIAlertAction(title: "Common-Cancel".localizable, style: .default) { alertAction in
            completionHandler(false)
        }
        alert.addAction(cancelAction)
        if let controller = AppDelegate.shared.window?.rootViewController{
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    // 监听JS调用输入框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        if prompt.isEmpty && defaultText.noneNull.isEmpty { return }
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.textColor = UIColor.paBlack
        }
        //确定按钮
        let sureAction = UIAlertAction(title: "Common-Confirm".localizable, style: .default) { action in
            var result:String? = nil
            if let fields = alert.textFields, !fields.isEmpty{
                result = fields.first?.text
            }
            completionHandler(result)
        }
        alert.addAction(sureAction)
        //取消按钮
        let cancel = UIAlertAction.init(title: "Common-Cancel".localizable, style:.cancel){(action:UIAlertAction)->()in
            completionHandler(nil)
        }
        alert.addAction(cancel)
        if let controller = AppDelegate.shared.window?.rootViewController{
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
