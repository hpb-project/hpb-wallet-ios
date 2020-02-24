//
//  HPBCurrencySettingController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/19.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBCurrencySettingController: HPBBaseController,HPBTableViewProtocol {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBLanguageCell.cellModel]
        return [model]
    }
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    let itemDatas: [HPBMoneyStyleUtil.MoneyStyle] = [.rmb,.usd]
    var selectRow: Int = 0
    var footerView: UIView = UIView()
    var exampleLabel: HPBLabel = HPBLabel(titleColor: UIColor.paNavigationColor, fontValue: 17)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My-Currency-Change".localizable
        setupTableView()
        self.selectRow = HPBMoneyStyleUtil.share.style.index
        tableViewConfig()
        steupSectionModel()
        configNavigationItem()
    }
    
    
    
    fileprivate func configNavigationItem(){
        let barButtonItem = HPBBarButton.init(title: "Common-Save".localizable)
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedRightNavItem()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    
    @objc func clickedRightNavItem() {
        let selectStyle = itemDatas[self.selectRow]
        if HPBMoneyStyleUtil.share.style == selectStyle{
            HPBMoneyStyleUtil.share.setMoneyStyleUserDefault(selectStyle)
            self.navigationController?.popViewController(animated: true)
        }else{
            HPBMoneyStyleUtil.share.resetMoneyStyle(selectStyle)
        }
    }
    
    
}



extension HPBCurrencySettingController{
    
    
    fileprivate func steupSectionModel(){
        let sectionModel = HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBLanguageCell.cellModel, itemDatas.count))
        reloadData([sectionModel])
    }
    
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let cell = tableViewBlockParam.cell as! HPBLanguageCell
            let row  = tableViewBlockParam.indexPath.row
            cell.title = self.itemDatas[row].name.localizable
            cell.isSelect = self.selectRow == row
            cell.separatorLineStyle = row == 0 ? .doubleSpace : .none
            
        }
        
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let row  = tableViewBlockParam.indexPath.row
            self.selectRow = row
            self.tableView.reloadData()
        }
        
    }
    
    
    
}

