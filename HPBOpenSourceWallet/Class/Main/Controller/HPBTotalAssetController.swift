//
//  HPBTotalAssertController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/14.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTotalAssetController: HPBBaseController,HPBEmptyViewProtocol {
    var emptyView: HPBEmptyView?
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBTransferRecordCell.cellModel]
        return [model]
    }
    let requestAddress: String? = HPBUserMannager.shared.currentWalletInfo?.addressStr
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var receiptBtn: UIButton!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var topBackView: UIView!
    @IBOutlet weak var transferTitleLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var tokenImage: UIImageView!
    
    
    var model: HPBTokenManagerModel?
    var currentPage: Int = 1
    var recordModels: [HPBTransferRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocation()
        steupViews()
        addHeaderFooter(true, tableView)
        tableViewConfig()
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func steupLocation(){
        if self.model?.type == .hrc20{
          self.title = HPBStringUtil.noneNull(self.model?.tokenSymbol) + " " +  "TabBar-Main.title".localizable
           transferTitleLabel.text =   "Transfer-Token-Transfer".localizable
            
        }else{
            self.title = "TotalAsset-Title".localizable
            transferTitleLabel.text =   "TotalAsset-History".localizable
        }
        
        receiptBtn.setTitle("  " + "Main-Receipt".localizable, for: .normal)
        transferBtn.setTitle("  " + "Main-Transfer".localizable, for: .normal)

        guard let model = self.model else {
            return
        }
         totalMoneyLabel.isHidden = model.cnyPrice.isEmpty
         let showBalance = HPBMoneyStyleUtil.share.showFormatMoney(model.cnyTotalValue, model.usdTotalValue)
        totalMoneyLabel.text = showBalance
        if model.type == .hrc20{
             rightImage.isHidden = false
             totalNumberLabel.text = HPBStringUtil.converCustomDigitsFormat(model.balanceOfToken, decimalCount: model.formatDecimals).noneNull + " " +  model.tokenSymbol
        }else if model.type == .mainNet{
            rightImage.isHidden = true
            totalNumberLabel.text = HPBStringUtil.converHpbMoneyFormat(model.balanceOfToken).noneNull + " HPB"
        }
        tokenImage.sd_setImage(with:URL(string: model.tokenSymbolImageUrl), placeholderImage: UIImage.init(named: "common_head_placehoder"))
       
        
    }
    
    
    func steupViews(){
        tableView.registerCell(registerAllModels)
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        topBackView.layer.shadowColor = UIColor.black.cgColor
        topBackView.layer.shadowOffset = CGSize.zero
        topBackView.layer.shadowOpacity = 0.2
        topBackView.layer.shadowRadius = 10
        
    }
    
    
    @IBAction func receiptClick(_ sender: UIButton) {
      let isBackup = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.mnemonics).isEmpty
        if isBackup{
            let receiptVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBReceiptController") as! HPBReceiptController
            receiptVC.myAddress = HPBStringUtil.noneNull(self.requestAddress)
            self.navigationController?.pushViewController(receiptVC, animated: true)
        }else{
            self.showTipBackUpView()
        }
    }
    
    
    
    @IBAction func transferBtnClick(_ sender: UIButton) {
        let isBackup = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.mnemonics).isEmpty
        if isBackup{
            guard let model = self.model else {
                return
            }
            let transferVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBTransferController")
            switch model.type{
            case .mainNet:
               (transferVC as? HPBTransferController)?.remandToken = model.balanceOfToken
                  (transferVC as? HPBTransferController)?.recordTokenName = "HPB"
               (transferVC as? HPBTransferController)?.initTokenType = .mainNet
            case .hrc20:
                (transferVC as? HPBTransferController)?.remandToken = model.balanceOfToken
                (transferVC as? HPBTransferController)?.recordTokenName = model.tokenSymbol
                (transferVC as? HPBTransferController)?.hrcContractAddress = model.contractAddress
                (transferVC as? HPBTransferController)?.recordTokenDecimals = model.formatDecimals
                (transferVC as? HPBTransferController)?.initTokenType = .HRC20
            case .hrc721:
                break
            }
            self.navigationController?.pushViewController(transferVC, animated: true)
            
        }else{
            self.showTipBackUpView()
        }
    }
    
    
    /// 显示备份弹框
    private func showTipBackUpView(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        HPBMainViewModel.showTipBackUpView(controller: self) {[weak self] in
            
            let destinationVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBWalletHandelController.self))
            (destinationVC as! HPBWalletHandelController).from = .other
            (destinationVC as! HPBWalletHandelController).addressStr = HPBStringUtil.noneNull(self?.requestAddress)
    
            self?.navigationController?.pushViewController(destinationVC, animated: true)
            self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}


extension HPBTotalAssetController{
    
    fileprivate func steupSectionModel(){
        let oneSectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBTransferRecordCell.cellModel, count: recordModels.count))
        tableDelegater?.sectionModels = [oneSectionModel]
        self.tableView.reloadData()
         self.isHiddenEmptyView(!recordModels.isEmpty, topView: self.tableView)
        
    }
    
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier {
            case String(describing: HPBTransferRecordCell.self):
                let cell = tableViewBlockParam.cell as! HPBTransferRecordCell
                let row = tableViewBlockParam.indexPath.row
                let recordModel = self.recordModels[row]
               
                var money: String?
                if self.model?.type == .hrc20{
                    money =  recordModel.tValue
                }else{
                    money =  HPBStringUtil.converHpbMoneyFormat(recordModel.tValue)
                }
                cell.recordInfoModel = HPBTransferRecordCell.TransferRecordInfo(self.requestAddress.noneNull,fromAddress: recordModel.fromAccount, toAddress: recordModel.toAccount, time: HPBStringUtil.noneNull(recordModel.formatStr),  money: money.noneNull + HPBStringUtil.noneNull(self.model?.tokenSymbol))
            default:
                break
            }
        }
        
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            let row = tableViewBlockParam.indexPath.row
            let detailVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBTransferDetailController.self)) as!  HPBTransferDetailController
            let model = self?.recordModels[row]
            detailVC.recordModel = model
            if self?.model?.type == .hrc20 {
               detailVC.assertType = .hrc20
            }else{
               detailVC.assertType = .mainnet
            }
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


extension HPBTotalAssetController: HPBRefreshProtocol{
    
    //HPBRefreshProtocol 代理方法
    func startRequestData(_ isRefresh: Bool,finish: (() -> Void)?) {
        self.quaryTransferRecordNetwork(currentPage: self.currentPage) {
            finish?()
        }
    }
}

extension HPBTotalAssetController{
    
    //获取交易记录列表
    fileprivate func quaryTransferRecordNetwork(currentPage: Int = 1,complete: (() -> Void)? = nil){
       
        guard let model = self.model else{return}
        var (requestUrl,param) = HPBAppInterface.getTransRecordList(address: requestAddress.noneNull, pageNum: "\(currentPage)")
        if model.type  == .hrc20{
        (requestUrl,param) = HPBAppInterface.getTransRecordList(address: requestAddress.noneNull, contractType: "HRC-20", contractAdd: model.contractAddress, tokenSymbol: model.tokenSymbol, pageNum: "\(currentPage)")
        }
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBTransferRecordModel? else{
                    return
                }
                //代理方法调用
                self.requestDataHandel(pages: model.pages, tableView: self.tableView, refreshBlock: {
                    self.recordModels.removeAll()
                }, reloadBlock: {
                    self.recordModels += model.list
                    self.steupSectionModel()
                })
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
}
