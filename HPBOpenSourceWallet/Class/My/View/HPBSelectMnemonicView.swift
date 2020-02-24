//
//  HPBSelectMnemonicView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/10.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSelectMnemonicView: UIView {
    
    var dataSource: [String] = []{
        willSet{
            let sectionModel =  HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBSelectMnemonicCell.cellModel, newValue.count))
            tableDelegater?.sectionModels  = [sectionModel]
            self.tableView.reloadData()
            
        }
    }
    var selectBlock: ((String)-> Void)?
    @IBOutlet weak var tableView: UITableView!
     var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        steupViews()
    }
    
    
    fileprivate func steupViews(){
        tableView.backgroundColor = UIColor.white
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        tableView.register(UINib(nibName: "HPBSelectMnemonicCell", bundle: nil), forCellReuseIdentifier: "HPBSelectMnemonicCell")
        tableViewConfig()
    }
    
    

    
    func tableViewConfig(){
        
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBSelectMnemonicCell.self):
                let cell = tableViewBlockParam.cell as! HPBSelectMnemonicCell
                cell.content = self.dataSource[tableViewBlockParam.indexPath.row]
            default:
                break
            }
        }
            
          tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard  let `self` = self else {
                return
            }
                let identifier = tableViewBlockParam.cellModel.identifier
                switch identifier{
                case String(describing: HPBSelectMnemonicCell.self):
                    self.selectBlock?(self.dataSource[tableViewBlockParam.indexPath.row])
                default:
                    break
                }
            }
    }
}



