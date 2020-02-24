//
//  HPBTipBackUpView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/18.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTipBackUpView: UIViewController {

    var backupBlock: (()->Void)?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var confirmBtn: HPBSelectImgeButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 5
        steupLocalizable()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
        showAnimation()
    }
    
     private func steupLocalizable(){
        titleLabel.text = "Mnemonics-Tip-Backup".localizable
        centerLabel.text = "TipBackUpView-tips".localizable
        topLabel.text = "Mnemonics-Backup-mnemonic".localizable
        bottomLabel.text = "Mnemonics-Backup-keystore-Tip".localizable
        confirmBtn.setTitle("Mnemonics-Backup-Now".localizable, for: .normal)
    }
    
    private func showAnimation(){
        let keyFrameAnimation = CAKeyframeAnimation(keyPath:  "transform.scale")
        keyFrameAnimation.values = [
            0.7,1.1,1
        ]
        keyFrameAnimation.repeatCount = 1
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.duration = 0.5
        contentView.layer.add(keyFrameAnimation, forKey: "keyFrameAnimation")
        
    }
    
    @objc func tapDismiss(){
        view.removeFromSuperview()
        removeFromParentViewController()
    }

    
    @IBAction func backupBtnClick(_ sender: UIButton) {
        self.tapDismiss()
        backupBlock?()
    }
    
}


extension HPBTipBackUpView: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point =  touch.location(in: view)
        if self.contentView.frame.contains(point){
            return false
        }
        return true
    }
    
}
