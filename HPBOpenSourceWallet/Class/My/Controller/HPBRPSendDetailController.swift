//
//  HPBRPSendDetailController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRPSendDetailController: HPBBaseController,HPBRefreshProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var currentPage: Int = 1
    var sendDetailModels: [HPBSendDetailModel] = []
    var sendModel: HPBRedPacketSendModel?
    var sendDetailListsModel: HPBSendDetailLists?

    @IBOutlet weak var bottomLabel: UILabel!
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomToview: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News-RedPacket-Detail".localizable
        steupViews()
        configNavigationItem()
    }
    
    fileprivate func configNavigationItem(){
        bottomLabel.text = "News-RedPacket-BottomTip-24H".localizable
        if sendDetailListsModel?.redpacketOver == .ongoing{
            bottomLabel.isHidden = false
            bottomConstraint.constant = 0
            labelBottomToview.constant = UIScreen.tabbarSafeBottomMargin + 10
            let barButtonItem = HPBBarButton.init(title: "News-RedPacket-Continue-Send".localizable)
            barButtonItem.clickBlock = {[weak self] in
                self?.rightItemClicked()
            }
            self.navigationItem.rightBarButtonItem = barButtonItem
        }else {
            self.navigationItem.rightBarButtonItem = nil
            bottomConstraint.constant = -20
            bottomLabel.text = nil
            bottomLabel.isHidden = true
        }
    }
    
    @objc func rightItemClicked() {
        let model = HPBShareLinkModel()
        let redpacketNo = HPBStringUtil.noneNull(sendModel?.redPacketNo)
        model.address = HPBStringUtil.noneNull(sendModel?.fromAddr)
        model.webUrl = HPBAPPConfig.redPacketShareURL + "?id=\(redpacketNo)&lang=\(HPBLanguageUtil.share.language.redPacketStr)"
        model.title  = self.sendModel?.title ?? "News-RedPacket-Placehoder".localizable
        var shareContent = "来自\(model.address.cutOutAddress())的HPB红包"
        if HPBLanguageUtil.share.language == .english{
            shareContent = "A Red Packet from \(model.address.cutOutAddress())"
        }
        model.content = shareContent
        model.image = "common_share_redPacket"
        HPBShareManager.shared.additionalInfo = model
        HPBShareManager.shared.show(.redpacket, currentController: self)
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
        tableView.mj_header.backgroundColor = UIColor.paNavigationColor
        let headerBackView = UIView(frame: CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height))
        headerBackView.backgroundColor = UIColor.paNavigationColor
        tableView.mj_header.addSubview(headerBackView)
        tableView.mj_header.layer.masksToBounds = false
        tableView.layer.masksToBounds = false
        self.startRequestData(true, finish: nil)
        
    }

    fileprivate func steupSectionModel(){
        var cellModels: [HPBCellModel] = []
        cellModels += [HPBRPSendDetailCell.cellModel]
        cellModels += [HPBRPSendTotalCell.cellModel]
        let oneSectionModel = HPBTableViewModel.getSectionModel(cellModels)
        let twosectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBSendListCell.cellModel, count: self.sendDetailModels.count))
        tableDelegater?.sectionModels = [oneSectionModel,twosectionModel]
        tableView.reloadData()
        
    }
    
    
    func  tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier {
            case String(describing: HPBRPSendDetailCell.self):
              let cell = tableViewBlockParam.cell as! HPBRPSendDetailCell
                cell.model = self.sendDetailListsModel
            case String(describing: HPBRPSendTotalCell.self):
                let cell = tableViewBlockParam.cell as! HPBRPSendTotalCell
                guard let model = self.sendDetailListsModel else {return}
                cell.model = model
            case String(describing: HPBSendListCell.self):
                 let cell = tableViewBlockParam.cell as! HPBSendListCell
                 let model = self.sendDetailModels[tableViewBlockParam.indexPath.row]
                cell.model = model
            default:
                break
            }
        }
        
    }
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        let redPacketNo = sendModel?.redPacketNo
        self.getSendDetailNetwork(page: self.currentPage, redPacketNo.noneNull) {
            finish?()
        }
    }
    

}


extension HPBRPSendDetailController{
    
    func getSendDetailNetwork(page: Int,_ redPackNo: String,complete: (()->Void)?){
        
        if self.sendDetailListsModel == nil{
            showHudText(view: self.view)
        }
        let address = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let (requestUrl,param) = HPBAppInterface.getRedPacketDetail(redPacketNo: redPackNo, address: address.noneNull, page: "\(page)")
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD(view: self.view)
            complete?()
            if errorMsg == nil{
                guard let sendDetailLists =  HPBBaseModel.mp_effectiveModel(result: result) as HPBSendDetailLists? else{
                    return
                }
                self.sendDetailListsModel = sendDetailLists
                self.requestDataHandel(pages: sendDetailLists.pages, tableView: self.tableView, refreshBlock: {
                    self.sendDetailModels.removeAll()
                }, reloadBlock: {
                    self.sendDetailModels += sendDetailLists.list
                    self.steupSectionModel()
                })
                //重新判断是否显示‘分享’按钮
                self.configNavigationItem()
            }else{
                showBriefMessage(message: errorMsg,view: self.view)
            }
            
        }
    }
    
}
