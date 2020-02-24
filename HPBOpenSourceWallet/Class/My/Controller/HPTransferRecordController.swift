//
//  HPTransferRecordController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/13.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import MJRefresh

class HPTransferRecordController: HPBBaseController,HPBTableViewProtocol,HPBEmptyViewProtocol {
    
    enum HPBContractType: String {
        case mainNet = "Transfer-MainNet-Coin"
        case hrc20 = "HRC-20"
        case hrc721 = "HRC-721"
        
        var requestStr: String{
            if self == .mainNet{
                return "HPB"
            }else{
                return self.rawValue
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    let currentMonth: String = Date().toMonthString()
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBAllTransferRecordCell.cellModel]
        let headerModel = HPBHeaderFooterViewModel(identifier: "HPBTransferHeaderView", isRegisterByClass: true, classType: HPBTransferHeaderView.self)
        model.headerViewModel = headerModel
        return [model]
    }
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    var emptyView: HPBEmptyView?
    var currentPage: Int = 1
    fileprivate var requestAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
    fileprivate var recordModels: [HPBTransferRecord] = []
    fileprivate var filterModels: [[HPBTransferRecord]] = []
    
    ///2.0.0融合交易记录代码
    var selectContractAddress: String = ""
    var selectTokenSympol: String = ""
    var selectTokenType: HPBContractType = .mainNet
    var recordLeftIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TransferRecord-Records".localizable
        setupTableView()
        addHeaderFooter(true, tableView)
        tableViewConfig()
        quaryTransferRecordNetwork(true)
        configNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    fileprivate func configNavigationItem(){
        let barButtonItem = HPBBarButton.init(title: "Common-Select".localizable,textColor: UIColor.hpbNavigationColor)
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedRightNavItem()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func clickedRightNavItem(){
       
        let twoColumnVC = HPBTwoColumnSelectController()
        twoColumnVC.leftDatasource = [.mainNet,.hrc20,.hrc721]
        twoColumnVC.recordLeftIndex = self.recordLeftIndex
        twoColumnVC.selectRightBlock = {[weak self] (tokenType,tokenSympol,contractAddress)in
            self?.selectTokenType = tokenType
            self?.selectTokenSympol = tokenSympol
            self?.selectContractAddress = contractAddress
            self?.currentPage = 1
            ///先清空,然后再请求
            self?.recordModels.removeAll()
            self?.steupSectionModel(isChange: true)
            self?.quaryTransferRecordNetwork(true, currentPage: 1, complete: nil)
        }
        twoColumnVC.selectLeftBlock = { [weak self] in
            self?.recordLeftIndex = $0
        }
        
        AppDelegate.shared.window?.rootViewController?.addChildViewController(twoColumnVC)
        AppDelegate.shared.window?.addSubview(twoColumnVC.view)
        twoColumnVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
    }
    
}

extension HPTransferRecordController{

    fileprivate func steupSectionModel(isChange: Bool = false){

        //重置model
        filterModels.removeAll()
        
        //查找所有不重复的monthStr
        var months: [String] = []
        recordModels.forEach {
            if !months.contains($0.monthStr){
                months.append($0.monthStr)
            }
        }
        //创建sectionModels
        var allSections: [HPBSectionModel] = []
        for month in months{
            let models =  recordModels.filter {
                return $0.monthStr == month
            }
            let headerName = month == currentMonth ? "TransferRecord-Current-Month".localizable : month
            let headerModel = HPBHeaderFooterViewModel(identifier: "HPBTransferHeaderView", height: 44, isRegisterByClass: true, classType: HPBTransferHeaderView.self,name: headerName)
            let recordSection =  HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBAllTransferRecordCell.cellModel, models.count),headerViewModel: headerModel)
            allSections.append(recordSection)
            filterModels.append(models)
        }
        reloadData(allSections)
        
        if !isChange{
         self.isHiddenEmptyView(!recordModels.isEmpty, topView: self.view)
        }
        if self.recordModels.isEmpty{
            self.tableView.mj_footer.isHidden = true
        }
    }
    
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = { [weak self] tableViewBlockParam in
            guard let `self` = self else {return}
            let recordCell = tableViewBlockParam.cell as! HPBAllTransferRecordCell
            let section = tableViewBlockParam.indexPath.section
            let row = tableViewBlockParam.indexPath.row
            let model = self.filterModels[section][row]
            recordCell.tokenType = self.selectTokenType
            recordCell.model = model
        }
        
        tableDelegater?.configureHeader = {(header,model) in
          let headerView = header as! HPBTransferHeaderView
             headerView.titile = model.headerFooterViewName
        }
        
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else {return}
            let detailVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBTransferDetailController.self)) as!  HPBTransferDetailController
            let section = tableViewBlockParam.indexPath.section
            let row = tableViewBlockParam.indexPath.row
            detailVC.recordModel = self.filterModels[section][row]
            switch self.selectTokenType {
            case .mainNet:
               detailVC.assertType = .mainnet
            case .hrc20:
                 detailVC.assertType = .hrc20
            case .hrc721:
                 detailVC.assertType = .hrc721
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension HPTransferRecordController: HPBRefreshProtocol{

    //HPBRefreshProtocol 代理方法
    func startRequestData(_ isRefresh: Bool,finish: (() -> Void)?) {
        self.quaryTransferRecordNetwork(currentPage: self.currentPage) {
            finish?()
        }
    }
}


extension HPTransferRecordController{

    //获取交易记录列表
    fileprivate func quaryTransferRecordNetwork(_ firstRequest: Bool = false,currentPage: Int = 1,complete: (() -> Void)? = nil){
        let (requestUrl,param) = HPBAppInterface.getTransRecordList(address: requestAddress.noneNull, contractType: self.selectTokenType.requestStr, contractAdd: self.selectContractAddress, tokenSymbol: self.selectTokenSympol, pageNum: "\(currentPage)")
        if firstRequest{
            showHudText(view: self.view)
        }
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

