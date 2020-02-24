//
//  ViewController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import MJRefresh

class HPBMainController: HPBBaseController,HPBTableViewProtocol {
    //跳转到目的页面
    enum HPBPushDestination {
        case createWallet
        case scan
        case walletHandel
        case receipt
        case transfer
        case totalAsset
        case redPacket
        case managerToken
        case HRC721Assert
        case switchWallet
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBMainCell.cellModel,HPBMainCreateCell.cellModel,
                              HPBMainCoinCell.cellModel,
                              HPBMainAddCell.cellModel]
        return [model]
    }
    lazy var currentWalletInfo = {
      return HPBUserMannager.shared.currentWalletInfo
    }()

    fileprivate var dataModel: HPBMainTokenLists?
    var currentPage: Int  = -1  //没用，只是为了遵循协议
    fileprivate var tryCount: Int = 0
    fileprivate let maxTryCount: Int = 5
    
    //显示资产状态
    fileprivate lazy var showAssertFlag: Bool = HPBMainViewModel.getShowAssertFlag()
    lazy var recordModels: [HPBTokenManagerModel] = {
        /// 加载之前保存的数据
        if let localModels = HPBCacheManager.getCacheModels(HPBCacheKey.mainPageTokenCacheKey) as  [HPBTokenManagerModel]?{
            return HPBTokenManager.share.getRecordModels(localModels)
        }else{
            return []
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TabBar-Main.title".localizable
        HPBPrisonBreakManager.judgePrisonBreakPhone()
        setupTableView(UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.tabbarHeight + UIScreen.tabbarSafeBottomMargin, right: 0))
        tableView.backgroundColor = UIColor.white
        tableViewConfig()
        steupSectionModel()
        addHeaderFooter(false, tableView)
        getFirstQuaryBalance()
        registerNotifation()
        tableViewHeaderConfig()
        //添加悬浮红包
        HPBRedPacketManager.share.steupReadPacketBtn(self.view)
        HPBRedPacketManager.share.redPacketBlock = {[weak self] in
            guard let `self` = self else{return}
            let isBackup = HPBStringUtil.noneNull(self.currentWalletInfo?.mnemonics).isEmpty
            if isBackup{
                self.pushToNextController(type: .redPacket)
            }else{
                self.showTipBackUpView()
            }
        }
        openShakeRedPacket()
    }
    
    private func tableViewHeaderConfig(){
        var insertValue: CGFloat = 30
        if HPBLanguageUtil.share.language == .english{
            insertValue = 15
        }
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.statusHeight - (UIDevice.isIPHONE_X ? insertValue : 0)))
        tableView.contentInset = UIEdgeInsets(top: UIDevice.isIPHONE_X ? insertValue: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.paNavigationColor
    }
    
    fileprivate func registerNotifation(){
        NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBCreatWalletSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBImportWalletSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBBackupWalletSuccess, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBChangeNameSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transferSuccess), name: Notification.Name.HPBTransferSuccess, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(walletHandel), name: Notification.Name.HPBDeleteWalletSuccess, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(changeAssertState), name: NSNotification.Name.HPBHiddenAssert, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(redPacketStateHandel), name: NSNotification.Name.HPBShowRedPacketButton, object: nil)
    }
    
    @objc fileprivate func redPacketStateHandel(){
        
        HPBRedPacketManager.share.reloadState()
    }
    
    @objc fileprivate func walletHandel(){
        //防止通知不能先于HPBUserMannager的到达
        currentWalletInfo = HPBWalletManager.getCurrentWalletInfo()
        steupSectionModel()
        if currentWalletInfo != nil{
            tableView.mj_header.isHidden = false
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    
    @objc fileprivate func transferSuccess(){  //刷新余额
        self.tryCount = 0
        self.retryRefreshAccount()
    }
    
    @objc fileprivate func retryRefreshAccount(){
        self.quaryAccountBalance { (model) in
            if self.tryCount>=self.maxTryCount{
                self.tryCount = 0
            }else{
                self.tryCount += 1
                debugLog("我在请求余额,最多尝试5次，现在第\(self.tryCount)次")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.retryRefreshAccount()  //递归查询
                }
            }
        }
    }
    
    @objc fileprivate func changeAssertState(){
        showAssertFlag = HPBMainViewModel.getShowAssertFlag()
        steupSectionModel()
    }
}

extension HPBMainController{
    
    @objc fileprivate func steupSectionModel(){
        var cellModels: [HPBCellModel] = []
        cellModels += [HPBMainCell.cellModel]
        
        //没有钱包，待创建
        if currentWalletInfo == nil{
            cellModels += [HPBMainCreateCell.cellModel]
        }else{
             cellModels += [HPBMainAddCell.cellModel]
             cellModels += [HPBCellModel](repeatElement(HPBMainCoinCell.cellModel, count: recordModels.count))
        }
        let sectionModel = HPBTableViewModel.getSectionModel(cellModels)
        reloadData([sectionModel])
        
    }
    
