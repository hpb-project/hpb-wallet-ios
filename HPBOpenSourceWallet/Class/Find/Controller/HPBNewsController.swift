//
//  HPBNewsController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/12.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBNewsController: HPBBaseController,HPBTableViewProtocol {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBBannerCell.cellModel,HPBDAppCell.cellModel,HPBNewsCell.cellModel,HPBEmptyCell.cellModel(),HPBFindTopCell.cellModel]
        let headerModel = HPBHeaderFooterViewModel(identifier: "HPBFindHeaderView", isRegisterByClass: true, classType: HPBFindHeaderView.self)
        model.headerViewModel = headerModel
        return [model]
    }
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    var currentPage: Int = 1
    fileprivate var carouselModels: [HPBCarouselModel] = []{
        willSet{
            bannerImages.removeAll()
            bannerTitles.removeAll()
            newValue.forEach {
                bannerImages.append($0.images)
                bannerTitles.append($0.title)
            }
        }
    }
    fileprivate var dAppModels: [HPBDAppModel] = []
    fileprivate var bannerImages: [String] = []
    fileprivate var bannerTitles: [String] = []
    fileprivate var newsModels: [HPBCarouselModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView(UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.tabbarHeight + UIScreen.tabbarSafeBottomMargin, right: 0))
        tableView.sectionHeaderHeight = 0.01
        var insertValue: CGFloat = 30
        if HPBLanguageUtil.share.language == .english{
            insertValue = 15
        }
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.statusHeight - (UIDevice.isIPHONE_X ? insertValue : 0)))
        tableView.contentInset = UIEdgeInsets(top: UIDevice.isIPHONE_X ? insertValue: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.white
        tableViewConfig()
        addHeaderFooter(true, tableView)
        if !getCacheData(){
            getNetworkData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as? HPBBaseNavigationController)?.isWhiteBar = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    func receiveAPNsNotifation(articleId: String){
    
        self.tableView.mj_header?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            let url     = HPBWebViewURL.articles + "?" + "id=\(articleId)"
            self.pushToWebview(url: url, title: "News-Detail".localizable)
        }
    }
}


extension HPBNewsController: HPBRefreshProtocol{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        if isRefresh{
            getNetworkData {
                finish?()
            }
        }else{
            self.quaryNewsNetwork(isLoad: true,current: self.currentPage) {
                finish?()
            }
        }
    }
}

extension HPBNewsController{
    
