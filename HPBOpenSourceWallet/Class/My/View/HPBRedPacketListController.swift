//
//  HPBRedPacketListController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/14.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRedPacketListController: HPBBaseController,HPBRefreshProtocol,HPBEmptyViewProtocol {
    
    enum HPBRedPacketListType: String{
        case send = "1"
        case receive = "0"
    }
    var currentPage: Int = 1
    var emptyView: HPBEmptyView?
    var type: HPBRedPacketListType = .send{
        willSet{
            switch newValue {
            case .send:
                 self.topViewLeftlabel.text = "News-RedPacket-Record-Sent—Total".localizable
            case .receive:
                 self.topViewLeftlabel.text = "News-RedPacket-Record-Receive—Total".localizable
            }
        }
    }
    var redPacketNumber: String = "0"{
        willSet{
          self.topViewCenterLabel.text = newValue
        }
    }
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var sendModels: [HPBRedPacketSendModel] = []
    var receiveModels: [HPBRedPacketReceiveModel] = []
    
    @IBOutlet weak var topViewLeftlabel: UILabel!
    @IBOutlet weak var topViewCenterLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var  sendSelectBlock: ((HPBRedPacketSendModel) -> Void)?
    var  receiveSelectBlock: ((HPBRedPacketReceiveModel) -> Void)?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupViews()
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
        addHeaderFooter(true, tableView)
        tableViewConfig()
        tableView.mj_header.beginRefreshing()
        self.topViewLeftlabel.isHidden = true
        
    }
    
    fileprivate func steupSectionModel(){
        var sectionModel: HPBSectionModel?
        switch type {
        case .send:
            sectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBRedPacketSendCell.cellModel, count: sendModels.count))
        self.isHiddenEmptyView(!sendModels.isEmpty, topView: self.tableView)
        case .receive:
           sectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBRedPacketReceiveCell.cellModel, count: receiveModels.count))
            self.isHiddenEmptyView(!receiveModels.isEmpty, topView: self.tableView)
        }
        guard sectionModel != nil else {return}
        tableDelegater?.sectionModels = [sectionModel!]
        tableView.reloadData()
        
    }
    
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        getRedPacketList(type: self.type,page: self.currentPage) {
            finish?()
        }
    }
    
    
    
    func tableViewConfig(){
        
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBRedPacketSendCell.self):
                 let cell = tableViewBlockParam.cell as! HPBRedPacketSendCell
                 cell.model =  self.sendModels[tableViewBlockParam.indexPath.row]
                
            case String(describing: HPBRedPacketReceiveCell.self):
                let cell = tableViewBlockParam.cell as! HPBRedPacketReceiveCell
               cell.model =  self.receiveModels[tableViewBlockParam.indexPath.row]
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
            case String(describing: HPBRedPacketSendCell.self):
                
                self.sendSelectBlock?(self.sendModels[tableViewBlockParam.indexPath.row])
            case String(describing: HPBRedPacketReceiveCell.self):
                self.receiveSelectBlock?(self.receiveModels[tableViewBlockParam.indexPath.row])
            default:
                break
            }
        }
    }
}


extension HPBRedPacketListController{
    
    func getRedPacketList(type: HPBRedPacketListType,page: Int = 1,complete: (() -> Void)? = nil){
        
        let address = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let (requestUrl,param) = HPBAppInterface.getRedPacketRecord(type: type.rawValue, page: "\(page)", address: address.noneNull)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
              self.topViewLeftlabel.isHidden = false
                switch type{
                case .send:
                    guard let sendLists =  HPBBaseModel.mp_effectiveModel(result: result) as HPBRedPacketSendLists? else{
                        return
                    }
                    self.topViewCenterLabel.text = "\(sendLists.total)"
                    self.requestDataHandel(pages: sendLists.pages, tableView: self.tableView, refreshBlock: {
                        self.sendModels.removeAll()
                    }, reloadBlock: {
                        self.sendModels += sendLists.list
                        self.steupSectionModel()
                    })
                case .receive:
                    guard let receiveLists =  HPBBaseModel.mp_effectiveModel(result: result) as HPBRedPacketReceiveLists? else{
                        return
                    }
                     self.topViewCenterLabel.text = "\(receiveLists.total)"
                    self.requestDataHandel(pages: receiveLists.pages, tableView: self.tableView, refreshBlock: {
                        self.receiveModels.removeAll()
                    }, reloadBlock: {
                        self.receiveModels += receiveLists.list
                        self.steupSectionModel()
                    })
                }
            }
            else{
                showBriefMessage(message: errorMsg, view: self.view)
                complete?()
            }
        }
    }
    
    
}
