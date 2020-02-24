//
//  HPBIssueDetailController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/9.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import HPBWeb3SDK
import IQKeyboardManagerSwift

class HPBIssueDetailController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    @IBOutlet weak var tableView: UITableView!
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    var currentPage: Int = 1
    var issuseNO: String = ""
    fileprivate var model: HPBProposalModel?
    //发送投票后的hash
    var voteHash: String?
    fileprivate var tryCount: Int = 0
    fileprivate let maxTryCount: Int = 15   //最多请求30s
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocationable()
        steupTableView()
        tableViewConfig()
        configNavigationItem()
        //网络请求
        getProposalDetailNetwork(issueNo: self.issuseNO)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
    }
    
    fileprivate func configNavigationItem(){
        let barButtonItem = HPBBarButton.init(title: "News-Governance-Voting-Rules".localizable,textColor: UIColor.init(withRGBValue: 0x283041))
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedRightNavItem()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func clickedRightNavItem(){
        let webVC = HPBWebViewController()
        webVC.isWhiteNavBtn = false
        webVC.webTitle = "News-Governance-Voting-Rules".localizable
        webVC.url = HPBWebViewURL.voteRule.webViewUrllocalizable
        self.navigationController?.pushViewController(webVC, animated: true)

    }

    
    fileprivate func steupLocationable(){
        self.title = "News-Governance-Proposal-Details".localizable
    }
    
    fileprivate func steupTableView(){
        tableView.backgroundColor = UIColor.white
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        addHeaderFooter(false, self.tableView)
        tableView.mj_header.beginRefreshing()
        
    }
    fileprivate func steupSectionModel(){
        guard let model = self.model else {return}
        var sectionModel = HPBSectionModel()
        sectionModel.cellModelArr += [HPBGovernanceIssureCell.cellModel,HPBGovernanceVoteCell.cellModel,
                                      HPBGovernanceVoteCell.cellModel]
         //作废原因
        if model.voteType == .obsolete{
           sectionModel.cellModelArr += [HPBGovernanceReasonCell.cellModel]
        }
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadData()
    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBGovernanceIssureCell.self):
                let cell = tableViewBlockParam.cell as! HPBGovernanceIssureCell
                cell.model = self.model
                
            case String(describing: HPBGovernanceVoteCell.self):
                let cell = tableViewBlockParam.cell as! HPBGovernanceVoteCell
                let row =  tableViewBlockParam.indexPath.row
                cell.voteBlock = { type in
                    guard  let voteView = HPBViewUtil.instantiateViewWithBundeleName(HPBGovernanceVoteView.self) as? HPBGovernanceVoteView else{return}
                    voteView.voteType = type
                    voteView.model = self.model
                    voteView.confirmBlock = {(type,voteNum) in
                       self.governanceVoteSinature(type, voteNum)
                    }
                    AppDelegate.shared.window?.addSubview(voteView)
                    voteView.snp.makeConstraints { (make) in
                        make.edges.equalTo(UIEdgeInsets.zero)
                    }
                }
                if row == 1{
                    cell.type = .agree
                }else{
                    cell.type = .against
                }
                cell.model = self.model
                
            case String(describing: HPBGovernanceReasonCell.self):
                 let cell = tableViewBlockParam.cell as! HPBGovernanceReasonCell
                cell.content = "News-Governance-Obsolete-Reason".localizable
            default:
                break
            }
        }
       
        tableDelegater?.cellHeight = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return 0}
            let  identifier = tableViewBlockParam.cellModel.identifier
            let  indexPath  = tableViewBlockParam.indexPath
            switch identifier{
            case String(describing: HPBGovernanceIssureCell.self):
                self.tableView.bounds.size.width = UIScreen.width
                let  height = tableViewBlockParam.tableView.fd_heightForCell(withIdentifier: String(describing: HPBGovernanceIssureCell.self), cacheBy: indexPath) { cell in
                    (cell as! HPBGovernanceIssureCell).model = self.model
                }
                return height
                
            case String(describing: HPBGovernanceReasonCell.self):
                self.tableView.bounds.size.width = UIScreen.width
                let  height = tableViewBlockParam.tableView.fd_heightForCell(withIdentifier: String(describing: HPBGovernanceReasonCell.self), cacheBy: indexPath) { cell in
                    (cell as! HPBGovernanceReasonCell).content = "News-Governance-Obsolete-Reason".localizable
                }
                return height
            default:
                return tableViewBlockParam.cellModel.height
            }
        }
    }
    
}

extension HPBIssueDetailController: HPBRefreshProtocol{
    
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        self.getProposalDetailNetwork(issueNo: self.issuseNO) {
            finish?()
        }
    }

}


extension HPBIssueDetailController {
    
