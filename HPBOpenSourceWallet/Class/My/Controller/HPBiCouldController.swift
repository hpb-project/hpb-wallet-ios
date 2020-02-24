//
//  HPBiCouldController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/18.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBiCouldController: HPBBaseTableController {
    
    enum HPBSourceType{
        case normal,detail
    }
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!

    var sourceType: HPBSourceType = .normal
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var icouldState: Bool{
        return HPBiCouldManager.getiCouldState()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AddressBook-iCould-backup".localizable
        leftLabel.text = "AddressBook-iCould-backup".localizable
        tipLabel.text = "AddressBook-iCould-tip".localizable
        switchBtn.isOn = icouldState
        configNavigationItem()
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
        if sourceType == .normal{
            self.navigationController?.popViewController(animated: true)
        }else{
            guard let nav = self.navigationController else{return}
            nav.interactivePopGestureRecognizer?.isEnabled = false
            if nav.viewControllers.count > 1{    //返回列表页
                if ((nav.viewControllers[1] as? HPBAddressBookController) != nil){
                    nav.popToViewController(nav.viewControllers[1], animated: true)
                }
            }
        }
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        if sender.isOn{
            showHudText(view: self.view)
            HPBAddressBookManager.downloadiCouldList(success: { (models) in
                //hideHUD(view: self.view)
                //合并云端数据和本地数据，然后再push到远端
                HPBAddressBookManager.mergeLocalAndCould(clouldModels: models)
                //推送本地数据到远程
                HPBAddressBookManager.pushLocalListToCould(success: {
                    HPBiCouldManager.saveiCouldState(true)
                    showBriefMessage(message: "AddressBook-iCould-Success-Tip".localizable,view: self.view)
                }, failure: { (errorMsg) in
                    sender.isOn = false
                    showBriefMessage(message: "AddressBook-iCould-Faile-Tip".localizable,view: self.view)
                })
            }) { (errorMsg) in
                sender.isOn = false
                showBriefMessage(message: "AddressBook-iCould-Faile-Tip".localizable,view: self.view)
            }
        }else{
            HPBiCouldManager.saveiCouldState(false)
        }
    }
    
}
