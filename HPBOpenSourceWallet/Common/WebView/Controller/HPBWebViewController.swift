//
//  HPBWebViewController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/20.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import WebKit


class HPBWebViewController: HPBBaseController,HPBRetryViewProtocol {
    
    enum HPBWebType{
        case normol,dApp
    }
    var webType: HPBWebType = .normol
    var url: String = ""
    var webTitle: String = ""
    //分享链接
    var additionTitle: String = ""
    var additionStr: String = ""
    //是否有打开外部浏览器的
    var isHaveRightItem: Bool = false
    //显示导航条
    var animationNavgation: Bool = false
    //是否需要横屏显示
    var landscapeRight: Bool = false
    
    // 是否是白色的返回按钮
    var isWhiteNavBtn: Bool = true
    
    // 拦截首个链接针对于平安互娱
    var interceptBlock: (()->Void)?
    var interceptURL: String = "none"
    var isIntercept: Bool = true
    
    var retryView: HPBRetryView?
    var successBlock: (() -> Void)?
    var sinatureBlock: ((String) -> Void)?
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if isWhiteNavBtn{
            return .lightContent
        }else{
            if #available(iOS 13, *){
                return .darkContent
            }
            return .default
        }
    }
    var webView: WKWebView = {
        let  webView =  WKWebView(frame: CGRect.zero)
        webView.isOpaque = false
        webView.backgroundColor = UIColor.paBackground
        return webView
        
    }()
    
    fileprivate var progressView: UIProgressView = {
        let progressView  = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor.clear
        progressView.progressTintColor = UIColor.hpbPurpleColor
        progressView.setProgress(0.1, animated: true)
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.webTitle
        if let requestUrl = URL(string: url){
            let request = URLRequest(url: requestUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
            configViews()
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.load(request)
            stuepNavigation()
        }
        if webType == .dApp{
            webView.configuration.userContentController.add(self, name: "getAccount")
            webView.configuration.userContentController.add(self, name: "signToLogin")
            webView.configuration.userContentController.add(self, name: "startToPay")
            webView.configuration.userContentController.add(self, name: "sendTransaction")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if animationNavgation{
            if !isWhiteNavBtn{
                HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
            }
           self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        if landscapeRight{
            AppDelegate.shared.interfaceOrientation = .landscapeRight
            UIDevice.current.setValue(NSNumber(integerLiteral: UIDeviceOrientation.landscapeRight.rawValue), forKey: "orientation")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if landscapeRight{
            AppDelegate.shared.interfaceOrientation = .portrait
            UIDevice.current.setValue(NSNumber(integerLiteral: UIDeviceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    fileprivate func  stuepNavigation(){
        navigationItem.leftBarButtonItem = customLeftBackButtonItem()
        //是否有右边的
        if self.isHaveRightItem{
            //DAPP右边的Item为打开外部浏览器的图标
            var imageName: UIImage?
            switch webType{
            case .dApp:
                imageName = UIImage(named: "news_dpp_safari")
            case .normol:
                imageName = UIImage(named: "main_receipt_share")
            }
            let barButtonItem = HPBBarButton.init(image: imageName,isHeadImage: false)
            barButtonItem.clickBlock = {[weak self] in
                self?.clickedRightNavItem()
            }
            self.navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    @objc fileprivate func  clickedRightNavItem(){
        
        switch webType{
        case .dApp:
            guard let openUrl = URL(string: self.url) else{return}
            if UIApplication.shared.canOpenURL(openUrl){
                UIApplication.shared.openURL(openUrl)
            }
        case .normol:
            let model = HPBShareLinkModel()
            model.webUrl = self.url
            model.title  = self.additionTitle
            model.content = self.additionStr
            HPBShareManager.shared.additionalInfo = model
            HPBShareManager.shared.show(.news, currentController: self)
        }
    }
    
    
    fileprivate func configViews(){
        self.view.addSubview(webView)
        webView.addSubview(progressView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        //webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        progressView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(2)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath  == "estimatedProgress"{
            if let newprogress = change?[NSKeyValueChangeKey.newKey] as? Double{
                if newprogress == 1{     // 加载完成
                    self.progressView.setProgress(Float(newprogress), animated: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                        self.progressView.isHidden = true
                        self.progressView.setProgress(0, animated: false)
                    }
                }else{
                    self.progressView.isHidden = false
                    self.progressView.setProgress(Float(newprogress), animated: true)
                }
            }
        }else if keyPath == "title" { // 标题
            //self.title = self.webView.title
        }else { // 其他
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        webView.scrollView.delegate = nil
    }
}

extension HPBWebViewController{
    
    fileprivate func customCloseButtonItem() -> UIBarButtonItem {
        let closeBt = UIButton(type: .custom)
        closeBt.setTitle("Common-Close".localizable, for: .normal)
        closeBt.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeBt.frame = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        
        if isWhiteNavBtn{
            closeBt.setTitleColor(UIColor.white, for: .normal)
        }else{
            closeBt.setTitleColor(UIColor.hpbNavigationColor, for: .normal)
        }
        closeBt.titleLabel?.textAlignment = .left
        closeBt.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        let closeItem = UIBarButtonItem(customView: closeBt)
        return closeItem
    }
    
    fileprivate func customLeftBackButtonItem() -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 35, height: UIScreen.navigationBarHeight)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        if isWhiteNavBtn{
            btn.setImage(#imageLiteral(resourceName:"back_leftBtn_white"), for: .normal)
        }else{
             btn.setImage(#imageLiteral(resourceName: "back_leftBtn_gray"), for: .normal)
        }
        btn.contentHorizontalAlignment = .left
        return UIBarButtonItem(customView: btn)
    }
    
   fileprivate func hideLeftBarButton(needHide:Bool){
        if needHide{
            navigationItem.leftBarButtonItems = [customLeftBackButtonItem()]
        } else {
            navigationItem.leftBarButtonItems = [customLeftBackButtonItem(),  customCloseButtonItem()]
        }
    }
    
    @objc func closeAction() {
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
   @objc func backAction(){
        if webView.canGoBack{
            webView.goBack()
            return
        }
        closeAction()
    }
    
    
}


extension HPBWebViewController: WKNavigationDelegate{
    

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideHUD(view: self.view)
        self.isHiddenRetryView(true, topView: webView)
         hideLeftBarButton(needHide: !webView.canGoBack)
         successBlock?()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLeftBarButton(needHide: !webView.canGoBack)
        self.isHiddenRetryView(false,topMagrn: 2, topView: webView){
            if !webView.canGoBack{
                if let requestUrl = URL(string: self.url){
                    let request = URLRequest(url: requestUrl)
                    webView.load(request)
                }
            }else{
                webView.reload()
            }
        }
    }
    
    //URL拦截
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url{
            if url.absoluteString.contains("//itunes.apple.com"){
                UIApplication.shared.openURL(url)
                decisionHandler(.cancel)
                return
            }else if url.absoluteString.contains(interceptURL){
                if webType == .dApp && self.isIntercept{
                    interceptURL = self.url
                    interceptBlock?()
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        decisionHandler(.allow)
    }
   
}


extension HPBWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "signToLogin":
            debugLog(message.body)
            signToLogin(message.body)
        case "getAccount":
            requestAccount()
        case "startToPay":
            debugLog(message.body)
            startToPay(message.body)
        case "sendTransaction":
            debugLog(message.body)
            sendTransaction(message.body)

        default:()
        }
    }
}
