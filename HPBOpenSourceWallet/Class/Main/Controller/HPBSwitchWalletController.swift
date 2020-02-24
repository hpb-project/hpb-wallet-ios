//
//  HPBSwitchWalletController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/6.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class HPBSwitchWalletController: UIViewController,HPBRefreshProtocol{
    var currentPage: Int = -1

    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var selectBlock: (()->Void)?
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBSwitchWalletCell.cellModel]
        return [model]
    }
    @IBOutlet weak var walletListLabel: UILabel!
    fileprivate var totalCoinMoneyStr: String? = "0"{
        willSet{
            if newValue.noneNull == "Hidden"{
                moneyLabel.text = HPBAPPConfig.hiddenAssertStr
            }else{
                moneyLabel.text = newValue
            }
        }
    }
    @IBOutlet weak var totalAssertLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var eyeBtn: UIButton!
    
    fileprivate lazy var bottomView: HPBSwitchFooterView = {
        let bottomView = HPBViewUtil.instantiateViewWithBundeleName(HPBSwitchFooterView.self) as! HPBSwitchFooterView
        bottomView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 70)
        bottomView.createWalletBlock = {
          let  destinationVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBCreatWalletController.self))
            self.navigationController?.pushViewController(destinationVC, animated: true)

        }
        return bottomView
    }()
    fileprivate var allAccoutsbalace: [String: HPBBalanceModel]?
    fileprivate var allAccountValues: String? = "0"
    var walletInfos: Results<HPBWalletRealmModel>? = {
        if let models = HPBUserMannager.shared.walletInfos{
            return models
        }
        return nil
    }()
    
    //显示资产状态
    fileprivate lazy var showAssertFlag: Bool = HPBMainViewModel.getShowAssertFlag()
    var currentAddress: String? = {
        debugLog(HPBUserMannager.shared.currentWalletInfo?.walletName)
        return HPBUserMannager.shared.currentWalletInfo?.addressStr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main-Change-Address".localizable
        totalAssertLabel.text = "Main-Total-Assert".localizable
        walletListLabel.text = "SwitchWallet-Wallet-List".localizable
        steupViews()
        tableViewConfig()
        steupSectionModel()
        initSelectTableView()    //初始化选中的cell
        quaryAllBalances()
        NotificationCenter.default.addObserver(self, selector: #selector(changeAssertState), name: NSNotification.Name.HPBHiddenAssert, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func changeAssertState(){
        showAssertFlag = HPBMainViewModel.getShowAssertFlag()
        self.totalCoinMoneyStr = self.showAssertFlag ? self.allAccountValues : "Hidden"
        self.tableView.reloadData()
    }
    
    
    func steupViews(){
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.registerCell(registerAllModels)
        
        self.tableView.tableFooterView = self.bottomView
        addHeaderFooter(false, tableView)
        eyeBtn.isSelected = !self.showAssertFlag
        self.totalCoinMoneyStr = self.showAssertFlag ? self.allAccountValues : "Hidden"
        
    
    }
    
    func initSelectTableView(){
        var selectIndex = -1
        guard let `walletInfos` = walletInfos else {
            return
        }
        if walletInfos.isEmpty{
            return
        }
        for (index,model) in walletInfos.enumerated(){
            if model.addressStr.noneNull == currentAddress.noneNull{
                selectIndex = index
                break
            }
        }
        self.tableView.selectRow(at: IndexPath(row: selectIndex, section: 0), animated: false, scrollPosition: .none)
    }
    
    
    
    fileprivate func steupSectionModel(){
        guard let `walletInfos` = walletInfos else {
            return
        }
        let sectionModel = HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBSwitchWalletCell.cellModel, walletInfos.count))
        tableDelegater?.sectionModels = [sectionModel]
        
        tableView.reloadData()
    }
    
    @IBAction func eyeBtnClick(_ sender: UIButton) {
        
        //隐藏为false，显示为true
        sender.isSelected = !sender.isSelected
        let state = sender.isSelected
        HPBMainViewModel.setHiddenOrShowHandel(state)
    }
    
    

}


extension HPBSwitchWalletController{
    
    fileprivate func tableViewConfig(){
        //配置cell
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBSwitchWalletCell.self):
                let cell = tableViewBlockParam.cell as! HPBSwitchWalletCell
                let row = tableViewBlockParam.indexPath.row
                let model = self.walletInfos?[row]
                let balanceModel = self.allAccoutsbalace?[HPBStringUtil.noneNull(model?.addressStr)]
                cell.name = model?.walletName
                cell.isColdWallet = (model?.isColdAddress == "1")
                cell.headImageName = model?.headName
                cell.addressStr = model?.addressStr
                let showBalance = HPBMoneyStyleUtil.share.showFormatMoney(balanceModel?.cnyTotalValue, balanceModel?.usdTotalValue)
                cell.balance = self.showAssertFlag ? showBalance : "Hidden"
            default:
                break
            }
        }
        
        tableDelegater?.didSelectCell = { [weak self] tableViewBlockParam in
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBSwitchWalletCell.self):
                let row = tableViewBlockParam.indexPath.row
                let model = self?.walletInfos?[row]
                if self?.currentAddress.noneNull != model?.addressStr.noneNull{
                    guard let model = self?.walletInfos?[row] else{
                        showBriefMessage(message: "切换失败！")
                        return
                    }
                    //切换钱包存储当前地址 + 对userManger进行赋值
                    HPBWalletManager.storeCurrentWalletAddress(model.addressStr)
                    HPBUserMannager.shared.currentWalletInfo = HPBWalletManager.getCurrentWalletInfo()
                    self?.selectBlock?()
                    self?.navigationController?.popViewController(animated: true)

                }else{
                    self?.navigationController?.popViewController(animated: true)
                }
            default:
                break
            }
        }
    }
}


extension HPBSwitchWalletController{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        quaryAllBalances {
            finish?()
        }
    }
    
    fileprivate func  quaryAllBalances(complete: (() -> Void)? = nil){
        showHudText(view: self.tableView)
        guard let allAccounts = HPBUserMannager.shared.walletInfos else{ return }
        if allAccounts.isEmpty{
            return
        }
        var allAddress: [String] = []
        allAccounts.forEach {
            allAddress.append($0.addressStr.noneNull)
        }
       
        HPBMainViewModel.getListBalance(accounts: allAddress, success: { (totalCny,totalUsd,results) in
            hideHUD(view: self.tableView)
            self.allAccountValues =  HPBMoneyStyleUtil.share.showFormatMoney(totalCny, totalUsd)
            self.totalCoinMoneyStr = self.showAssertFlag ? self.allAccountValues : "Hidden"
            var balaces: [String: HPBBalanceModel] = [:]
            results.forEach({
               balaces.updateValue($0, forKey: $0.address)
            })
            self.allAccoutsbalace = balaces
            debugLog(balaces)
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.initSelectTableView()
            
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg,view: self.tableView)
        }
    }
    
    
}
