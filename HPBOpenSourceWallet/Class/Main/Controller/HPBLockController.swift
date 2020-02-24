//
//  HPBLockController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/14.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBLockController: HPBBaseController {

    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomImage: UIButton!
    var finish: (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bottomLabel.text = "Common-Lock-weakup".localizable
        if HPBLockManager.deviceSupport() == .faceID{
            self.bottomImage.setImage(UIImage(named: "common_lock_face"), for: .normal)
        }else{
            self.bottomImage.setImage(UIImage(named: "common_lock_finger"), for: .normal)
        }
    }
    
   
    
    @IBAction func clickToweakupClick(_ sender: UIButton) {
        self.toWeakup()
    }
    
    
    
    func toWeakup(){
        HPBLockManager.unlockApp(self,success: {
            DispatchQueue.main.async {
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
                self.finish?()
            }
        }) { (errorMsg) in
        }
    }
    
    
    
    
    
}
