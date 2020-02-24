//
//  HPBMnemonicsController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/11.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class HPBMnemonicsController: HPBBaseController,HPBCustomPopProtocol{
    
    @IBOutlet weak var tableView: UITableView!
    var tableDelegater: HPBTableViewDelegater? = HPBTableViewDelegater()
    // 明文助记词
    var mnemonics: String?
    var walletAddress: String?
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    lazy var bottomBtn: HPBButton = {
        let btn =  HPBButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.hpbBtnSelectColor
        btn.layer.cornerRadius = 4
        btn.setTitle("Common-Next".localizable, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mnemonics-Backup".localizable
        steupViews()
        steupSectionModel()
        tableViewConfig()
        configNavigationItem()
        HPBExportViewModel.showAlert(vc: self, gestureEnble: false, content: "CommonAlert-Export-Mnemonic".localizable)
    }
    
    fileprivate func configNavigationItem(){
        let imageName = UIImage(named: "back_leftBtn_white")
        let barButtonItem = HPBBarButton.init(image: imageName)
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedLeftNavItem()
        }
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    func clickedLeftNavItem(){
        if self.bottomBtn.isHidden{
            self.bottomBtn.isHidden = false
            self.steupSectionModel()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension HPBMnemonicsController{
    
    fileprivate func steupViews(){
        tableView.backgroundColor = UIColor.paBackground
        tableView.delegate = tableDelegater
        tableView.dataSource = tableDelegater
        tableView.estimatedRowHeight = 0
        
        view.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-40)
        }
        bottomBtn.addClickEvent{ [weak self] in
            guard let `self` = self else{return}
            HPBAlertView.showNomalAlert(in: self,title: "Mnemonics-Disclaimer".localizable, message: "BackupMnemonics-Disclaimer-content".localizable, onlyConfirm: true,complation: nil)
            self.bottomBtn.isHidden = true
            self.steupSectionModel(false)
        }
    }
    


    fileprivate func steupSectionModel(_ isShowMnemonic: Bool = true){
        var cellModel: HPBCellModel? = nil
        if isShowMnemonic{
            cellModel = HPBShowMnemonicCell.cellModel
        }else{
            cellModel = HPBConfirmMnemoCell.cellModel
        }
        let sectionModel = HPBTableViewModel.getSectionModel([cellModel!])
        tableDelegater?.sectionModels = [sectionModel]
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.left)
    }
    
    
    fileprivate func tableViewConfig(){
        tableDelegater?.configureCell = {[weak self] tableViewBlockParam in
            guard let `self` = self else{return}
            let identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBShowMnemonicCell.self):
                let cell = tableViewBlockParam.cell as! HPBShowMnemonicCell
                cell.mnemonics = self.mnemonics
                
            case String(describing: HPBConfirmMnemoCell.self):
                 let cell = tableViewBlockParam.cell as! HPBConfirmMnemoCell
                  let mnemosArr = self.mnemonics?.components(separatedBy: " ")
                 cell.originalMnemos = mnemosArr ?? []
                 cell.confirmBlock = { [weak self] in
                    self?.checkOutMnemonics($0)
                }
            default:
                break
            }
        }
        
        tableDelegater?.cellHeight = {tableViewBlockParam in
            let  identifier = tableViewBlockParam.cellModel.identifier
            switch identifier{
            case String(describing: HPBShowMnemonicCell.self):
                return 400
            case String(describing: HPBConfirmMnemoCell.self):
                return 667
            default:
                return 0
            }
        }
    }
}

extension HPBMnemonicsController{
    
    /// 验证助记词的正确性
    fileprivate func checkOutMnemonics(_ mnemon: String){
        if mnemonics.noneNull == mnemon{
            HPBAlertView.showNomalAlert(in: self, message: "BackupMnemonics-Delete-tips".localizable){
                let updataMnemonicsResult = HPBWalletManager.updataWalletMnemonics(address: self.walletAddress.noneNull)
                if updataMnemonicsResult.state{
                     //发送通知，0.4秒后再pop出去，发现跨过HPBWalletHandelController崩溃的情况
                    NotificationCenter.default.post(name: Notification.Name.HPBBackupWalletSuccess, object: nil)
                     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
                        self.popTodestinationVC()
                    }
                }else{
                    showImage(text: "Mnemonics-Remove-Failed".localizable, statue: .faile, view: self.view)
                }
            }
        }else{
            HPBAlertView.showNomalAlert(in: self, message: "Mnemonics-Format-Error".localizable, onlyConfirm: true, complation: nil)
        }
    }
}
