//
//  ViewController2.swift
//  LXLTest1
//
//  Created by 刘晓亮 on 2018/5/21.
//  Copyright © 2018年 朝夕网络. All rights reserved.
//

import UIKit
import HPBWeb3SDK
import CryptoSwift
import RealmSwift

class HPBManageWalletController: HPBBaseController,HPBEmptyViewProtocol,HPBRefreshProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var importWalletBtn: UIButton!
    @IBOutlet weak var creatWalletBtn: UIButton!
    @IBOutlet weak var bottomBackView: UIView!
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    lazy var walletModels: Results<HPBWalletRealmModel>?  = {
        return HPBUserMannager.shared.walletInfos
    }()
    var currentPage: Int = -1
    var emptyView: HPBEmptyView?
    var allAccoutsbalace: [String: HPBBalanceModel] = [:]
    fileprivate lazy var showAssertFlag: Bool = HPBMainViewModel.getShowAssertFlag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ManageWallet-Title".localizable
        steupTableView()
        tableViewConfig()
        localizableConfig()
        steupUI()
        quaryAllBalances()
    }
    
    func steupUI(){
        bottomBackView.layer.cornerRadius = 3
        bottomBackView.layer.shadowColor = UIColor.black.cgColor
        bottomBackView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomBackView.layer.shadowOpacity = 0.2
        bottomBackView.layer.shadowRadius = 15
    }
    
    fileprivate func localizableConfig(){
         creatWalletBtn.setTitle(" " + "k5k-eH-8WI.normalTitle".MainLocalizable, for: .normal)
         importWalletBtn.setTitle(" " + "ITj-uQ-0pp.normalTitle".MainLocalizable, for: .normal)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        /*
        //获取钱包所有基本信息，realm数据库更新后会实时刷新，并且是指针类型，所以可以去掉
        if let models = HPBUserMannager.shared.walletInfos{
            walletModels = models
        }
       */
       steupSectionModel()
       quaryAllBalances()
        
    }
}
extension HPBManageWalletController{
    
    fileprivate func steupTableView(){
        heightContraint.constant = UIScreen.tabbarSafeBottomMargin + 52
        tableView.dataSource = tableDelegater
        tableView.delegate = tableDelegater
        tableView.backgroundColor = UIColor.paBackground
        tableView.estimatedRowHeight = 0
        addHeaderFooter(false, tableView)
        
    }
    
    fileprivate func steupSectionModel(){
        guard let walletModels = self.walletModels else {
            return
        }
        let sectionModel = HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBManagerWalletCell.cellModel, walletModels.count))
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
        self.isHiddenEmptyView(!walletModels.isEmpty,topView:self.view)
    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBManagerWalletCell.self):
                let cell = tableViewBlockParam.cell as! HPBManagerWalletCell
                let row  = tableViewBlockParam.indexPath.row
                let walletModel = self.walletModels?[row]
                let address = HPBStringUtil.noneNull(walletModel?.addressStr)
                let balanceModel = self.allAccoutsbalace[address]
                cell.model = HPBManagerWalletCell.DataModel(name: walletModel?.walletName,
                                                            address: address,
                                                            money: HPBMoneyStyleUtil.share.showFormatMoney(balanceModel?.cnyTotalValue, balanceModel?.usdTotalValue),
                                                            mnemonics: walletModel?.mnemonics,
                                                            headImageName: walletModel?.headName,
                                                            coldState: walletModel?.isColdAddress)
                cell.showAssertFlag = self.showAssertFlag
            default:
                break
            }

        }
        
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            //跳转页面
            let row  = tableViewBlockParam.indexPath.row
            let walletModel = self?.walletModels?[row]
            let walletHandelVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBWalletHandelController.self)) as! HPBWalletHandelController
            walletHandelVC.addressStr = HPBStringUtil.noneNull(walletModel?.addressStr)
            walletHandelVC.from = (walletModel?.isColdAddress == "1") ? .coldWallet : .managerWallet
            self?.navigationController?.pushViewController(walletHandelVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }

}


extension HPBManageWalletController{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        quaryAllBalances {
            finish?()
        }
    }
    
    fileprivate func  quaryAllBalances(complete: (() -> Void)? = nil){
        guard let allAccounts = HPBUserMannager.shared.walletInfos else{ return }
        if allAccounts.isEmpty{
            return
        }
        var allAddress: [String] = []
        allAccounts.forEach {
            allAddress.append($0.addressStr.noneNull)
        }
        
        HPBMainViewModel.getListBalance(accounts: allAddress, success: { (totalCny,totalUsd,results) in
            var balaces: [String: HPBBalanceModel] = [:]
            results.forEach({
                balaces.updateValue($0, forKey: $0.address)
            })
            self.tableView.mj_header.endRefreshing()
            self.allAccoutsbalace = balaces
            self.tableView.reloadData()
            
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg,view: self.tableView)
        }
    }
    

}

