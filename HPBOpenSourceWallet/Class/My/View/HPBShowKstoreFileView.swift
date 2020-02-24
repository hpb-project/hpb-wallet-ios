//
//  HPBShowKstoreFileView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShowKstoreFileView: UIView {

    //国际化配置
    @IBOutlet weak var titleTopLabel: UILabel!
    @IBOutlet weak var titleCenterLabel: UILabel!
    @IBOutlet weak var titleBottomLabel: UILabel!
    @IBOutlet weak var topContentLabel: UILabel!
    @IBOutlet weak var centerContentLabel: UILabel!
    @IBOutlet weak var bottomContentLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    
    
    @IBOutlet weak var textView: UITextView!
    
    var kstoreStr: String? = "" {
        willSet{
            textView.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        steupLocalizable()
    }
    
 
    fileprivate func steupLocalizable(){
        titleTopLabel.text = "xuy-Jd-cOI.text".localizable
        titleCenterLabel.text = "izc-7f-1Ok.text".localizable
        titleBottomLabel.text = "6hC-og-8dL.text".localizable
        topContentLabel.text = "Byn-aB-mmj.text".localizable
        centerContentLabel.text = "V8h-Lb-Ynk.text".localizable
        bottomContentLabel.text = "Fm1-tC-Aar.text".localizable
        copyBtn.setTitle("Uy0-pw-vtr.normalTitle".localizable, for: .normal)
    }
    
    
    @IBAction func copyKstoreClick(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = textView.text;
        
        sender.setTitle("Common-Copyed".localizable, for: .normal)
        sender.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            sender.isUserInteractionEnabled = true
            sender.setTitle("Uy0-pw-vtr.normalTitle".localizable, for: .normal)
        }
        
        showBriefMessage(message: "Common-Copy-Success".localizable, view: self)
        
    }
    
    
    
}
