//
//  HPBSinatureCodeImageView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/10/24.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSinatureCodeImageView: UIView {

    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var nextStepBtn: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    
    var nextStepBlock: (()->Void)?
    var codeStr: String?{
        willSet{
          codeImage.image = newValue.noneNull.generatorQRCode(size: 1500)
        }
    }
    
    
    var nextStepStr: String?{
        willSet{
           nextStepBtn.setTitle(newValue, for: .normal)
        }
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        bottomLabel.text = "Cold-Transfer-Code-Sync".localizable
        nextStepBtn.setTitle("Common-Next".localizable, for: .normal)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    @IBAction func closeClick(_ sender: Any) {
      dismiss()
    }
    
    func dismiss(){
        self.removeFromSuperview()
    }
    
    @IBAction func nextSteupClick(_ sender: Any) {
        nextStepBlock?()
        dismiss()
        
    }
    
}
