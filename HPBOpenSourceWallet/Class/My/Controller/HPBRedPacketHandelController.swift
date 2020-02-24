//
//  HPBRedPacketHandelController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/14.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRedPacketHandelController: HPBBaseTableController {

    @IBOutlet weak var leftTitlelabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    var redPacketState: Bool{ //是否开启(默认是开启)
        if let state = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.redpacketBtnKey) as? Bool{
            return state
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Floating-Action-Button-Open".localizable
        switchBtn.isOn = redPacketState
        leftTitlelabel.text = "Floating-Action-Button-Open".localizable
    }
    
    
    @IBAction func switchChange(_ sender: UISwitch) {
        
        if sender.isOn == true{
            setRedPacketStateState(true)
        }else{
            setRedPacketStateState(false)
        }
         NotificationCenter.default.post(name: Notification.Name.HPBShowRedPacketButton, object: nil)
    }
    
}

extension HPBRedPacketHandelController{
    
     func setRedPacketStateState(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: HPBUserDefaultsKey.redpacketBtnKey)
        UserDefaults.standard.synchronize()
    }
    
    
}
