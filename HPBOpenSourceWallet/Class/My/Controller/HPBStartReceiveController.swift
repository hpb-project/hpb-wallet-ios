//
//  HPBStartReceiveController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBStartReceiveController: HPBBaseController,HPBRefreshProtocol {

    enum HPBSourceType{
        case normal
        case shake
    }
    
   
    @IBOutlet weak var tableView: UITableView!
    var currentPage: Int = 1
    var sendDetailModels: [HPBSendDetailModel] = []

    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var sendDetailListsModel: HPBSendDetailLists?
    var recordSelectAddr: String?
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    //适配摇一摇红包(后台不返回字段,所以和王敏沟通后,所有红包,显示我这边都保留4位,普通的红包他会返回0.2500的格式)
    var sourceType: HPBSourceType = .normal
    var shakeRedPacketNo: String?
    var shakeRedPacketKey: String?
    var shakeCommandStr: String?
    //通用调用
    var commonRedPacketNo: String{
        get{
            switch sourceType {
            case .normal:
                return HPBRedPacketManager.share.redPacketNo.noneNull
            case .shake:
                return shakeRedPacketNo.noneNull
            }
        }
    }
    var commonCommandStr: String{
        get{
            switch sourceType {
            case .normal:
                return HPBRedPacketManager.share.commandStr.noneNull
            case .shake:
                return shakeCommandStr.noneNull
            }
        }
    }
    
    var commonRedPacketKey: String{
        get{
            switch sourceType {
            case .normal:
                return HPBRedPacketManager.share.redPacketKey.noneNull
            case .shake:
                return shakeRedPacketKey.noneNull
            }
        }
        
    }

    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var labelBottomTobaseConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        steupViews()
        configNavigationItem()
        self.getSendDetailNetwork(page: self.currentPage, commonRedPacketNo,showHud: true,complete: nil)
        //添加通知,当正在领红包的时候,又来了个红包的时候,就dismiss这个页面
        NotificationCenter.default.addObserver(self, selector: #selector(dimissPage), name: NSNotification.Name.HPBReceiveRedPacketPage, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func dimissPage(){
        
        //隐藏选择地址界面
        let selectView = AppDelegate.shared.window?.viewWithTag(60002) as? HPBPicketView
        selectView?.tapDismiss()
        self.navigationController?.dismiss(animated: false, completion: nil)
        
    }
    
    fileprivate func steupViews(){
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.init(withRGBValue: 0xFCFCFC)
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        addHeaderFooter(true, tableView)
        tableViewConfig()
        
        tableView.mj_header.backgroundColor = UIColor.paNavigationColor
        let headerBackView = UIView(frame: CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height))
        headerBackView.backgroundColor = UIColor.paNavigationColor
        tableView.mj_header.addSubview(headerBackView)
        tableView.mj_header.layer.masksToBounds = false
        tableView.layer.masksToBounds = false
        self.view.backgroundColor = UIColor.init(withRGBValue: 0xFCFCFC)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.startRequestData(true, finish: nil)
        }
         bottomLabel.text = "News-RedPacket-BottomTip-24H".localizable
        self.bottomLabel.isHidden  = true
    }
    
    fileprivate func steupSectionModel(){
        var cellModels: [HPBCellModel] = []
        cellModels += [HPBStartReceiveCell.cellModel]
        cellModels += [HPBRPSendTotalCell.cellModel]
        let oneSectionModel = HPBTableViewModel.getSectionModel(cellModels)
        let twosectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBSendListCell.cellModel, count: self.sendDetailModels.count))
        tableDelegater?.sectionModels = [oneSectionModel,twosectionModel]
        tableView.reloadData()
        
    }
    
    fileprivate func configNavigationItem(){
        let imageName = UIImage(named: "back_leftBtn_white")
        let barButtonItem = HPBBarButton.init(image: imageName)
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedLeftNavItem()
        }
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        
    }
    
    func clickedLeftNavItem(){
       self.dismiss(animated: true, completion: nil)
    }
    
    func  tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier {
            case String(describing: HPBStartReceiveCell.self):
                let cell = tableViewBlockParam.cell as! HPBStartReceiveCell
                cell.model = self.sendDetailListsModel
                cell.selectBlock = {
                    self.selectAddress()
                }
            case String(describing: HPBRPSendTotalCell.self):
                let cell = tableViewBlockParam.cell as! HPBRPSendTotalCell
                guard let model = self.sendDetailListsModel else {return}
                let coinStr = HPBStringUtil.converHpbMoneyFormat(model.totalCoin, 2).noneNull
                var totalMoneyLocation = "共\(coinStr)HPB"
                var leftTip = "News-RedPacket-Received".localizable
                if HPBLanguageUtil.share.language == .english{
                    totalMoneyLocation = "\(coinStr)HPB in Total"
                    leftTip += " "
                }
                cell.title = leftTip + "\(model.usedNum)/\(model.totalNum),\(totalMoneyLocation)"
            case String(describing: HPBSendListCell.self):
                let cell = tableViewBlockParam.cell as! HPBSendListCell
                let model = self.sendDetailModels[tableViewBlockParam.indexPath.row]
                cell.model = model
            default:
                break
            }
        }
        
    }
    
  
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        
        self.getSendDetailNetwork(page: self.currentPage, commonRedPacketNo) {
            finish?()
        }
    }

}

