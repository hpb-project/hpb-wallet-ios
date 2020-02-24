//
//  HPBSystemSetingController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/13.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSystemSetingController: HPBBaseTableController {
    
    enum JumpType: Int{
        case language = 0
        case numberStyle = 1
        case secureLogin = 2
        case redPackethHandel = 3
        case moneyHandel = 4
    }
    
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var numberTypeLabel: UILabel!
    @IBOutlet weak var secureLoginLabel: UILabel!
    @IBOutlet weak var redPacketLabel: UILabel!
    @IBOutlet weak var moneyTitleLabel: UILabel!
    
    @IBOutlet weak var languageContentLabel: UILabel!
    @IBOutlet weak var numberContentLabel: UILabel!
    @IBOutlet weak var secureContentLabel: UILabel!
    @IBOutlet weak var redPacketContentLabel: UILabel!
    @IBOutlet weak var moneyContentLabel: UILabel!
    
    
    var redPacketState: Bool{ //是否开启(默认是开启)
        if let state = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.redpacketBtnKey) as? Bool{
            return state
        }
        return true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My-Settings".localizable
        languageLabel.text = "LanguageUtil-Title".localizable
        numberTypeLabel.text = "NumberStyle-Style".localizable
        secureLoginLabel.text = "SecureLogin-Title".localizable
        redPacketLabel.text = "Floating-Action-Button-Open".localizable
        moneyTitleLabel.text = "My-Currency-Change".localizable
        languageContentLabel.text = HPBLanguageUtil.share.language.name.localizable
        numberContentLabel.text = HPBNumberStyleUtil.share.style.example
        otherBtnControl()
        
    }

    
    fileprivate func otherBtnControl(){
        
        if HPBLockManager.shared.secureLoginState{
            self.secureContentLabel.text = "Common-Open-Right".localizable
        }else{
            self.secureContentLabel.text = "Common-Close-Right".localizable
        }
        redPacketLabel.text = "Floating-Action-Button-Open".localizable
        if redPacketState{
            self.redPacketContentLabel.text = "Common-Open-Right".localizable
        }else{
            self.redPacketContentLabel.text = "Common-Close-Right".localizable
            
        }
         self.moneyContentLabel.text = HPBMoneyStyleUtil.share.style.name.localizable
    }
        



override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
    otherBtnControl()
}

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: true)
    if let type = JumpType(rawValue: indexPath.row){
        switch type{
            
        case .language:
            let languaVC = HPBLanguageController()
            self.navigationController?.pushViewController(languaVC, animated: true)
            
        case .numberStyle:
            let languaVC = HPBNumberStyleController()
            self.navigationController?.pushViewController(languaVC, animated: true)
        case .moneyHandel:
            let currencySettingVC = HPBCurrencySettingController()
            self.navigationController?.pushViewController(currencySettingVC, animated: true)
        default:
            break
        }
    }
}

}


