//
//  HPBControllerProtocol.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import SnapKit

/// 继承自UIViewController上面放UITableView
protocol HPBTableViewProtocol where Self: UIViewController {
    var tableView: UITableView { set get }
    var tableDelegater: HPBTableViewDelegater? { set get }
    var registerAllModels: [HPBSectionModel]? { get } //注册用到的所有cellModels
}

extension HPBTableViewProtocol{
    var registerAllModels: [HPBSectionModel]?{
       get{
            return nil
        }
    }
}

extension HPBTableViewProtocol {
    
    func setupTableView(_ insert: UIEdgeInsets = UIEdgeInsets.zero) {
        tableView.separatorStyle = .none
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.backgroundColor = UIColor.paBackground
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(insert)
        }
        //注册用到的所有cellModels
        self.tableView.registerCell(registerAllModels)
    }
    
    func reloadData(_ sectionModels: [HPBSectionModel]) {
        tableDelegater?.sectionModels = sectionModels
        tableView.reloadData()
    }
    
   
}