    fileprivate func tableViewConfig(){
        //配置cell
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            let isBackup = HPBStringUtil.noneNull(self.currentWalletInfo?.mnemonics).isEmpty
            switch identifier{
            case String(describing: HPBMainCell.self):
                let cell = tableViewBlockParam.cell as! HPBMainCell
                cell.scanBlock = {
                    if isBackup{
                       self.pushToNextController(type: .scan)
                    }else{
                        self.showTipBackUpView()
                    }
                }
                cell.receiptBlock = {
                    if isBackup{
                        self.pushToNextController(type: .receipt)
                    }else{
                          self.showTipBackUpView()
                    }
                }
                
                cell.syncAssertBlock = {
                    // 冷钱包转账
                    if self.currentWalletInfo?.isColdAddress == "1"{
                        self.showSyncColdWalletCode()
                        return
                    }
                }
                
                cell.transferBlock = {
                  
                    //普通转账
                    if isBackup{
                       self.pushToNextController(type: .transfer)
                    }else{
                         self.showTipBackUpView()
                    }
                }
                cell.copyBlock = {
                    let copyStr = HPBStringUtil.noneNull(self.currentWalletInfo?.addressStr)
                    if copyStr.isEmpty{
                        return
                    }
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = copyStr
                    showBriefMessage(message: "Common-Copy-Success".localizable, view: self.view)
                }
                cell.hiddenBlock = {
                    HPBMainViewModel.setHiddenOrShowHandel($0)
                    
                }
                cell.selectWalletBlock = {
                     self.pushToNextController(type: .switchWallet)
                }
                if let model = self.currentWalletInfo{
                    let cnyStr = self.dataModel?.ptCnyValue
                    let usdStr = self.dataModel?.ptUsdValue
                    let balanceMoneyStr = HPBMoneyStyleUtil.share.showFormatMoney(cnyStr.noneNull, usdStr.noneNull)
                    let assetModel = HPBMainCell.MainAssertModel(addressStr: model.addressStr, coinMoneyStr: balanceMoneyStr,eyeState: self.showAssertFlag ? .open : .close,coldState: model.isColdAddress)
                    cell.model = assetModel
                }else{
                    let assetModel = HPBMainCell.MainAssertModel(eyeState: self.showAssertFlag ? .open : .close)
                    cell.model = assetModel
                }
            case String(describing: HPBMainCoinCell.self):
                let cell = tableViewBlockParam.cell as! HPBMainCoinCell
                cell.model = self.recordModels[tableViewBlockParam.indexPath.row - 2]
                cell.showAssertFlag = self.showAssertFlag ? true : false
                cell.isHiddenBottomView = tableViewBlockParam.indexPath.row == self.recordModels.count + 1
            case String(describing: HPBMainAddCell.self):
                  let cell = tableViewBlockParam.cell as! HPBMainAddCell
                  cell.addBlock = {
                     self.pushToNextController(type: .managerToken)
                }
            default:
                break
            }
        }
        tableDelegater?.didSelectCell = { [weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBMainCoinCell.self):
                let model = self.recordModels[tableViewBlockParam.indexPath.row - 2]
                switch model.type{
                case .mainNet:
                    self.pushToNextController(type: .totalAsset,model)
                case .hrc20:
                    self.pushToNextController(type: .totalAsset,model)
                case .hrc721:
                     self.pushToNextController(type: .HRC721Assert,model)
                }
            case String(describing: HPBMainCreateCell.self):
                self.pushToNextController(type: .createWallet)
            default:
                break
            }
        }
    }
    
}

extension HPBMainController{

