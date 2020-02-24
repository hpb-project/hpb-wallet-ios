//
//  HPBRPSendDetailCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRPSendDetailCell: UITableViewCell {

     static let cellModel = HPBCellModel(identifier: String(describing: HPBRPSendDetailCell.self), height: UIScreen.scaleFontIphone6(147))
    
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    var model: HPBSendDetailLists?{
        willSet{
            guard let `newValue` = newValue else {return}
            var locationStr = newValue.fromAddr.cutOutAddress() + "的HPB红包"
            if HPBLanguageUtil.share.language == .english{
                locationStr = "Red Packet from " + newValue.fromAddr.cutOutAddress()
            }
            self.topTitleLabel.text = locationStr
            var typeImageName = ""
            if newValue.type == "1"{
                typeImageName = "redpacket_white_pu"
            }else{
                typeImageName = "redpacket_white_pin"
            }
            if HPBLanguageUtil.share.language == .english{
                typeImageName.append("_en")
            }
            typeImage.image = UIImage(named: typeImageName)
            self.tipLabel.text = newValue.title
           self.moneyLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.totalCoin, 2).noneNull
            
        }
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
