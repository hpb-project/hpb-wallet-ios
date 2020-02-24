//
//  HPBContractUsController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBContractUsController: HPBBaseController,HPBTableViewProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBContractCell.cellModel]
        return [model]
    }
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    let titleArr: [String] = ["微信公共号","官方QQ群","官方电报群","官网微博","推特","Facebook","商业合作"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HelpCenter-Contact".localizable
        setupTableView()
        steupSectionModel()
        tableViewConfig()
    }
}

extension HPBContractUsController{
    
    fileprivate func steupSectionModel(){
        let section =  HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBContractCell.cellModel, titleArr.count))
        reloadData([section])
    }
    
    fileprivate func tableViewConfig(){
        
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let cell = tableViewBlockParam.cell as! HPBContractCell
            let row  = tableViewBlockParam.indexPath.row
            cell.configData(self.titleArr[row],"暂无")
        }
        
    }
}
