//
//  HPBMoreIDController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/4.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMoreIDController: UIViewController,HPBRefreshProtocol {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    @IBOutlet weak var tableView: UITableView!
    var currentPage: Int = 1
    var emptyView: HPBEmptyView?
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var transferHashStr: String?
    var contractAddress: String?
    var recordModels: [HPB721StockModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TransferDetail-Transaction-Title".localizable
        steupViews()
        steupSectionModel()
    }
    
    fileprivate func steupViews(){
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.paBackground
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableViewConfig()
        addHeaderFooter(true, tableView)
        request721IdsNetwork(page: self.currentPage)
        
    }
    fileprivate func steupSectionModel(){
        
        let sectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBHRC721MoreCell.cellModel, count: self.recordModels.count))
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
        
    }
    
 
    
    func tableViewConfig(){
        
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBHRC721MoreCell.self):
                let cell = tableViewBlockParam.cell as! HPBHRC721MoreCell
                cell.model = self.recordModels[tableViewBlockParam.indexPath.row]
            default:
                break
            }
        }
    }
}


extension HPBMoreIDController {
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        request721IdsNetwork(page: self.currentPage) {
            finish?()
        }
    }

    
    func request721IdsNetwork(page: Int,complete: (() -> Void)? = nil){
        if self.recordModels.isEmpty{
           showHudText(view: self.view)
        }
        let (requestUrl,param) = HPBAppInterface.get721IdsByTxHash(hash: self.transferHashStr.noneNull, contractAddress: self.contractAddress.noneNull, page: "\(page)")
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD(view: self.view)
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPB721StockList? else{return}
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