extension HPBStartReceiveController{
    
    func getSendDetailNetwork(page: Int,_ redPackNo: String,showHud: Bool = false,complete: (()->Void)?){
   
        if showHud{
         showHudText(view: self.view)
        }
        // 红包钥匙
        let redPacketKey = commonRedPacketKey
        let (requestUrl,param) = HPBAppInterface.getRedPacketBeforeDrawCheck(redPacketNo: redPackNo, key: redPacketKey, page: "\(page)", address: self.recordSelectAddr)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                hideHUD(view: self.view)
                guard let sendDetailLists =  HPBBaseModel.mp_effectiveModel(result: result) as HPBSendDetailLists? else{
                    return
                }
                //是否显示下面的提示
                if sendDetailLists.redpacketOver == .ongoing{
                    self.bottomLabel.isHidden  = false
                    self.labelBottomTobaseConstraint.constant = UIScreen.tabbarSafeBottomMargin + 10
                }else{
                    self.bottomLabel.isHidden  = true
                    self.bottomLabel.text = nil
                    self.bottomConstraint.constant = -20
                }
                
                self.sendDetailListsModel = sendDetailLists
                self.requestDataHandel(pages: sendDetailLists.pages, tableView: self.tableView, refreshBlock: {
                    self.sendDetailModels.removeAll()
                }, reloadBlock: {
                    self.sendDetailModels += sendDetailLists.list
                    self.steupSectionModel()
                })
            }else{
                if self.sendDetailListsModel == nil{
                    self.steupSectionModel()
                    showBriefMessage(message: errorMsg,view: self.view)
                }
        
            }
            
        }
    }
    
}


extension HPBStartReceiveController{
    func selectAddress(){
        if HPBUserMannager.shared.currentWalletInfo == nil{
            self.noWalletTiptoCreate()
        }else{
            self.showSelectAddressView(commandStr: commonCommandStr)
        }
    }
    
    func noWalletTiptoCreate(){
        HPBAlertView.showNomalAlert(in: self, title: "Common-Tip".localizable, okBtnTitle: "News-RedPacket-Receive-Creat-Btn".localizable, message: "News-RedPacket-Receive-Creat-Tip".localizable) {
            let  creatVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBCreatWalletController.self))
            self.navigationController?.pushViewController(creatVC, animated: true)
        }
    }
    
    
    func showSelectAddressView(commandStr: String){
        guard let selectAddressView = HPBViewUtil.instantiateViewWithBundeleName(HPBPicketView.self, bundle: nil)as? HPBPicketView else{return}
        var datasource: [(String,String)] = []
        if let models = HPBUserMannager.shared.walletInfos{
            for model in models{
               datasource.append((model.walletName.noneNull, model.addressStr.noneNull))
            }
        }
        selectAddressView.tag = 60002
        let strArray =  commandStr.components(separatedBy: HPBAPPConfig.redPacketSeparator)
        guard strArray.count == 2 else{return}
        let tokenId = self.sendDetailListsModel?.tokenId
        selectAddressView.selectBlock = { (addressStr) in
            HPBRedPacketManager.share.receiveRedPacketNetwork(address: addressStr, redPacketNo: strArray[0], key:  strArray[1],tokenId: tokenId.noneNull){
                HPBAlertView.showNomalAlert(in: self, title:"Common-Tip".localizable, okBtnTitle: "Common-Confirm".localizable, message: $0, onlyConfirm:true, complation: {
                    self.recordSelectAddr = addressStr
                    self.currentPage = 1
                    self.getSendDetailNetwork(page: self.currentPage, self.commonRedPacketNo,showHud: true,complete: nil)
                })
            }
        }
        AppDelegate.shared.window?.addSubview(selectAddressView)
        selectAddressView.dataSources = datasource
        selectAddressView.topTitle = "News-RedPacket-Receive-Select-Address".localizable
        selectAddressView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //默认选中的行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            selectAddressView.initSelectRow()
        }
    }
}
