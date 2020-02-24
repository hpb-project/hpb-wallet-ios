//
//  HPBHelpCenterController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHelpCenterController: HPBBaseController,HPBTableViewProtocol {
    var registerAllModels: [HPBSectionModel]?{
        var model = HPBSectionModel()
        model.cellModelArr = [HPBMyPageCell.cellModel(66)]
        return [model]
    }
    enum CellConfig: String{
        case question = "HelpCenter-FAQ"
        case contact =  "HelpCenter-Contact"
        case feedback = "HelpCenter-Feedback"
        init?(row: Int){
            switch row{
            case 0:
                self = .question
            case 1:
                self = .contact
            case 2:
                self = .feedback
            default:
                return nil
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    let itemDatas: [CellConfig] = [.question,.contact,.feedback]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My-Help-Center".localizable
        setupTableView()
        steupSectionModel()
        tableViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension HPBHelpCenterController{
    
    fileprivate func steupSectionModel(){
        let section =  HPBTableViewModel.getSectionModel(cellModelTupleArr: (HPBMyPageCell.cellModel(66), itemDatas.count))
        reloadData([section])
    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else {
                return
            }
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBMyPageCell.self):
                guard let config = CellConfig(row: tableViewBlockParam.indexPath.row) else{return}
                let cell = tableViewBlockParam.cell as! HPBMyPageCell
                let row  = tableViewBlockParam.indexPath.row
                let data = self.itemDatas[row]
                cell.model = HPBMyPageCell.HPBMyPageModel(title: data.rawValue.localizable, leftConstraint: 0,rightConstraint: 20,isHavaBottom: config == .feedback ? false : true)
            default:
                break
            }
        }
        
        tableDelegater?.didSelectCell = { [weak self] tableViewBlockParam in
            guard let `self`  = self else {return}
            guard let config = CellConfig(row: tableViewBlockParam.indexPath.row) else{return}
            self.pushToNextController(config)
        }
    }
    
    fileprivate func pushToNextController(_ config :CellConfig){
        var destinationVC: UIViewController?
        switch config{
        case .question:
            let webView =   HPBWebViewController()
            webView.url = HPBWebViewURL.question + "?language=\(HPBLanguageUtil.share.language.index)"
            webView.webTitle = "HelpCenter-FAQ".localizable
            destinationVC = webView
        case .contact:
            let webView =   HPBWebViewController()
            webView.url = HPBWebViewURL.contact.webViewUrllocalizable
            webView.webTitle = "HelpCenter-Contact".localizable
            destinationVC = webView
        case .feedback:
            let feedbackVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBFeedbackController.self))
            destinationVC = feedbackVC
        }
        
        if let `destinationVC` = destinationVC{
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
