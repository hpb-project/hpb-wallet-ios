//
//  HPBShowKstoreCodeView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import LBXScan
class HPBShowKstoreCodeView: UIView {

    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var showcodeBtn: UIButton!
    
    @IBOutlet weak var waringImageView: UIImageView!
    @IBOutlet weak var waringLabel: UILabel!
    //国际化配置

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var topContentLabel: UILabel!
    @IBOutlet weak var bottomContentLabel: UILabel!
    
    
    lazy var qrImage: UIImage? = {
        return self.kstoreStr?.generatorQRCode(size: 1200)
    }()
    var kstoreStr: String? = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        qrcodeImage.isHidden = true
        steupLocalizable()
       
    }
    
    
    fileprivate func  steupLocalizable(){
        
        topTitleLabel.text = "4kj-t9-zyn.text".localizable
        bottomTitleLabel.text = "xIZ-x4-IBr.text".localizable
        bottomContentLabel.text = "06I-z8-Gpk.text".localizable
        topContentLabel.text = "3jc-ry-X1s.text".localizable
        showcodeBtn.setTitle("ShowKstore-Show".localizable, for: .normal)
        waringLabel.text = "Common-NO-Camera".localizable
    }
    
    @IBAction func showCodeBtnClick(_ sender: UIButton) {
       let titile =  HPBStringUtil.noneNull(sender.titleLabel?.text)
        if titile == "ShowKstore-Hide".localizable{
            self.waringLabel.isHidden = false
             self.waringImageView.isHidden = false
             qrcodeImage.isHidden = true
            sender.setTitle("ShowKstore-Show".localizable, for: .normal)
        }else{
            self.waringLabel.isHidden = true
            self.waringImageView.isHidden = true
            qrcodeImage.isHidden = false
            qrcodeImage.image = self.qrImage
           sender.setTitle("ShowKstore-Hide".localizable, for: .normal)
        }
        
        
        
    }
    

}
