//
//  HPBRefreshProtocol.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/19.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import MJRefresh

protocol HPBRefreshProtocol: class {
    
    var  currentPage: Int {get  set}
    func addHeaderFooter(_ isHaveFooter: Bool, _ tableView: UITableView)
    func startRequestData(_ isRefresh: Bool, finish:(()->Void)?)
    func requestDataHandel(pages: Int,tableView: UITableView,
                           refreshBlock: (()->Void)?,
                           reloadBlock: (()->Void)?)
}


extension HPBRefreshProtocol{
    
    func addHeaderFooter(_ isHaveFooter: Bool, _ tableView: UITableView) {
        weak var weakTableView = tableView
        
        
        let mjHeader = MJRefreshNormalHeader.init(){ [weak self] in
            self?.currentPage = 1
            self?.startRequestData(true) {
                weakTableView?.mj_header.endRefreshing()
            }
        }
        tableView.mj_header = mjHeader
        
        if (isHaveFooter){
            let footer = MJRefreshAutoNormalFooter{ [weak self] in
                guard let `self` = self else{return}
                self.startRequestData(false) {
                    weakTableView?.mj_footer.endRefreshing()
                }
            }
            tableView.mj_footer = footer
            tableView.mj_footer.isHidden = true
        }
    }
    
    func requestDataHandel(pages: Int,tableView: UITableView,
                           refreshBlock: (()->Void)?,
                           reloadBlock: (()->Void)?){
        if self.currentPage == 1{
            refreshBlock?()
            tableView.mj_footer.isHidden = false
        }
        debugLog(self.currentPage)
        reloadBlock?()
        if pages == self.currentPage || pages == 0{
            tableView.mj_footer.isHidden = true
        }else{
            self.currentPage += 1
        }
    }
}