    func getProposalDetailNetwork(issueNo: String,complete: (()->Void)? = nil){
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let (requestUrl,param) = HPBAppInterface.getProposalDetail(address: currentAddress.noneNull, issueNo: issueNo)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            if errorMsg == nil{
                guard let proposalModel =  HPBBaseModel.mp_effectiveModel(result: result) as HPBProposalModel? else{
                    return
                }
                self.model = proposalModel
                self.steupSectionModel()
            }else{
                showBriefMessage(message: errorMsg,view: self.view)
            }
            
        }
    }
    
    
    func governanceVoteSinature(_ type: HPBGovernanceVoteCell.HPBGovernanceVoteType,_ voteNum: String){
        
        guard let proposalModel = self.model else{return}
        let issuNo = proposalModel.issueNo
        let  flag = type.typeValue
        let  myAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        
        //冷钱包投票的话
        if HPBUserMannager.shared.currentWalletInfo?.isColdAddress == "1"{
            let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
            HPBMainViewModel.getTradeFeeRequest(account: currentAddress.noneNull, type: .transfer, success: { (model) in
                let dataStr = HPBMainViewModel.transactionSinature(addParam: [issuNo,flag,voteNum], constractAdd: proposalModel.issurContractAddress, type: .governanceVote)
                var qrCodeArr: [Any] = ["2"]
                var optionName: String = ""
                switch type{
                case .agree:
                    optionName = proposalModel.option1Name
                case .against:
                     optionName = proposalModel.option2Name
                }
                let qrCodeDic: [String: String] = ["from": currentAddress.noneNull,
                                                   "suportStatus": optionName,
                                                   "pollNum": voteNum,
                                                   "content": proposalModel.titleName,
                                                   "gaslimt": model.gasLimit,
                                                   "gasprice": model.gasPrice,
                                                   "nonce": "\(model.nonce)",
                    "data": dataStr.noneNull,
                    "contractAddress": proposalModel.issurContractAddress]
                qrCodeArr.append(qrCodeDic)
                HPBColdImageCodeManager.share.showClodWalletImageCode(qrCodeArr, nav: self.navigationController){
                    //发送签名，
                    showHudText(view: self.view)
                    self.sendGovernanceVoteNetwork(issuseNO: issuNo, flag: "\(flag)", voteNum: voteNum, signature: $0)
                }
                
            }) { (errorMsg) in
                showBriefMessage(message: errorMsg, view: self.view)
            }
            return
        }
        //弹出密码输入框
        var message = "投票总数共\(voteNum)票"
        if HPBLanguageUtil.share.language == .english{
           message = "Total Votes: \(voteNum)"
        }
        HPBAlertView.showPasswordAlert(in: self, message: message,statusBarStyle:.default) { (password) in
            self.view.endEditing(true)
            //获取Nonce
            showHudText(view: self.view)
            HPBMainViewModel.getTradeFeeRequest(account: myAddress.noneNull, type: .transfer, success: { (model) in
                //获取签名
                HPBMainViewModel.signContractTransaction(fromAddress: myAddress, toAddress: myAddress.noneNull, constractAdd: proposalModel.issurContractAddress, money: "0", feeModel: model, password: password.noneNull, addParam: [issuNo,flag,voteNum], type: HPBMainViewModel.HPBContractSinature.governanceVote, success: { (signature) in
                    //发送签名，
                    self.sendGovernanceVoteNetwork(issuseNO: issuNo, flag: "\(flag)", voteNum: voteNum, signature: signature.addHexPrefix())
                    
                }, failure: { (errorMsg) in
                    showBriefMessage(message: errorMsg, view: self.view)
                })
                
            }) { (errorMsg) in
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
       
    }
    
    func sendGovernanceVoteNetwork(issuseNO: String,flag: String,voteNum: String,signature: String){
        let  myAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let  formatVoteNum = HPBStringUtil.converEthMoneyStr(voteNum)
        let (requestUrl,param) = HPBAppInterface.getProposalVote(issuse: issuseNO, address: myAddress.noneNull, state: flag, vote: formatVoteNum, sinature: signature)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                self.voteHash = HPBStringUtil.transformFromJSON(result)  // 投票成功的hash
                self.retryGetVoteState()   //轮询查询state
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
    
    
}


extension HPBIssueDetailController{
    
    
    @objc fileprivate func retryGetVoteState(_ isShowHUD: Bool = true){
        
        if isShowHUD{
             showHudText(string: "Common-Block-Confirming-State".localizable, view: self.view)
        }
        self.getVoteState(hash: self.voteHash.noneNull, success: {[weak self] in
            guard let `self` = self else{return}
            showBriefMessage(message: "Vote-Success-Tip".localizable, view: self.view)
            self.tryCount = 0
            self.tableView.mj_header.beginRefreshing()
            }, faile: {[weak self] in
                guard let `self` = self else{return}
               showBriefMessage(message: "Vote-Faile-Tip".localizable, view: self.view)
                self.tryCount = 0
                
                
            }, progress: {[weak self] in
                guard let `self` = self else{return}
                if self.tryCount > self.maxTryCount{
                    hideHUD(view: self.view)
                    self.tryCount = 0
                }else{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.tryCount += 1
                        self.retryGetVoteState(false)      //递归查询
                    }
                }
        })
        
    }
    
    //获取成功状态
    fileprivate func getVoteState(hash: String,success: (() -> Void)? = nil,faile: (() -> Void)? = nil ,progress: (() -> Void)? = nil){
        let (requestUrl,param) = HPBAppInterface.getTransactionReceipt(hash: hash)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as  HPBTransferStateModel? else{
                    progress?()
                    return
                }
                if model.isSuccess{      //转账成功,请求数据
                    success?()
                } else if model.isFaile{
                    faile?()
                }else{
                    progress?()
                }
            }else{
                progress?()
            }
        }
    }
    
}

