//
//  HPBTipProtectView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/25.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTipProtectView: UIViewController {

    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var screenshot: UILabel!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var confirmBlock: (()->Void)?
    var content: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        contentView.layer.cornerRadius = 5
        steupLocalizable()
        showAnimation()
    }
    
    private func steupLocalizable(){
        tipsLabel.text = content
        screenshot.text = "Common-No-Screenshot".localizable
        finishBtn.setTitle("Common-Got-it".localizable, for: .normal)
    }

    @IBAction func confirmClick(_ sender: UIButton) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        confirmBlock?()
    }
   
    private func showAnimation(){
        let keyFrameAnimation = CAKeyframeAnimation(keyPath:  "transform.scale")
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