    fileprivate func steupSectionModel(){
        
        var sectionArr: [HPBSectionModel] = []
        let topSection = HPBTableViewModel.getSectionModel([HPBFindTopCell.cellModel])
        sectionArr.append(topSection)
        
        if !self.carouselModels.isEmpty{
            let bannerSection = HPBTableViewModel.getSectionModel([HPBBannerCell.cellModel])
            sectionArr.append(bannerSection)
        }
        
        //Dapp的界面
        if !self.dAppModels.isEmpty{
             let dAppheaderModel = HPBHeaderFooterViewModel(identifier: "HPBFindHeaderView", height: 55, isRegisterByClass: true, classType: HPBFindHeaderView.self,name: "News-DAPPs".localizable)
            let dAppSection = HPBTableViewModel.getSectionModel([HPBDAppCell.cellModel], headerViewModel: dAppheaderModel)
            sectionArr.append(dAppSection)
        }
        
        
        //资讯界面
        if !newsModels.isEmpty{
             let headerModel = HPBHeaderFooterViewModel(identifier: "HPBFindHeaderView", height: 36, isRegisterByClass: true, classType: HPBFindHeaderView.self,name: "News-News.title".localizable)
            let  newsSection =  HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBNewsCell.cellModel, newsModels.count),headerViewModel: headerModel)
             sectionArr.append(newsSection)
        }
        reloadData(sectionArr)
    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self`  = self else {
                return
            }
            
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBFindTopCell.self):
                let topCell = tableViewBlockParam.cell as! HPBFindTopCell
                topCell.selectType = { [weak self] in
                    guard let `self`  = self else {
                        return
                    }
                    self.pushToIntealPage(type:$0)
                }
            case String(describing: HPBBannerCell.self):
                let bannerCell = tableViewBlockParam.cell as! HPBBannerCell
                bannerCell.imageUrlStrs = self.bannerImages
                bannerCell.titleStrs = self.bannerTitles
                bannerCell.clickBannerBlock = {[weak self] (index) in
                    guard let `self`  = self else {return}
                    let model = self.carouselModels[index]
                    let url = HPBWebViewURL.articles + "?" + "id=\(model.articleId)"
                    self.pushToWebview(url: url, title: "News-Detail".localizable,additionTitle: model.title,dec: model.summary)
                }
            case String(describing: HPBNewsCell.self):
                let newsCell = tableViewBlockParam.cell as! HPBNewsCell
                let model = self.newsModels[tableViewBlockParam.indexPath.row]
                newsCell.configData(model.title, time: model.timeStr, imageName: model.images, readNumber: model.viewNumStr)
            case String(describing: HPBDAppCell.self):
                let dappCell = tableViewBlockParam.cell as! HPBDAppCell
                dappCell.models = self.dAppModels
                dappCell.clickBlock = {[weak self]  (index) in
                    guard let `self`  = self else {return}
                    if self.judgehaveWallet() == false{ return} //判断是否创建钱包
                    let model = self.dAppModels[index]
                    let address = (HPBUserMannager.shared.currentWalletInfo?.addressStr).noneNull
                    if HPBUserMannager.shared.currentWalletInfo?.isColdAddress == "1"{
                        showBriefMessage(message: "Common-ColdWallet-cannot".localizable, view: self.view)
                        return
                    }
                    // 判断是否授过权 && 判断是否需要授权
                    if !HPBAuthorizatManager.getAuthorrizaState(address, appid: model.appid) && model.authState{
                        HPBAlertView.showNomalAlert(in: self,
                                                    title: "Common-Tip".localizable,
                                                    okBtnTitle:"Common-Alert-Confirm".localizable, message: "News-DAPPs-Privacy-Tip".localizable) {
                            HPBAuthorizatManager.setAuthorrizaState(address, appid: model.appid)
                                                        self.pushToWebview(url: model.url, title: model.commonName,isOpenSafari: model.isOpenSafari ,webType: .dApp,isIntercept: model.isIntercept)

                        }
                    }else{
                        self.pushToWebview(url: model.url, title: model.commonName,isOpenSafari: model.isOpenSafari ,webType: .dApp,isIntercept: model.isIntercept)

                    }
                }
            case String(describing: HPBEmptyCell.self):
                let emptyCell = tableViewBlockParam.cell as! HPBEmptyCell
                emptyCell.contentView.backgroundColor = UIColor.paBackground
            default:
                break
            }
        }
        
        tableDelegater?.configureHeader = {(header,model) in
            if let headerView = header as? HPBFindHeaderView{
                headerView.titile = model.headerFooterViewName
            }
        }
        
        tableDelegater?.didSelectCell = { [weak self] tableViewBlockParam in
            guard let `self`  = self else {return}
            let row = tableViewBlockParam.indexPath.row
            var model = self.newsModels[row]
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBNewsCell.self):
                let url     = HPBWebViewURL.articles + "?" + "id=\(model.articleId)"
                let webView =  self.pushToWebview(url: url, title: "News-Detail".localizable,additionTitle: model.title,dec: model.summary)
                webView.successBlock = {
                    model.viewNum  =  model.viewNum + 1
                    self.newsModels[row] = model
                    self.tableView.reloadRows(at: [tableViewBlockParam.indexPath], with: .none)
                }
            default:
              break
            }
        }
    }
    
    
    //跳转界面
    func pushToIntealPage(type: HPBFindTopCell.HPBSelectType){
        var destinationVC: UIViewController?
        switch type{
        case .redPacket:
            if self.judgehaveWallet() == false{ return} //判断是否创建钱包
            let isBackup = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.mnemonics).isEmpty
            if isBackup{
                let redPacketVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBRedPacketController.self))
                destinationVC = redPacketVC
            }else{
                self.showTipBackUpView()
            }

        case .governance:
            if self.judgehaveWallet() == false{ return} //判断是否创建钱包
            let governanceVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBGovernanceController.self))
            destinationVC = governanceVC
            
            break
        }
        
        if let `destinationVC` = destinationVC{
            destinationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    

    //跳转webview
    @discardableResult
    func pushToWebview(url: String,
                       title: String,
                       additionTitle: String? = nil,
                       isOpenSafari: Bool = false,
                       webType:HPBWebViewController.HPBWebType = .normol,
                       dec: String? = nil,
                       isIntercept: Bool = true,
                       success: (()-> Void)? = nil) ->HPBWebViewController{
        let webView =   HPBWebViewController()
        webView.animationNavgation = true
        //webView.landscapeRight = true
        if webType == .dApp{
            webView.isHaveRightItem = isOpenSafari
        }else{
            webView.isHaveRightItem = true
        }
        //针对平安互娱
        webView.interceptBlock = {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        webView.webTitle = title
        webView.isIntercept = isIntercept
        webView.additionTitle = additionTitle.noneNull
        webView.additionStr  = dec.noneNull
        webView.url = url
        webView.webType = webType
        webView.hidesBottomBarWhenPushed = true
        webView.successBlock = {
            success?()
        }
        self.navigationController?.pushViewController(webView, animated: true)
        return webView
    }
    
    fileprivate func judgehaveWallet() -> Bool{
        if  HPBUserMannager.shared.currentWalletInfo == nil{
            (self.navigationController as? HPBBaseNavigationController)?.isWhiteBar = true
            HPBAlertView.showNomalAlert(in: self, title: "Common-Tip".localizable, message: "Common-No-Wallet".localizable) {
                 let creatVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBCreatWalletController.self))
                creatVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(creatVC, animated: true)
            }
            return false
        }
        return true
    }
}


extension HPBNewsController{
    
    fileprivate func getNetworkData(complete: (() -> Void)? = nil){
        if self.carouselModels.isEmpty{
            showHudText(view: self.tableView)
        }
        let diapatchGroup = DispatchGroup()
        diapatchGroup.enter()
        quaryCarouselPicturesNetwork {
            diapatchGroup.leave()
        }
        
        diapatchGroup.enter()
        quaryDAppNetwork {
             diapatchGroup.leave()
        }
        diapatchGroup.enter()
        quaryNewsNetwork {
            diapatchGroup.leave()
        }
        
        diapatchGroup.notify(queue: DispatchQueue.main) {
            hideHUD(view: self.tableView)
            complete?()
            self.steupSectionModel()
        }
        
        
    }
    
    //获取轮播图信息
    fileprivate func  quaryCarouselPicturesNetwork(complete: (() -> Void)? = nil){
        let (requestUrl,param) = HPBAppInterface.getCarouselPictures()
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                guard let models =  HPBBaseModel.mp_effectiveModels(result: result, key: "list") as [HPBCarouselModel]? else{
                    return
                }
                HPBCacheManager.setCacheModels(models, name: HPBCacheKey.carouselCacheKey)
                self.carouselModels = models
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
    
     //获取DApp
    fileprivate func  quaryDAppNetwork(complete: (() -> Void)? = nil){
       let (requestUrl,param) = HPBAppInterface.getAllDAppList()
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                guard let models =  HPBBaseModel.mp_effectiveModels(result: result, key: "list") as [HPBDAppModel]? else{
                    return
                }
                HPBCacheManager.setCacheModels(models, name: HPBCacheKey.dAppRecordCacheKey)
                self.dAppModels = models
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
            
        }
        
    }
    
    //获取资讯信息
    fileprivate func quaryNewsNetwork(isLoad: Bool = false,current: Int = 1, complete: (() -> Void)? = nil){
        let (requestUrl,param) = HPBAppInterface.getNewsList(pageNum: "\(current)")
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBNewsModel? else{
                    return
                }
                //代理方法调用
                self.requestDataHandel(pages: model.pages, tableView: self.tableView, refreshBlock: {
                    self.newsModels.removeAll()
                    HPBCacheManager.setCacheModel(model, name: HPBCacheKey.newsCacheKey)
                }, reloadBlock: {
                    self.newsModels += model.list
                    if isLoad{
                        self.steupSectionModel()
                    }
                })
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
    
    
    
    //获取本地缓存
    fileprivate func getCacheData() -> Bool{
        guard let carousels =  HPBCacheManager.getCacheModels(HPBCacheKey.carouselCacheKey) as [HPBCarouselModel]? else{
            return false
        }
        guard let newsModels =  HPBCacheManager.getCacheModel(HPBCacheKey.newsCacheKey) as HPBNewsModel? else{
            return false
        }
        guard let dappModels =  HPBCacheManager.getCacheModels(HPBCacheKey.dAppRecordCacheKey) as [HPBDAppModel]? else{
            return false
        }
        self.carouselModels = carousels
        self.newsModels = newsModels.list
        self.dAppModels = dappModels
        self.steupSectionModel()
        self.tableView.mj_header.beginRefreshing()
        return true
    }
}


extension HPBNewsController{
    
    //显示备份弹框
    private func showTipBackUpView(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        HPBMainViewModel.showTipBackUpView(controller: self) {[weak self] in
            let destinationVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBWalletHandelController.self))
            (destinationVC as! HPBWalletHandelController).from = .other
            (destinationVC as! HPBWalletHandelController).addressStr = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.addressStr)
            destinationVC.hidesBottomBarWhenPushed = true
           self?.navigationController?.pushViewController(destinationVC, animated: true)
           self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}
