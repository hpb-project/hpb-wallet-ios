//
//  HPBMyController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import RealmSwift

class HPBMyController: HPBBaseController {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var topShareLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    var tableDelegater: HPBTableViewDelegater? =  HPBTableViewDelegater()
    let itemDatas: [CellConfig] = [.walletManage,.transferRecord,
                                   .empty,.setting,.help]
    lazy var walletModels: Results<HPBWalletRealmModel>?  = {
        return HPBUserMannager.shared.walletInfos
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupViews()
        steupSectionModel()
        tableViewConfig()
        configLocationalble()
    }
    
    
    func configLocationalble(){
        titleLabel.text  = "TabBar-My.title".localizable
        shareBtn.setTitle("My-Share-Now".localizable, for: .normal)
        topShareLabel.text = "My-Share-Friend".localizable
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///防止没有钱包的时候,弹出框信号区为白色
        if  HPBUserMannager.shared.currentWalletInfo == nil{
            (navigationController as? HPBBaseNavigationController)?.isWhiteBar = true
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        myTableView.reloadData()
    }
    
    
    @IBAction func shareBtnClick(_ sender: UIButton) {
          let downloadVC = HPBShareDownloadController()
        downloadVC.hidesBottomBarWhenPushed  = true
        self.navigationController?.pushViewController(downloadVC, animated: true)
    }
}


extension HPBMyController{
    
    fileprivate func steupViews(){

        topView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 164 +  UIScreen.statusHeight)
        shareBtn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        shareBtn.layer.cornerRadius = 3
        shareBtn.layer.masksToBounds = true
        if #available(iOS 11, *) {
            myTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        myTableView.backgroundColor = UIColor.white
        myTableView.delegate = tableDelegater
        myTableView.dataSource = tableDelegater
        myTableView.estimatedRowHeight = 0
    }
    
    
    fileprivate func steupSectionModel(){
        var cellModels: [HPBCellModel] = []
        cellModels += [HPBCellModel](repeating: HPBMyPageCell.cellModel(50), count: 2)
        cellModels += [HPBEmptyCell.cellModel()]
        cellModels += [HPBCellModel](repeating: HPBMyPageCell.cellModel(50), count: 2)
        let sectionModel = HPBTableViewModel.getSectionModel(cellModels)
        tableDelegater?.sectionModels = [sectionModel]
        myTableView.registerCell([sectionModel])
        myTableView.reloadData()
    }
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBMyPageCell.self):
                let cell = tableViewBlockParam.cell as! HPBMyPageCell
                let row  = tableViewBlockParam.indexPath.row
                let data = self.itemDatas[row]
                var rightText: String? = nil
                if data == .walletManage{
                    rightText =  HPBWalletManager.getCurrentWalletInfo()?.walletName
                }
                let model = HPBMyPageCell.HPBMyPageModel(title: data.rawValue.localizable, image: data.image,noSpace:true, rightText: rightText)
                cell.model = model
            default:
                break
            }
        }
        tableDelegater?.didSelectCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBMyPageCell.self):
                guard let config = CellConfig(row: tableViewBlockParam.indexPath.row) else{return}
                self.pushToNextController(config)
            default:
                break
            }
        }
    }
    
}



extension HPBMyController{


    fileprivate func pushToNextController(_ config :CellConfig = .setting,createWallet: Bool = false){
        
        var destinationVC: UIViewController?
        switch config{
        case .help:
            let helpCenterVC = HPBHelpCenterController()
            destinationVC = helpCenterVC
        case .setting:
            let settingVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBSystemSetingController.self))
            destinationVC = settingVC
        case .walletManage:
            if judgehaveWallet() == false{ return} //判断是否创建钱包
            let managerVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBManageWalletController.self))
            destinationVC = managerVC
        case .transferRecord:
            if judgehaveWallet() == false{ return} //判断是否创建钱包
            destinationVC = HPTransferRecordController()
        default:
            destinationVC = nil
        }
        
        if createWallet{
            destinationVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBCreatWalletController.self))
        }
        if let `destinationVC` = destinationVC{
            destinationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

    
    fileprivate func judgehaveWallet() -> Bool{
        if  HPBUserMannager.shared.currentWalletInfo == nil{
            (navigationController as? HPBBaseNavigationController)?.isWhiteBar = true
            HPBAlertView.showNomalAlert(in: self, title: "Common-Tip".localizable, message: "Common-No-Wallet".localizable) {
                self.pushToNextController(createWallet: true)
            }
            return false
        }
        return true
    }

}
