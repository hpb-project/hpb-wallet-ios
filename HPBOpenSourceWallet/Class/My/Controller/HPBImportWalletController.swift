//
//  HPBImportWalletController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//  目前导入助记词和kstore不支持二维码导入，暂且隐藏扫码按钮，方便以后添加

import UIKit
import IQKeyboardManagerSwift


class HPBImportWalletController: UIViewController,HPBCustomPopProtocol {
    
    enum HPBWalletImportType: String {
        case privateKey = "ImportWallet-PK-Title"
        case kStore     = "ImportWallet-Keystore-Title"
        case mnemonics  = "ImportWallet-Mnemonic-Title"
        case coldWallet = "ImportWallet-ColdWallet-Title"
    }
    lazy var switchViews: [UIView] = {
        return getSwitchViews()
    }()
    fileprivate var slideSwitchView: CKSlideSwitchView = {
        var slideView = CKSlideSwitchView(frame: CGRect(x:0, y:0, width:UIScreen.width, height:UIScreen.height-UIScreen.navigationHeight))
        slideView.tabItemTitleNormalColor = UIColor.hpbPurpleColor
        slideView.tabItemTitleSelectedColor = UIColor.hpbBtnSelectColor
        slideView.topScrollViewBackgroundColor = UIColor.white
        slideView.tabItemShadowColor = UIColor.hpbBtnSelectColor
        slideView.backgroundColor = UIColor.white
        //添加阴影
        slideView.topScrollView.layer.shadowColor = UIColor.black.cgColor
        slideView.topScrollView.layer.shadowOffset = CGSize(width: 0, height: 2)
        slideView.topScrollView.layer.shadowOpacity = 0.15
        slideView.topScrollView.layer.shadowRadius = 20
        slideView.topScrollView.layer.masksToBounds = false
        return slideView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var types: [HPBWalletImportType] = [.mnemonics,.kStore,.privateKey,.coldWallet]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ImportWallet-Import".localizable
         IQKeyboardManager.shared.keyboardDistanceFromTextField = 130
        steupSwitchView()
        configNavigationItem()
        if let gesutres = navigationController?.view.gestureRecognizers{
            for gesture in gesutres{
                if gesture is UIScreenEdgePanGestureRecognizer{
                    slideSwitchView.rootScrollView.panGestureRecognizer.require(toFail: gesture)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupStyleByNavigation(self.navigationController)
    }
    
    fileprivate func configNavigationItem(){
        let barButtonItem = HPBBarButton.init(image: #imageLiteral(resourceName: "main_transfer_nav"))
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedRightNavItem()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
    fileprivate func steupSwitchView(){
        view.addSubview(slideSwitchView)
        slideSwitchView.slideSwitchViewDelegate = self
        slideSwitchView.reloadData()
        slideSwitchView.bringSubview(toFront: slideSwitchView.topScrollView)
    }
    
    @objc fileprivate func clickedRightNavItem(){
        let  scanVC =  HPBScanController()
        scanVC.successBlock = {
            let slideViewIndex = self.slideSwitchView.selectedTabItemIndex
            guard let scrollow = self.slideSwitchView.contentView(ofIndex: slideViewIndex),scrollow.subviews.count > 0 else{
              return
            }
            let type = self.types[slideViewIndex]
            let subView = scrollow.subviews[0]
            switch  type{
            case .mnemonics:
                break
            case .kStore:
                let contentView = subView as! HPBImportKstoreView
                contentView.content = $0
            case .privateKey:
                let contentView = subView as! HPBImportView
                contentView.content = $0
            case .coldWallet:
                let contentView = subView as! HPBImportColdWalletView
                contentView.content = $0
            }
        }
        scanVC.scanType = .importKeyStore
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    fileprivate func getSwitchViews() -> [UIView]{
        let importMnemonicView = getImportMnemonicView()
        let importKstoreView  = getImportKstoreView()
        let importPrivateView = getImportPrivateView()                      
        let coldWalletView =    getImportColdWalletView()
        let subViewHeight = max(680, UIScreen.height) -  UIScreen.navigationHeight - 48
        let subViews: [UIView] =  [importMnemonicView,importKstoreView,importPrivateView,coldWalletView]
        
        var scrollows: [UIScrollView] = []
        for (index,subview)in subViews.enumerated(){
            let scrollow = UIScrollView()
            scrollow.backgroundColor = UIColor.white
            scrollow.addSubview(subview)
            subview.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalToSuperview()
                if index == 0{
                  make.height.equalTo(max(680, UIScreen.height))
                }else{
                  make.height.equalTo(subViewHeight)
                }
                make.centerX.equalToSuperview()
            }
            scrollows.append(scrollow)
        }
        return scrollows
    }
}


extension HPBImportWalletController{
    
    fileprivate func getImportMnemonicView() -> HPBImportMnemonicView{
        let importMnemonicView  = HPBViewUtil.instantiateViewWithBundeleName(HPBImportMnemonicView.self) as! HPBImportMnemonicView
        importMnemonicView.importBlock = {[weak self](mneonic,password,tips) in
            guard let `self` = self else{return}
            //判断是否超过最大钱包数量
            if !HPBImportViewModel.showAboveWalletsNumberAlert(vc: self){
                return
            }
            showHudText(string: "".localizable, view: self.view)
            DispatchQueue.global().async {
                let result =  HPBWalletManager.importByMnemonics(mmemonics: mneonic, password: password,tipInfo: tips){ (model) in
                    self.importComplation(model)
                }
                if !result.state{
                    self.importFailed(result.errorMsg)
                }
            }
        }
        
        importMnemonicView.introduceBlock = {
            self.pushToWebView(url: HPBWebViewURL.mnemonic.webViewUrllocalizable, title: "ImportWallet-What-Mnemonic".localizable)
        }
        importMnemonicView.severBlock = {
            self.pushToWebView(url: HPBWebViewURL.services.webViewUrllocalizable, title: "Common-Sever-Privacy".localizable)
        }
        return importMnemonicView
    }
            
    fileprivate func getImportKstoreView() -> HPBImportKstoreView{
        let importKstoreView = HPBViewUtil.instantiateViewWithBundeleName(HPBImportKstoreView.self) as! HPBImportKstoreView
        importKstoreView.importBlock = {[weak self](kstore,password) in
            guard let `self` = self else{return}
            //判断是否超过最大钱包数量
            if !HPBImportViewModel.showAboveWalletsNumberAlert(vc: self){
                return
            }
            showHudText(string: "".localizable, view: self.view)
            DispatchQueue.global().async {
                 //判断是否是审核中,并且审核人员输入正确
                let finialKstore = kstore
                let result = HPBWalletManager.importByKstore(kstore: finialKstore, password: password){ (model) in
                   self.importComplation(model)
                }
                if !result.state{
                    self.importFailed(result.errorMsg)
                }
            }
        }
        importKstoreView.introduceBlock = {
            self.pushToWebView(url: HPBWebViewURL.keystore.webViewUrllocalizable, title: "ImportWallet-What-Keystore".localizable)
        }
        importKstoreView.severBlock = {
            self.pushToWebView(url: HPBWebViewURL.services.webViewUrllocalizable, title: "Common-Sever-Privacy".localizable)
        }
        return  importKstoreView
    }
    
    fileprivate func getImportColdWalletView() -> HPBImportColdWalletView{
        let importColdWalletView = HPBViewUtil.instantiateViewWithBundeleName(HPBImportColdWalletView.self) as! HPBImportColdWalletView
        importColdWalletView.importBlock = {[weak self](address,name) in
            guard let `self` = self else{return}
            //判断是否超过最大钱包数量
            if !HPBImportViewModel.showAboveWalletsNumberAlert(vc: self){
                return
            }else if HPBWalletManager.getWalletInfoBy(address: address) != nil{
                // 当前钱包已存在
                HPBAlertView.showNomalAlert(in: self, message: "WalletHandel-Exist-Wallet".localizable, onlyConfirm: true, complation: nil)
                return
            }
            
            // 添加冷钱包地址到数据库
            let walletModel = HPBWalletRealmModel()
            walletModel.configModel(address,walletName: name,mnemonics: nil,
                                    isColdAddress: "1",
                                    headName: HPBHeaderManager.randomGeneratHeadimageName(name, address: address))
            self.importComplation(walletModel)
        }
        importColdWalletView.introduceBlock = {
            self.pushToWebView(url: HPBWebViewURL.coldWallet.webViewUrllocalizable, title: "ImportWallet-What-ColdWallet".localizable)
        }
        importColdWalletView.severBlock = {
            self.pushToWebView(url: HPBWebViewURL.services.webViewUrllocalizable, title: "Common-Sever-Privacy".localizable)
        }
        return  importColdWalletView
    }
    
    fileprivate func getImportPrivateView() -> HPBImportView{
        let importPrivateView = HPBViewUtil.instantiateViewWithBundeleName(HPBImportView.self) as! HPBImportView
        importPrivateView.importBlock = { [weak self](privateKey,password,tips) in
            guard let `self` = self else{return}
            //判断是否超过最大钱包数量
            if !HPBImportViewModel.showAboveWalletsNumberAlert(vc: self){
                return
            }
            showHudText(string: "".localizable, view: self.view)
            DispatchQueue.global().async {
                guard let privateKeyData = privateKey.hexStrConvertData() else{
                    DispatchQueue.main.async {
                    showBriefMessage(message: "WalletHandel-InCollect-PK".localizable, view: self.view)
                    }
                    return
                }
                let result =  HPBWalletManager.importByPrivateKey(privateKeyData, password: password,tipInfo: tips){ (model) in
                    self.importComplation(model)
                }
                if !result.state{
                    self.importFailed(result.errorMsg)
                }
            }
        }
        importPrivateView.introduceBlock = {
            self.pushToWebView(url: HPBWebViewURL.privates.webViewUrllocalizable, title: "ImportWallet-What-PK".localizable)
        }
        importPrivateView.severBlock = {
            self.pushToWebView(url: HPBWebViewURL.services.webViewUrllocalizable, title: "Common-Sever-Privacy".localizable)
        }
        return importPrivateView
    }
    
    private func importComplation(_ model: HPBWalletRealmModel){
        //导入的账号，本次全部存小写字母
        model.addressStr = model.addressStr?.lowercased()
        DispatchQueue.main.async {
            let storeWalletResult = HPBWalletManager.storeWalletInfo(model)
            if storeWalletResult.state{
                //保存为当前登陆的钱包
                HPBWalletManager.storeCurrentWalletAddress(model.addressStr)
                NotificationCenter.default.post(name: Notification.Name.HPBImportWalletSuccess, object: nil)
                self.importSuccess(model.addressStr)
            }else{
                self.importFailed(storeWalletResult.errorMsg)
            }
        }
    }
    
    private func importSuccess(_ account: String?){
        hideHUD(view: self.view)
        showImage(text: "WalletHandel-Import-Success".localizable, statue: .success)
        self.popTodestinationVC()
        
    }
    
    private func importFailed(_ errorMsg: String?){
        //钱包存在要分情况，映射导入如果存在就更改一下mappingstate，跳转
        DispatchQueue.main.async {
            hideHUD(view: self.view)
            if errorMsg.noneNull.hasPrefix("DQQBYCZ"){
                HPBAlertView.showNomalAlert(in: self, message: "WalletHandel-Exist-Wallet".localizable, onlyConfirm: true, complation: nil)
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
    
    
    private func pushToWebView(url: String,title: String){
        let webView =   HPBWebViewController()
        webView.url = url
        webView.webTitle = title
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
}

extension HPBImportWalletController: CKSlideSwitchViewDelegate{
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightForTabItemForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 48
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, numberOfTabItemsForTopScrollView topScrollView: UIScrollView) -> Int {
        return types.count
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, titleForTabItemForTopScrollViewAt index: Int) -> String? {
        
        return types[index].rawValue.localizable
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView? {
        let contentView = switchViews[index]
        contentView.tag  = index
        return contentView
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemWidthForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return self.view.frame.width / CGFloat(types.count)
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightOfShadowImageForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 3
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemFontSizeForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 15.0
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, currentIndex index: Int){
        let type =  types[index]
        if type == .kStore || type == .coldWallet{
            self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
        }else{
           self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
        }
        
        if type == .mnemonics{
            IQKeyboardManager.shared.keyboardDistanceFromTextField = 130
        }else{
            IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
        }
        
        
    }

}


extension HPBImportWalletController{
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
    }
}
