//
//  HPBTwoColumnSelectController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTwoColumnSelectController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBTwoColumnSelectCell.cellModel]
        return [model]
    }
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    var leftDatasource: [HPTransferRecordController.HPBContractType] = []
    var lefttableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    var  righttableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    
    var recordHPBModels: [HPBTokenManagerModel] = []
    
    //var recordHRC20
    var recordLeftIndex: Int = 0
    var recordRightIndex: Int = -1
    var selectLeftBlock: ((Int)-> Void)?
    var selectRightBlock: ((HPTransferRecordController.HPBContractType,String,String)-> Void)?
    var heightValue: CGFloat = 210
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupViews()
        tableViewConfig()
        configInitLayout()
        steupSectionModel(tableView: self.leftTableView)
        steupSectionModel(tableView: self.rightTableView)
        self.getTransferTypeListNetwork(type: leftDatasource[recordLeftIndex])
        
    }
    
    fileprivate func steupViews(){
        topTitleLabel.text = "Common-Select".localizable
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        topView.addGestureRecognizer(tapgesture)
        bottomBackView.backgroundColor = UIColor.white
        bottomBackView.layer.cornerRadius = 12
        bottomBackView.layer.masksToBounds = false
        
        
        
        leftTableView.backgroundColor = UIColor.white
        leftTableView.delegate = lefttableDelegater
        leftTableView.dataSource = lefttableDelegater
        leftTableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            leftTableView.contentInsetAdjustmentBehavior = .never
        }
        rightTableView.backgroundColor = UIColor.white
        rightTableView.delegate = righttableDelegater
        rightTableView.dataSource = righttableDelegater
        rightTableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            rightTableView.contentInsetAdjustmentBehavior = .never
        }
        leftTableView.registerCell(registerAllModels)
        rightTableView.registerCell(registerAllModels)
    }
    
    
    fileprivate func steupSectionModel(tableView: UITableView){
        if self.leftTableView == tableView{
            let sectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBTwoColumnSelectCell.cellModel, count: leftDatasource.count))
            lefttableDelegater?.sectionModels = [sectionModel]
            tableView.reloadData()
        }else{
            let sectionModel = HPBTableViewModel.getSectionModel([HPBCellModel](repeating: HPBTwoColumnSelectCell.cellModel, count: self.recordHPBModels.count))
            righttableDelegater?.sectionModels = [sectionModel]
            tableView.reloadData()
        }
        
    }
    
    
    func configInitLayout(){
        self.bottomConstraint.constant = -UIScreen.height
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.bottomConstraint.constant = -self.heightValue
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (state) in
                
            })
        }
    }
    
    @objc func tapDismiss(){
        self.view.endEditing(true)
        UIView.animate(withDuration: TimeInterval(0.3), animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint.constant = -self.heightValue
            self.view.layoutIfNeeded()
        }) {(state) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    
    fileprivate func tableViewConfig(){
        lefttableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBTwoColumnSelectCell.self):
                let cell = tableViewBlockParam.cell as! HPBTwoColumnSelectCell
                cell.contentLabel.textAlignment = .left
                cell.content = self.leftDatasource[tableViewBlockParam.indexPath.row].rawValue.localizable
                cell.leftSelectCell = self.recordLeftIndex == tableViewBlockParam.indexPath.row
            default:
                break
            }
        }
        
        lefttableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let row  = tableViewBlockParam.indexPath.row
            self.recordLeftIndex = row
            self.leftTableView.reloadData()
            self.selectLeftBlock?(row)
            self.getTransferTypeListNetwork(type: self.leftDatasource[row])
        }
        
        
        righttableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBTwoColumnSelectCell.self):
                let cell = tableViewBlockParam.cell as! HPBTwoColumnSelectCell
                cell.contentLabel.textAlignment = .center
                cell.content = self.recordHPBModels[tableViewBlockParam.indexPath.row].tokenSymbol
            default:
                break
            }
        }
        
        righttableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let row  = tableViewBlockParam.indexPath.row
            let model = self.recordHPBModels[row]
            self.recordRightIndex = row
            self.tapDismiss()
            //// token类型,Token简称,合约地址
            self.selectRightBlock?(self.leftDatasource[self.recordLeftIndex],model.tokenSymbol,model.contractAddress)
        }
    }
    
    
    
    
}


extension HPBTwoColumnSelectController{
    
    func getTransferTypeListNetwork(type: HPTransferRecordController.HPBContractType){
        if type == .mainNet{
            var tokenManagerModel = HPBTokenManagerModel()
            tokenManagerModel.tokenSymbol = "HPB"
            self.recordHPBModels = [tokenManagerModel]
            self.steupSectionModel(tableView: self.rightTableView)
            return
        }
        showHudText(view: self.view)
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let (requestUrl,param) = HPBAppInterface.getTransferTypeList(addrerss: currentAddress.noneNull, type: type.requestStr)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD(view: self.view)
            if errorMsg == nil{
                guard let models = HPBBaseModel.mp_effectiveModels(result: result,key: "list") as [HPBTokenManagerModel]? else{return}
                self.recordHPBModels = models
                self.steupSectionModel(tableView: self.rightTableView)
            }else{
               showBriefMessage(message: errorMsg)
            }
        }
    }
}

