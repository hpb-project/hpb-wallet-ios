//
//  HPBGovernanceRecordController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/12.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceRecordController: UIViewController,HPBEmptyViewProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var emptyView: HPBEmptyView?
    @IBOutlet weak var tableView: UITableView!
    var currentPage: Int = 1
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var proposalListsModels: [HPBProposalModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocationable()
        steupTableView()
        tableViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
    }
    
    fileprivate func steupLocationable(){
        self.title = "News-Governance-Voting-Record".localizable
    }
    
    fileprivate func steupTableView(){
        
        tableView.backgroundColor = UIColor.white
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        addHeaderFooter(true, self.tableView)
        tableView.mj_header.beginRefreshing()
        
    }
    fileprivate func steupSectionModel(){
        let sectionModel = HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBGovernanceRecordCell.cellModel,proposalListsModels.count))
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
        self.isHiddenEmptyView(!proposalListsModels.isEmpty, topView: self.view)

    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBGovernanceRecordCell.self):
                let cell = tableViewBlockParam.cell as! HPBGovernanceRecordCell
                let row = tableViewBlockParam.indexPath.row
                let model = self.proposalListsModels[row]
                cell.model = model
            default:
                break
            }
        }
    
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBGovernanceRecordCell.self):
                let model = self.proposalListsModels[tableViewBlockParam.indexPath.row]
                let detailVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBIssueDetailController.self))
                (detailVC as? HPBIssueDetailController)?.issuseNO = model.issueNo
                self.navigationController?.pushViewController(detailVC, animated: true)
            default:
                break
            }
        }
        
        
        tableDelegater?.cellHeight = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return 0}
            let  identifier = tableViewBlockParam.cellModel.identifier
            let  indexPath  = tableViewBlockParam.indexPath
            switch identifier{
            case String(describing: HPBGovernanceRecordCell.self):
                self.tableView.bounds.size.width = UIScreen.width
                let  height = tableViewBlockParam.tableView.fd_heightForCell(withIdentifier: String(describing: HPBGovernanceRecordCell.self), cacheBy: indexPath) { cell in
                    let model = self.proposalListsModels[indexPath.row]
                    (cell as! HPBGovernanceRecordCell).model = model
                }
                return height

            default:
                return tableViewBlockParam.cellModel.height
            }
        }
    }
    
    



}


extension HPBGovernanceRecordController: HPBRefreshProtocol{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        self.getProposalRecordNetwork(page: self.currentPage) {
            finish?()
        }
    }
    
    func getProposalRecordNetwork(page: Int,complete: (()->Void)?){
        
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let (requestUrl,param) = HPBAppInterface.getProposalRecords(address: currentAddress.noneNull)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                guard let proposalLists =  HPBBaseModel.mp_effectiveModels(result: result,key: "list") as [HPBProposalModel]? else{
                    return
                }
                self.proposalListsModels = proposalLists
                self.steupSectionModel()

            }else{
                showBriefMessage(message: errorMsg,view: self.view)
            }
            
        }
    }
    
    
}
