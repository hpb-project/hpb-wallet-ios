//
//  HPBGovernanceController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/8.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceController: UIViewController,HPBEmptyViewProtocol{
    var emptyView: HPBEmptyView?
    
    var currentPage: Int = 1
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    @IBOutlet weak var tableView: UITableView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBGovernanceListCell.cellModel]
        return [model]
    }
    var proposalListsModels: [HPBProposalModel] = []
    
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocationable()
        steupTableView()
        tableViewConfig()
        configNavigationItem()
       
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
        
    }
    
    fileprivate func configNavigationItem(){
        
        let barButtonItem = HPBBarButton.init(image: UIImage(named: "governance_detail_more"))
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedRightNavItem()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func clickedRightNavItem(){
        
        
        let actionSheet = HPBActionSheetController()
        let items = ["News-Governance-Voting-History".localizable,
                     "News-Governance-Voting-Rules".localizable]
        actionSheet.showActionSheet(items) { (index) in
            switch index{
            case 1:
                let record = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBGovernanceRecordController.self))
                self.navigationController?.pushViewController(record, animated: true)
            case 2:
                let webVC = HPBWebViewController()
                webVC.webTitle = "News-Governance-Voting-Rules".localizable
                webVC.isWhiteNavBtn = false
                webVC.url = HPBWebViewURL.voteRule.webViewUrllocalizable
                self.navigationController?.pushViewController(webVC, animated: true)
            default:
                break
            }
        }
        
    }

    fileprivate func steupLocationable(){
        self.title = "News-Governance-Title".localizable
    }
    
    fileprivate func steupTableView(){
        
        tableView.backgroundColor = UIColor.white
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        self.tableView.registerCell(registerAllModels)
        addHeaderFooter(true, self.tableView)
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func steupSectionModel(){
        let sectionModel = HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBGovernanceListCell.cellModel,proposalListsModels.count))
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
        self.isHiddenEmptyView(!proposalListsModels.isEmpty, topView: self.view)

    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBGovernanceListCell.self):
                let cell = tableViewBlockParam.cell as! HPBGovernanceListCell
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
            case String(describing: HPBGovernanceListCell.self):
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
            case String(describing: HPBGovernanceListCell.self):
                self.tableView.bounds.size.width = UIScreen.width
                let  height = tableViewBlockParam.tableView.fd_heightForCell(withIdentifier: String(describing: HPBGovernanceListCell.self), cacheBy: indexPath) { cell in
                    let model = self.proposalListsModels[indexPath.row]
                    (cell as! HPBGovernanceListCell).model = model
                }
                return height
            default:
                return tableViewBlockParam.cellModel.height
            }
        }
    }
    
    deinit {
        debugLog("释放了")
    }
    
    
}


extension HPBGovernanceController: HPBRefreshProtocol{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        self.getProposalListNetwork(page: self.currentPage) {
            finish?()
        }
    }
    
    func getProposalListNetwork(page: Int,complete: (()->Void)?){
        let (requestUrl,param) = HPBAppInterface.getProposalList(page: "\(page)")
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                guard let proposalLists =  HPBBaseModel.mp_effectiveModel(result: result) as HPBProposalLists? else{
                    return
                }
                self.requestDataHandel(pages: proposalLists.pages, tableView: self.tableView, refreshBlock: {
                    self.proposalListsModels.removeAll()
                }, reloadBlock: {
                    self.proposalListsModels += proposalLists.list
                    self.steupSectionModel()
                })
            }else{
                showBriefMessage(message: errorMsg,view: self.view)
            }
            
        }
    }
    
    
}
