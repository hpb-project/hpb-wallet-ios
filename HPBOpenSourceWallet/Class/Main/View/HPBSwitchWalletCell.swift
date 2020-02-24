//
//  HPBSwitchWalletCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/14.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSwitchWalletCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBSwitchWalletCell.self), height: 66)

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletImage: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var coldwalletLabel: UILabel!
    
    var isColdWallet: Bool = false{
        willSet{
          coldwalletLabel.isHidden = !newValue
        }
    }
    
    var name: String?{
        willSet{
            walletNameLabel.text = newValue
        }
    }
    var headImageName: String?{
        willSet{
            walletImage.image =  UIImage(contentsOfFile:HPBFileManager.getHeadImageDirectory() + newValue.noneNull)
        }
    }
    var balance: String?{
        willSet{
            if newValue.noneNull == "Hidden"{
                balanceLabel.text = HPBAPPConfig.hiddenAssertStr
            }else{
                balanceLabel.text = newValue
            }
        }
    }
    
    var addressStr: String?{
        willSet{
            
            self.addressLabel.text = newValue?.cutOutAddress()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorLineStyle = .none
        coldwalletLabel.text = "Common-ColdWallet-Btn-Title".localizable
        self.selectedBackgroundView?.backgroundColor = UIColor(withRGBValue: 0xF6F7FD,alpha: 0.8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        coldwalletLabel.backgroundColor = UIColor.init(withRGBValue: 0x91A6EF, alpha: 1)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        coldwalletLabel.backgroundColor = UIColor.init(withRGBValue: 0x91A6EF, alpha: 1)
    }
    
}
