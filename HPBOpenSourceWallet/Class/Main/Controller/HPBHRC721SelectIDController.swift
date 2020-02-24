//
//  HPBHRC721SelectIDController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/6.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721SelectIDController: UIViewController,HPBEmptyViewProtocol,HPBRefreshProtocol  {

    @IBOutlet weak var tableView: UITableView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var selectBlock: ((String)-> Void)?
    var currentPage: Int = 1
    var recordModels: [HPB721StockModel] = []
    var emptyView: HPBEmptyView?
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var contractAddress: String?
    var selectRow: Int = -1
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var tokenIdLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transfer-Select-ID-Title".localizable
        confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
        cancelBtn.setTitle("Common-Cancel".localizable, for: .normal)
        steupViews()
        request721StockList(page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
    }
    
    

    @IBAction func cancelClick(_ sender: UIButton) {
       
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmClick(_ sender: UIButton) {
         self.selectBlock?(self.recordModels[self.selectRow].tokenId)
         self.navigationController?.popViewController(animated: true)
    }

    
    fileprivate func steupViews(){
        rankLabel.text = "Transfer-Select-ID-Ranking".localizable
        tokenIdLabel.text = "Transfer-Token-ID".localizable
        bottomBackView.layer.shadowColor = UIColor.black.cgColor
        bottomBackView.layer.shadowOffset = CGSize.zero
        bottomBackView.layer.shadowOpacity = 0.2
        bottomBackView.layer.shadowRadius = 10
        
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableViewConfig()
        addHeaderFooter(true, self.tableView)
        
    }
    fileprivate func steupSectionModel(){
        
        let sectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBHRC721SelectIDCell.cellModel, count: recordModels.count))
        self.isHiddenEmptyView(!recordModels.isEmpty, topView: self.tableView)
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
        
    }
    
    func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBHRC721SelectIDCell.self):
                let cell = tableViewBlockParam.cell as! HPBHRC721SelectIDCell
                let index = tableViewBlockParam.indexPath.row
                cell.model = self.recordModels[index]
                cell.indexStr = "\(index + 1)"
                cell.select = self.selectRow == index
                cell.confirmBlock = {
                    self.selectRow = index
                    self.tableView.reloadData()
                }
            default:
                break
            }
        }
    }


}



extension HPBHRC721SelectIDController{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        self.request721StockList(page: self.currentPage) {
            finish?()
        }
    }
    
    func request721StockList(page: Int,complete: (() -> Void)? = nil){
        
        if self.recordModels.isEmpty{
            showHudText(view: self.view)
        }
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let contractAddress = self.contractAddress.noneNull
        let (requestUrl,param) = HPBAppInterface.getToken721StockList(address: currentAddress.noneNull, contractAddress: contractAddress, page: "\(page)")
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            hideHUD(view: self.view)
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPB721StockList? else{return}
                self.requestDataHandel(pages: model.pages , tableView: self.tableView, refreshBlock: {
                     self.recordModels.removeAll()
                }, reloadBlock: {
                    self.recordModels += model.list
                    self.steupSectionModel()
                })
            }else{
                showBriefMessage(message: errorMsg,view: self.view)
            }
        }
        
    }
    
    
}
