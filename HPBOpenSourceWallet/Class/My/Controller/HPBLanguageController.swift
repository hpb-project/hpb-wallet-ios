//
//  HPBChangeLanguageController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/10.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBLanguageController: HPBBaseController ,HPBTableViewProtocol{
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBLanguageCell.cellModel]
        return [model]
    }
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    let itemDatas: [HPBLanguageUtil.LanguageType] = [.chinese,.english]
    var selectRow: Int = 0
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LanguageUtil-Title".localizable
        setupTableView()
        self.selectRow = HPBLanguageUtil.share.language.index
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
        //新选择语言和老语言相同
        let selectLanguage = itemDatas[self.selectRow]
        if HPBLanguageUtil.share.language == selectLanguage{
            HPBLanguageUtil.share.setLanguageUserDefault(selectLanguage)
            self.navigationController?.popViewController(animated: true)
        }else{
           HPBLanguageUtil.share.resetLanguage(selectLanguage)
        }
        
       
    }
}

extension HPBLanguageController{
    
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
