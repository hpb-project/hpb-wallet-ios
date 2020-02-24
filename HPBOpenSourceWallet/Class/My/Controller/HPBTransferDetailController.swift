//
//  HPBTransferDetailController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTransferDetailController: HPBBaseController {

    enum HPBAssertType{
        case mainnet
        case hrc20
        case hrc721
    }
    
    enum HPBSourceFrom: String{
        case transfer = "TransferDetail-Transaction-Title"
        case mappping = "Transfer-Mapping-Detail"
        
        var stateStr: String{
            switch self {
            case .transfer:
                return "TransferDetail-Transaction-Success"
            default:
                return "TransferDetail-Mapping-Success"
            }
        }
        var webScanUrl: String{
            switch self{
            case .transfer:
                return HPBAPPConfig.hpbscanTxHashUrl
            case .mappping:
                return HPBAPPConfig.ethscanTxHashUrl
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBTransferDetailBottomCell.cellModel,HPBTransferDetail721IDCell.cellModel,HPBTransferDeatilInfoCell.cellModel]
        return [model]
    }
    
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var stateLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var assertTypeLabel: UILabel!
    @IBOutlet weak var assertTypeBackView: UIView!
    @IBOutlet weak var topStateImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transferStateLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    var assertType: HPBAssertType = .mainnet
    var sourceFrom: HPBSourceFrom = .transfer
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var recordModel: HPBTransferRecord?
    fileprivate var infosData: [(String,String)] = []
    fileprivate var bottomModel: HPBTransferDetailBottomCell.InfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = sourceFrom.rawValue.localizable
        steupTableView()
        tableViewConfig()
        configDatas()
    }
    
    func configDatas(){

        guard  let `newValue` = recordModel else {
            return
        }
        infosData.append(("TransferDetail-Sender".localizable,newValue.fromAccount))
        infosData.append(("TransferDetail-Receiver".localizable,newValue.toAccount))
        infosData.append(("TransferDetail-ID".localizable,newValue.transactionHash))
        
        var transferFee: String?
        switch sourceFrom {
        case .transfer:
            transferFee = HPBStringUtil.converHpbMoneyFormat(newValue.actulTxFee).noneNull
                + "   HPB"
        case .mappping:
            transferFee =  HPBStringUtil.converHpbMoneyFormat(newValue.actulTxFee,10).noneNull + "   ETH"
        }
        
        let tTimesDate = Date(timeIntervalSince1970: newValue.tTimestap ?? 0)
        bottomModel = HPBTransferDetailBottomCell.InfoModel(blockNumberStr: " \(newValue.blockNumber)", transferFeeStr:  transferFee, transferTimeStr: tTimesDate.toString(by: "yyyy/MM/dd  HH:mm:ss"), isTransfer: sourceFrom == .transfer)
        self.steupSectionModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
    }
    
    fileprivate func steupTableView(){
        switch assertType {
        case .mainnet:
            assertTypeBackView.isHidden = true
            stateLabelTopConstraint.constant = 11
            tableHeaderView.sd_height = 150
            let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
            let money =  HPBStringUtil.converHpbMoneyFormat(HPBStringUtil.noneNull(recordModel?.tValue))
            if currentAddress.noneNull.lowercased() == HPBStringUtil.noneNull(recordModel?.toAccount).lowercased(){
                moneyLabel.text = "+" + money.noneNull + " HPB"
                topStateImage.image = #imageLiteral(resourceName: "my_transferRecord_in")
            }else{
                moneyLabel.text = "-" + money.noneNull + " HPB"
                topStateImage.image = #imageLiteral(resourceName: "my_transferRecord_out")
            }
        case .hrc20:
            self.title  = "Transfer-Token-Transfer".localizable
            assertTypeBackView.isHidden = false
            assertTypeLabel.text = "HRC-20"
            stateLabelTopConstraint.constant = 30
            tableHeaderView.sd_height = 170
            let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
            let money = recordModel?.tValue
            if currentAddress.noneNull.lowercased() == HPBStringUtil.noneNull(recordModel?.toAccount).lowercased(){
                moneyLabel.text = "+" + money.noneNull + " " + HPBStringUtil.noneNull(recordModel?.tokenSymbol)
                topStateImage.image = #imageLiteral(resourceName: "my_transferRecord_in")
            }else{
                moneyLabel.text = "-" + money.noneNull + " " + HPBStringUtil.noneNull(recordModel?.tokenSymbol)
                topStateImage.image = #imageLiteral(resourceName: "my_transferRecord_out")
            }
        case .hrc721:
            self.title  = "Transfer-Token-Transfer".localizable
            let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
            if currentAddress.noneNull.lowercased() == HPBStringUtil.noneNull(recordModel?.toAccount).lowercased(){
                topStateImage.image = #imageLiteral(resourceName: "my_transferRecord_in")
            }else{
                topStateImage.image = #imageLiteral(resourceName: "my_transferRecord_out")
            }
            assertTypeBackView.isHidden = false
            stateLabelTopConstraint.constant = 30
            tableHeaderView.sd_height = 170
            assertTypeLabel.text = "HRC-721"
            moneyLabel.text = recordModel?.tokenSymbol
        }
       
        transferStateLabel.text = sourceFrom.stateStr.localizable
        tableView.backgroundColor = UIColor.white
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
       tableView.registerCell(registerAllModels)
    }

    fileprivate func steupSectionModel(){
        var sectionModel = HPBSectionModel()
        if assertType == .hrc721{
            sectionModel.cellModelArr += [HPBTransferDetail721IDCell.cellModel]
        }
        sectionModel.cellModelArr += [HPBCellModel](repeating: HPBTransferDeatilInfoCell.cellModel, count: infosData.count)
        sectionModel.cellModelArr += [HPBTransferDetailBottomCell.cellModel]
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
    }
    
    fileprivate func tableViewConfig(){
        
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBTransferDetail721IDCell.self):
                 let cell = tableViewBlockParam.cell as! HPBTransferDetail721IDCell
                 cell.content = self.recordModel?.tokenId
            case String(describing: HPBTransferDeatilInfoCell.self):
                let cell = tableViewBlockParam.cell as! HPBTransferDeatilInfoCell
                var row = tableViewBlockParam.indexPath.row
                if self.assertType == .hrc721{
                    row =  row - 1
                }
                let data = self.infosData[row]
                cell.configData(title: data.0, content: data.1)
                cell.copyBlock = {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = $0
                    showBriefMessage(message: "Common-Copy-Success".localizable, view: self.view!)
                }
                cell.isSpecial = (row == self.infosData.count - 1)
            case String(describing: HPBTransferDetailBottomCell.self):
                let cell = tableViewBlockParam.cell as! HPBTransferDetailBottomCell
                 cell.model = self.bottomModel
                 cell.isMainNet = self.assertType == .mainnet
            default:
                break
            }
        }
        
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
             guard let `self` = self else{return}
            let  identifier = tableViewBlockParam.cellModel.identifier
            let  indexPath  = tableViewBlockParam.indexPath
            switch identifier{
            case String(describing: HPBTransferDeatilInfoCell.self):
                
                var hashIndex = 2
                if self.assertType == .hrc721{
                    hashIndex = 3
                }
                if indexPath.row == hashIndex{
                    let webView =   HPBWebViewController()
                    webView.isHaveRightItem = true
                    webView.animationNavgation = true
                    webView.isWhiteNavBtn = false
                    webView.webTitle = self.sourceFrom.rawValue.localizable
                    webView.additionTitle = self.sourceFrom.rawValue.localizable
                    webView.additionStr = (self.recordModel?.transactionHash).noneNull
                    webView.url = self.sourceFrom.webScanUrl + (self.recordModel?.transactionHash).noneNull
                    webView.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(webView, animated: true)
                }
            default:
               return
            }
            
        }
        
        tableDelegater?.cellHeight = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return 0}
            let  identifier = tableViewBlockParam.cellModel.identifier
            let  indexPath  = tableViewBlockParam.indexPath
            switch identifier{
            case String(describing: HPBTransferDeatilInfoCell.self):
                self.tableView.bounds.size.width = UIScreen.width
                let  height = tableViewBlockParam.tableView.fd_heightForCell(withIdentifier: String(describing: HPBTransferDeatilInfoCell.self), cacheBy: indexPath) { cell in
                    var row = tableViewBlockParam.indexPath.row
                    if self.assertType == .hrc721{
                        row = row - 1
                    }
                    let data = self.infosData[row]
                    (cell as! HPBTransferDeatilInfoCell).configData(title: data.0, content: data.1)
                    (cell as! HPBTransferDeatilInfoCell).isSpecial = row == 2
                }
                return height
            default:
                return tableViewBlockParam.cellModel.height
            }
        }
    }

}
