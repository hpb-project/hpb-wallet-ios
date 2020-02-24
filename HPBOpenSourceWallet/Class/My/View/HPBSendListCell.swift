//
//  HPBSendListCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSendListCell: HPBBaseTableCell {

     static let cellModel = HPBCellModel(identifier: String(describing: HPBSendListCell.self), height: 65)
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel?
    @IBOutlet weak var rightImage: UIImageView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.init(withRGBValue: 0xFCFCFC)
         rightLabel?.text = "News-RedPacket-Luckiest".localizable
        self.separatorLineStyle = .space
    }
    
    var  model: HPBSendDetailModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            self.addressLabel.text = newValue.toAddr.cutOutAddress()
            self.timeLabel.text = newValue.showTime
            self.moneyLabel.text =  HPBStringUtil.converHpbMoneyFormat(newValue.coinValue,4).noneNull + "HPB"
            rightLabel?.isHidden = true
            rightImage?.isHidden = true
            if newValue.maxFlag == "1"{
               rightLabel?.isHidden = false
               rightImage?.isHidden = false
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
