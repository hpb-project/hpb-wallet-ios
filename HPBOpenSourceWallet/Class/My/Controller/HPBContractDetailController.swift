//
//  HPBContractDetailController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/18.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBContractDetailController: HPBBaseTableController {

    
    var model: HPBAddressBookRealmModel?
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var transferOutTitleLabel: UILabel!
    @IBOutlet weak var icouldImage: UIImageView!
    @IBOutlet weak var transferOutContentLabel: UILabel!
    @IBOutlet weak var nameContentLabel: UILabel!
    @IBOutlet weak var backupBtn: UIButton!
    @IBOutlet weak var icouldTipLabel: UILabel!
    
    var icouldState: Bool{
        return HPBiCouldManager.getiCouldState()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocation()
        configNavigationItem()
        self.nameContentLabel.text = model?.contractName
        self.transferOutContentLabel.text = model?.addressStr
    }

    fileprivate func configNavigationItem(){
        let imageName = UIImage(named: "my_addressbook_edit")
        let barButtonItem = HPBBarButton.init(image: imageName)
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedRightNavItem()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc fileprivate func  clickedRightNavItem(){
        let addressBookVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBAddNewContractController.self))
        (addressBookVC as? HPBAddNewContractController)?.handeType = .edit
        (addressBookVC as? HPBAddNewContractController)?.addBookmodel = model
        self.navigationController?.pushViewController(addressBookVC, animated: true)
    }
    
    
    
    func steupLocation(){
        self.title = "AddressBook-iCould-detail".localizable
        if icouldState{
           icouldTipLabel.text = "AddressBook-iCould-detail-tip".localizable
        }else{
           icouldTipLabel.text = "AddressBook-iCould-detail-close-Tip".localizable
        }
        backupBtn.isHidden = icouldState
        backupBtn.setTitle("AddressBook-iCould-Backup".localizable, for: .normal)
        transferOutTitleLabel.text = "AddressBook-iCould-detail-out".localizable
        nameTitleLabel.text = "AddressBook-iCould-detail-name".localizable
    }
    
    
    @IBAction func copyBtnClick(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = HPBStringUtil.noneNull(model?.addressStr)
        showBriefMessage(message: "Common-Copy-Success".localizable, view: self.view)
    }
    
    
    @IBAction func backupClick(_ sender: UIButton) {
     let   icouldVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBiCouldController.self))
        (icouldVC as? HPBiCouldController)?.sourceType = .detail
        self.navigationController?.pushViewController(icouldVC, animated: true)
        
    }
    
    

}
