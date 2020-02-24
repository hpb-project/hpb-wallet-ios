//
//  HPBTableDelegater.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class HPBTableViewDelegater: NSObject {
    
    typealias HPBTableCellForRowBlock = (tableView: UITableView, indexPath: IndexPath, cell: UITableViewCell, cellModel: HPBCellModel)
    typealias HPBTableDelegateConfigBlock = (tableView: UITableView, indexPath: IndexPath, cellModel: HPBCellModel)
    
    /// 外部需传入的数据源
    var sectionModels: [HPBSectionModel] = []
    
    var configureCell: ((_ tableViewBlockParam: HPBTableCellForRowBlock) -> Void)?
    var didSelectCell: ((_ tableViewBlockParam: HPBTableDelegateConfigBlock) -> Void)?
    var cellHeight: ((_ tableViewBlockParam: HPBTableDelegateConfigBlock) -> CGFloat)?
    var commitDelete: ((_ tableViewBlockParam: HPBTableDelegateConfigBlock) -> Void)?
    var configureHeader: ((_ header: UITableViewHeaderFooterView,_ headerModel: HPBHeaderFooterViewModel) -> Void)?
    var didEndDecelerating: ((_ tableview: UITableView) -> Void)?
    var didEndDragging: ((_ tableview: UITableView, _ willDecelerate: Bool) -> Void)?
    var willBeginDragging: ((_ tableview: UITableView) -> Void)?
    
    func cellModel(_ indexPath: IndexPath) -> HPBCellModel {
        return sectionModels[indexPath.section][indexPath]
    }
    
}


extension HPBTableViewDelegater: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionModels[section].cellModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = self.cellModel(indexPath)
        let identifier = cellModel.identifier
        let cell  = tableView.dequeueReusableCell( withIdentifier: identifier)
        if let configureCell = configureCell {
            let tableCellForRowBlock: HPBTableCellForRowBlock = (tableView, indexPath, cell!, cellModel)
            configureCell(tableCellForRowBlock)
        }
        return cell!
    }
    
}

extension HPBTableViewDelegater: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = self.cellModel(indexPath)
        if let cellHeight = cellHeight {
            let tableDelegateConfigBlock: HPBTableDelegateConfigBlock = (tableView, indexPath, cellModel)
            return cellHeight(tableDelegateConfigBlock)
        } else if cellModel.height > -1 {
            return cellModel.height
        }else{
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let didSelectCell = didSelectCell {
            let cellModel = self.cellModel(indexPath)
            let tableDelegateConfigBlock: HPBTableDelegateConfigBlock = (tableView, indexPath, cellModel)
            didSelectCell(tableDelegateConfigBlock)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = sectionModels[section]
        guard let headerViewModel = sectionModel.headerViewModel else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewModel.identifier)
        configureHeader?(headerView!, headerViewModel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = sectionModels[section]
        guard let footerViewModel = sectionModel.footerViewModel else {
            return nil
        }
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerViewModel.identifier)
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let headerViewModel = sectionModels[section].headerViewModel else {
            return 0
        }
        if headerViewModel.height > -1 {
            return headerViewModel.height
        }
        return  0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let footerViewModel = sectionModels[section].footerViewModel else {
            return 0.01
        }
        if footerViewModel.height > -1 {
            return footerViewModel.height
        }
        return 0.01
    }
    
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let tab = scrollView as? UITableView {
            self.didEndDecelerating?(tab)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let tab = scrollView as? UITableView {
            self.didEndDragging?(tab, decelerate)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let tab = scrollView as? UITableView {
            self.willBeginDragging?(tab)
        }
    }
    
}

extension HPBTableViewDelegater{
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cellModel = self.cellModel(indexPath)
        return cellModel.canEdit
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let commitDelete = commitDelete{
            let cellModel = self.cellModel(indexPath)
            let tableDelegateConfigBlock: HPBTableDelegateConfigBlock = (tableView, indexPath, cellModel)
            commitDelete(tableDelegateConfigBlock)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
}
