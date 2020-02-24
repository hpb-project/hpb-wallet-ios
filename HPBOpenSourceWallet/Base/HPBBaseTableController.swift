//
//  HPBBaseTableController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/13.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBBaseTableController: UITableViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupStyleByNavigation(self.navigationController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.paBackground
        self.tableView.keyboardDismissMode = .onDrag
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    deinit {
        debugLog(String(describing: self.classForCoder) + "析构方法执行")
    }
}
