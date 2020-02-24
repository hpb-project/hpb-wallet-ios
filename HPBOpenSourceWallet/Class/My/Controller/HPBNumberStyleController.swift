//
//  HPBNumberStyleController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/6.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBNumberStyleController: HPBBaseController ,HPBTableViewProtocol {

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
    let itemDatas: [HPBNumberStyleUtil.NumberStyle] = [.china,.germany]
    var selectRow: Int = 0
    var footerView: UIView = UIView()
    var exampleLabel: HPBLabel = HPBLabel(titleColor: UIColor.paNavigationColor, fontValue: 17)
    var exampleArr: [HPBNumberStyleUtil.NumberStyle] = [.china,.germany]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NumberStyle-Style".localizable
        setupTableView()
        self.selectRow = HPBNumberStyleUtil.share.style.index
        configFooterView()
        tableViewConfig()
        steupSectionModel()
        configNavigationItem()
    }

    fileprivate func configFooterView(){
        
       footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 100)
       tableView.tableFooterView = footerView
        let topLabel = HPBLabel( titleColor: UIColor.paNavigationColor, fontValue: 15, content: "NumberStyle-Example".localizable)
        footerView.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
            make.height.equalTo(20)
        }
        footerView.addSubview(exampleLabel)
        exampleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).offset(3)
        }
        self.exampleLabel.text = exampleArr[self.selectRow].example
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
        if HPBNumberStyleUtil.share.style == selectStyle{
            HPBNumberStyleUtil.share.resetNumberStyle(selectStyle)
            self.navigationController?.popViewController(animated: true)
        }else{
            HPBNumberStyleUtil.share.resetNumberStyle(selectStyle)
        }
    }
    

}



extension HPBNumberStyleController{


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
            self.exampleLabel.text = self.exampleArr[self.selectRow].example
        }
        
    }



}
