//
//  HPBHRC721IDDetailController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/4.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721IDDetailController: UIViewController,HPBRefreshProtocol,HPBEmptyViewProtocol {
    var emptyView: HPBEmptyView?
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var currentPage: Int = 1

    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    
    @IBOutlet weak var tokenIDLabel: UILabel!
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var receiptBtn: UIButton!
    @IBOutlet weak var tokenTypeLabel: UILabel!
    @IBOutlet weak var transferTimesLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var receicptTransferTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    var tokenID: String?
    var contractAdd: String?
    var transferTimes: String?
    var tokenSymbol: String?
    var balanceOfToken: String?
    var transferModels: [HPBTransferRecord] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocation()
        steupViews()
        tableViewConfig()
        request721IdDetail(page: 1)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    func steupLocation(){
        self.title = tokenSymbol.noneNull + " " + "TabBar-Main.title".localizable
        receiptBtn.setTitle("  " + "Main-Receipt".localizable, for: .normal)
        transferBtn.setTitle("  " + "Main-Transfer".localizable, for: .normal)
        receicptTransferTitleLabel.text = "Transfer-10-most-Recent".localizable
    }
    
    
    fileprivate func steupViews(){
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowRadius = 10
        tableView.backgroundColor = UIColor.white
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        headImage.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(showPreViewVC))
        headImage.addGestureRecognizer(tapgesture)
        self.tokenIDLabel.text = "\("Transfer-Token-ID".localizable): " + self.tokenID.noneNull
        self.transferTimesLabel.text = "\("Transfer-Transfer-Times".localizable): " + self.transferTimes.noneNull
        addHeaderFooter(false, self.tableView)
    }
    
    @objc func showPreViewVC(){
      let previewImageVC = HPBPreviewImageController()
        self.navigationController?.pushViewController(previewImageVC, animated: true)

    }
    @IBAction func receiptClick(_ sender: UIButton) {
        
        let isBackup = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.mnemonics).isEmpty
        if isBackup{
            let receiptVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBReceiptController") as! HPBReceiptController
            receiptVC.myAddress = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.addressStr)
            self.navigationController?.pushViewController(receiptVC, animated: true)
        }else{
            self.showTipBackUpView()
        }
        
    }
    
    
    @IBAction func transferClick(_ sender: UIButton) {
        
        let isBackup = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.mnemonics).isEmpty
        if isBackup{
            let transferVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBTransferController")
            (transferVC as? HPBTransferController)?.initTokenType = .HRC721
            (transferVC as? HPBTransferController)?.remandToken = self.balanceOfToken
            (transferVC as? HPBTransferController)?.recordTokenName = HPBStringUtil.noneNull(self.tokenSymbol)
            (transferVC as? HPBTransferController)?.hrcContractAddress = self.contractAdd
            (transferVC as? HPBTransferController)?.recordTokenDecimals = 0
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
            (destinationVC as! HPBWalletHandelController).addressStr = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.addressStr)
            
            self?.navigationController?.pushViewController(destinationVC, animated: true)
            self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    fileprivate func steupSectionModel(){
        let sectionModel = HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBHRC721IDDetailCell.cellModel,self.transferModels.count))
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
        self.isHiddenEmptyView(!self.transferModels.isEmpty, topView: self.tableView,marginCenter: 30)
    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBHRC721IDDetailCell.self):
                let cell = tableViewBlockParam.cell as! HPBHRC721IDDetailCell
                let model = self.transferModels[tableViewBlockParam.indexPath.row]
                cell.model = model
            default:
                break
            }
        }
        
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let detailVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBTransferDetailController.self)) as!  HPBTransferDetailController
            let model = self.transferModels[tableViewBlockParam.indexPath.row]
            detailVC.assertType = .hrc721
            detailVC.recordModel = model
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension HPBHRC721IDDetailController{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        request721IdDetail(page: self.currentPage){
            finish?()
        }
    }
    
    
    func request721IdDetail(page: Int,complete: (() -> Void)? = nil){
        showHudText(view: self.view)
        let (requestUrl,param) = HPBAppInterface.getToken721StockDetail(id: self.tokenID.noneNull, page: "\(page)", contractAdd: self.contractAdd.noneNull)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD(view: self.view)
            if errorMsg == nil{
                guard let models =  HPBBaseModel.mp_effectiveModels(result: result,key: "list") as [HPBTransferRecord]? else{return}
                self.transferModels = models
                self.steupSectionModel()
               self.tableView.mj_header.endRefreshing()
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }

    }
    
}
