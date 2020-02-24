//
//  HPBSwitchFooterView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/14.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSwitchFooterView: UIView {

   
    @IBOutlet weak var createWalletBackView: UIView!
    var createWalletBlock: (() -> Void)?
    @IBOutlet weak var creatLabel: UILabel!
    
    @IBOutlet weak var leftImage: UIImageView!
    var isHideView: Bool = false{
        willSet{
            creatLabel.isHidden = newValue
            leftImage.isHidden = newValue
            self.isUserInteractionEnabled = false
        }
    }
    
    override func awakeFromNib() {
        let createWalletTap = UITapGestureRecognizer(target: self, action: #selector(createWalletGesture))
        createWalletBackView.addGestureRecognizer(createWalletTap)
        self.backgroundColor = UIColor.paBackground
        createWalletBackView.layer.cornerRadius = 4
        createWalletBackView.layer.borderColor = UIColor.hpbBlueColor.cgColor
        createWalletBackView.layer.borderWidth = 1
        creatLabel.text = "Common-add-Wallet".localizable
    }
    
}


extension HPBSwitchFooterView{
    
    @objc func createWalletGesture(){
        createWalletBlock?()
    }
}

