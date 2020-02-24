//
//  HPBHRC721RecordController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721RecordController: UIViewController,HPBRefreshProtocol,HPBEmptyViewProtocol {
    
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBHRC721RecordCell.cellModel]
        return [model]
    }
    var model: HPBTokenManagerModel?
    var selectBlock: ((HPBTransferRecord)-> Void)?
    var currentPage: Int = 1
    var emptyView: HPBEmptyView?
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var recordModels: [HPBTransferRecord] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         steupViews()
        quaryTransferRecordNetwork()
    }

    fileprivate func steupViews(){
        tableView.registerCell(registerAllModels)
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.paBackground
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        addHeaderFooter(true, tableView)
        tableViewConfig()
        
    }
    
    fileprivate func steupSectionModel(){
        
        let sectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBHRC721RecordCell.cellModel, count: self.recordModels.count))
        self.isHiddenEmptyView(!recordModels.isEmpty, topView: self.tableView,marginCenter: 30)
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
        
    }
    
   
    
    func tableViewConfig(){
        
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBHRC721RecordCell.self):
                let cell = tableViewBlockParam.cell as! HPBHRC721RecordCell
                let model = self.recordModels[tableViewBlockParam.indexPath.row]
                cell.model = model

            default:
                break
            }
        }
        
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard  let `self` = self else {
                return
            }
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBHRC721RecordCell.self):
              let model = self.recordModels[tableViewBlockParam.indexPath.row]
               self.selectBlock?(model)
            default:
                break
            }
        }
    }

}


extension HPBHRC721RecordController{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        quaryTransferRecordNetwork(currentPage: self.currentPage) {
            finish?()
        }
    }
    

    
    //获取交易记录列表
    fileprivate func quaryTransferRecordNetwork(currentPage: Int = 1,complete: (() -> Void)? = nil){

        if self.recordModels.isEmpty{
            showHudText(view: self.view)
        }
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let contractAdd = self.model?.contractAddress
        let tokenSymbol = self.model?.tokenSymbol
        let (requestUrl,param) = HPBAppInterface.getTransRecordList(address: currentAddress.noneNull, contractType: "HRC-721", contractAdd: contractAdd.noneNull, tokenSymbol: tokenSymbol.noneNull, pageNum: "\(currentPage)")
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            hideHUD(view: self.view)
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