    func pushToNextController(type: HPBPushDestination,_ model: HPBTokenManagerModel? =  nil){
        
        if type != .createWallet && judgehaveWallet() == false{
            return
        }

        var destinationVC: UIViewController?
        switch type{
        case .createWallet:
            destinationVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBCreatWalletController.self))
        case .scan:
            destinationVC =  HPBScanController()
            (destinationVC as! HPBScanController).scanType = .scan
            (destinationVC as! HPBScanController).isColdWallet = self.currentWalletInfo?.isColdAddress == "1"
            (destinationVC as! HPBScanController).remainMoney = self.dataModel?.hpbBalance
        case .walletHandel:
            destinationVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBWalletHandelController.self))
            (destinationVC as! HPBWalletHandelController).from = .other
            (destinationVC as! HPBWalletHandelController).addressStr = HPBStringUtil.noneNull(self.currentWalletInfo?.addressStr)
            
        case .receipt:
            let receiptVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBReceiptController") as! HPBReceiptController
            receiptVC.myAddress = HPBStringUtil.noneNull(self.currentWalletInfo?.addressStr)
            destinationVC = receiptVC
            
        case .transfer:
            destinationVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBTransferController")
            (destinationVC as! HPBTransferController).remandToken = self.dataModel?.hpbBalance
        case .totalAsset:
            let totalAssetVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBTotalAssetController") as! HPBTotalAssetController
            totalAssetVC.model = model
            destinationVC = totalAssetVC
        case .redPacket:
            let redPacketVC =  HPBControllerUtil.instantiateControllerWithIdentifier("HPBRedPacketController") as! HPBRedPacketController
            destinationVC = redPacketVC
        case .managerToken:
            let managerTokenVC =  HPBControllerUtil.instantiateControllerWithIdentifier("HPBTokenManagerController") as! HPBTokenManagerController
            managerTokenVC.modifyBlock = {
                self.tableView.mj_header.beginRefreshing()
            }
            destinationVC = managerTokenVC
        case .HRC721Assert:
            let totalAssetVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBHRC721AssertController") as! HPBHRC721AssertController
            totalAssetVC.model = model
            destinationVC = totalAssetVC
        case .switchWallet:
            let switchWalletVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBSwitchWalletController") as! HPBSwitchWalletController
            switchWalletVC.selectBlock = {[weak self] in
                self?.currentWalletInfo = HPBUserMannager.shared.currentWalletInfo
                self?.tableView.mj_header.beginRefreshing()
                self?.tableView.reloadData()
            }
            destinationVC = switchWalletVC
        }
        
        if let `destinationVC` = destinationVC{
            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    fileprivate func judgehaveWallet() -> Bool{
        if  currentWalletInfo == nil{
            HPBAlertView.showNomalAlert(in: self, title: "Common-Tip".localizable, message: "Common-No-Wallet".localizable) {
               self.pushToNextController(type: .createWallet)
            }
            return false
        }
        return true
    }
    
    
    //显示备份弹框
    private func showTipBackUpView(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        HPBMainViewModel.showTipBackUpView(controller: self) {[weak self] in
            self?.pushToNextController(type: .walletHandel)
            self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension HPBMainController: HPBRefreshProtocol{
    
    fileprivate func getFirstQuaryBalance(){
        if currentWalletInfo != nil{
            tableView.mj_header.isHidden = false
            tableView.mj_header.beginRefreshing()
        }
    }
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        self.quaryAccountBalance { (balance) in
            finish?()
        }
    }
    
    fileprivate func  quaryAccountBalance(complete: ((HPBMainTokenLists?) -> Void)? = nil){
        let  address = HPBStringUtil.noneNull(currentWalletInfo?.addressStr)
        if address.isEmpty{
            complete?(nil)
            return
        }
        //查询交易余额
        HPBMainViewModel.getLegalTenderBalance(address: address, success: { (model) in
            complete?(model)
            self.dataModel = model
            self.recordModels = HPBTokenManager.share.getRecordModels(model.list)
            self.steupSectionModel()
        }) { (errorMsg) in
            complete?(nil)
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
}

extension HPBMainController{
    
    func showSyncColdWalletCode(){
        let currentAddress = self.currentWalletInfo?.addressStr
        var qrCodeArr: [Any] = ["4"]
        var qrCodeDic: [String: Any] = ["from": currentAddress.noneNull]
        var listData: [Any] = []
        guard let dataModel = self.dataModel else {
            self.quaryAccountBalance {
                self.dataModel  = $0
                self.showSyncColdWalletCode()
            }
            return
        }
        for model in dataModel.list {
            var listDataDic: [String: String] = [:]
            var money: String?
            switch model.type {
            case .mainNet:
                money = HPBStringUtil.converHpbMoneyFormat(model.balanceOfToken)
            case .hrc20:
                money = HPBStringUtil.converCustomDigitsFormat(model.balanceOfToken, decimalCount: model.formatDecimals)
            case .hrc721:
               money = model.balanceOfToken
            }
            listDataDic.updateValue(HPBStringUtil.moneyFormatToString(value: money.noneNull), forKey: "balanceOfToken")
            listDataDic.updateValue(model.contractType, forKey: "contractType")
            listDataDic.updateValue(model.tokenSymbol, forKey: "tokenSymbol")
            listData.append(listDataDic)
        }
        qrCodeDic.updateValue(listData, forKey: "listData")
        qrCodeDic.updateValue("\(Date().timeIntervalSince1970)", forKey: "updateDate")
        qrCodeArr.append(qrCodeDic)
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
            sinatureCodeView.nextStepStr = "Common-Close".localizable
        }
    }
}
