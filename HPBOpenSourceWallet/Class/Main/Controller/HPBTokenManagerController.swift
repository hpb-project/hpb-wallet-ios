//
//  HPBTokenManagerController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/2.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTokenManagerController: UIViewController,HPBEmptyViewProtocol{
    var emptyView: HPBEmptyView?
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    fileprivate lazy var showAssertFlag: Bool = HPBMainViewModel.getShowAssertFlag()
    @IBOutlet weak var tableView: UITableView!
    var tokenManagerModels: [HPBTokenManagerModel] =  []
    var modifyBlock: (()-> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "Transfer-Token-Management".localizable
        steupTableView()
        requestTokeManageNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.modifyBlock?()
    }
    
    fileprivate func steupTableView(){
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.isEditing = true
    }
    fileprivate func steupSectionModel(){
        self.tableView.reloadData()
        self.isHiddenEmptyView(!self.tokenManagerModels.isEmpty, topView: self.view)
    }
    
}

extension HPBTokenManagerController{

    //获取token列表
    fileprivate func requestTokeManageNetwork(complete: (() -> Void)? = nil){
        if tokenManagerModels.isEmpty{
             showHudText(view: self.view)
        }
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let (requestUrl,param) = HPBAppInterface.getTokenManage(address: currentAddress.noneNull)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            hideHUD(view: self.view)
            if errorMsg == nil{
                guard let models =  HPBBaseModel.mp_effectiveModels(result: result,key: "list") as [HPBTokenManagerModel]? else{
                    return
                }
                //开始排序
                let sortModels =  HPBTokenManager.share.sortTokenModel(models)
                self.tokenManagerModels = sortModels
                self.steupSectionModel()
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
}


extension HPBTokenManagerController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.tokenManagerModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HPBTokenManagerCell.self)) as!  HPBTokenManagerCell
        let model = self.tokenManagerModels[indexPath.row]
        cell.model = model
        cell.showAssertFlag = self.showAssertFlag
        cell.isLeftSelect = HPBTokenManager.share.storeArr.contains(model.tokenID)
        cell.selectBlock = {
            let storeArr = HPBTokenManager.share.storeArr
            if $0 == true{
                HPBTokenManager.share.storeArr.append(model.tokenID)
            }else{
                if let index =  storeArr.index(of: model.tokenID){
                    HPBTokenManager.share.storeArr.remove(at: index)
                }
            }
            HPBTokenManager.share.setRecordTokenIDsUserDefault()
            self.tokenManagerModels =  HPBTokenManager.share.sortTokenModel(self.tokenManagerModels)
            tableView.reloadData()
            
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 66
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        ///减2是因为有HPB,只选中一个的情况
        if HPBTokenManager.share.storeArr.count - 2 <= 0{
            tableView.reloadData()
            return
        }
        
        //选中未选中的排序,直接不让排序
        if tokenManagerModels[sourceIndexPath.row].isCanSort == false{
            tableView.reloadData()
            return
        }
        // 选中选中的超过边界
        if destinationIndexPath.row > HPBTokenManager.share.storeArr.count - 2 {
           HPBTokenManager.share.sortSelectTokenID(fromID: self.tokenManagerModels[sourceIndexPath.row].tokenID, toID: self.tokenManagerModels[HPBTokenManager.share.storeArr.count - 2].tokenID)
        }else{
          HPBTokenManager.share.sortSelectTokenID(fromID: self.tokenManagerModels[sourceIndexPath.row].tokenID, toID: self.tokenManagerModels[destinationIndexPath.row].tokenID)
        }
       self.tokenManagerModels =  HPBTokenManager.share.sortTokenModel(self.tokenManagerModels)
        tableView.reloadData()
      
    }
    
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return  true
    }
    
}
