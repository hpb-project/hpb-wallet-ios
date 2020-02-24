//
//  HPBShareReceiptView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/16.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShareReceiptView: UIView {
    
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var centerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topTitle.text = "Receipt-QrCode-Tip".localizable
        centerView.layer.cornerRadius = 4
        
    }

}
