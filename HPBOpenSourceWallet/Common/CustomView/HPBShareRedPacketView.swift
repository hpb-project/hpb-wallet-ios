//
//  HPBShareRedPacketView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/14.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import Photos

class HPBShareRedPacketView: UIView {


    @IBOutlet weak var codeImage: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var closeBtnTop: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var bottomTipLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    override func awakeFromNib() {
         super.awakeFromNib()
        saveBtn.setTitle("News-RedPacket-Save-Image".localizable, for: .normal)
        bottomTipLabel.text = "News-RedPacket-Scan-open".localizable
        centerLabel.text = "News-RedPacket-Share".localizable
        closeBtnTop.constant = UIDevice.isIPHONE_X ? UIScreen.statusHeight : 10
       
    }
    
    var addressStr: String = ""{
        willSet{
          addressLabel.text = newValue.cutOutAddress()
        }
    }
    
    var webUrl: String = ""{
        willSet{
           codeImage.image = newValue.generatorQRCode(size: UIScreen.width)
        }
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        
        //保存图片到本地
        guard let shareImage = UIImage.getImageViewWithView(backView) else{return}
       HPBShareManager.shared.saveImage(shareImage)
        self.removeFromSuperview()
        
    }
    

    
    @IBAction func closeClick(_ sender: Any) {
        
         self.removeFromSuperview()
    }
    
    
  
    
    
    deinit {
        debugLog("HPBShareRedPacketView释放了")
    }
}
