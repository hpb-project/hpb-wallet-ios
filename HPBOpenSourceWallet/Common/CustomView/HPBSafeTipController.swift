//
//  HPBSafeTipController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/9/25.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSafeTipController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topLabelTwo: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var noTipBtn: UIButton!
     var finishBlock: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 5
        steupLocalizable()
        showAnimation()
    }
    
    
    private func steupLocalizable(){
        self.topLabel.text = "Common-Safe-Top-1".localizable
        self.topLabelTwo.text = "Common-Safe-Top-2".localizable
        self.confirmBtn.setTitle("Common-Safe-Confirm".localizable, for: .normal)
        self.noTipBtn.setTitle("Common-Safe-No-Tip".localizable, for: .normal)
        self.centerLabel.text = "Common-Safe-Center".localizable
        self.confirmBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.confirmBtn.titleLabel?.minimumScaleFactor = 0.5
        self.noTipBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.noTipBtn.titleLabel?.minimumScaleFactor = 0.5
        

        
    }
    
    
    @IBAction func confirmClick(_ sender: UIButton) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        finishBlock?()
        
    }
    
    @IBAction func noTipClick(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: HPBUserDefaultsKey.showSafeAlertKey)
        UserDefaults.standard.synchronize()
        confirmClick(confirmBtn)
       
    }
    
    private func showAnimation(){
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrameAnimation.values = [
            0.7,1.2,1
        ]
        keyFrameAnimation.repeatCount = 1
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.duration = 0.5
        contentView.layer.add(keyFrameAnimation, forKey: "keyFrameAnimation")
    }
    
    deinit {
        debugLog("释放了")
    }

}
