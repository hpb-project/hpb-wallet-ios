//
//  HPBShakeAlertView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/6.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShakeAlertView: UIView {

    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var bottomBtn: UIButton!
    var successBlock: (()-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 8
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        bottomBtn.setTitle("News-RedPacke-Shake-Btn-Receive".localizable, for: .normal)
    }
    
    
    var state: HPBShakeManager.HPBShakeState = .faile{
        didSet{
             setCenterLabel()
            if state == .success{
                topImage.image = UIImage(named: "redpacket_shake_yes")
                bottomBtn.setTitle("News-RedPacke-Shake-Btn-Receive".localizable, for: .normal)
            }else{
               topImage.image = UIImage(named: "redpacket_shake_no")
                bottomBtn.setTitle("Common-Got-it".localizable, for: .normal)
            }
        }
    }
    
    
   private func setCenterLabel(){
        centerLabel.text = nil
        let normalColor = UIColor.init(withRGBValue: 0x54658B)
        switch state {
        case .success:
            let successStr = "News-RedPacke-Shake-Success".localizable
            let string1 =  NSMutableAttributedString(attributedString:NSAttributedString.placeHoderAttributedString(successStr, color: normalColor, fontScale: 14))
               centerLabel.attributedText = string1
        default:
             let faileStr = "News-RedPacke-Shake-Faile".localizable
             let string5 =  NSAttributedString.placeHoderAttributedString(faileStr.localizable, color: normalColor, fontScale: 14)
            centerLabel.attributedText = string5
        }
    }
    
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        //重新开启可以继续摇晃
        HPBShakeManager.share.shakeState = true
        self.removeFromSuperview()
    }
    
    
    
    @IBAction func bottomBtnClick(_ sender: UIButton) {
        self.removeFromSuperview()
        //重新开启可以继续摇晃
        HPBShakeManager.share.shakeState = true
        if  state == .success{
            successBlock?()
        }
            
        
    }
    
    
}
