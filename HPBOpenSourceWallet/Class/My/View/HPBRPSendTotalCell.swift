//
//  HPBRPSendTotalCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRPSendTotalCell: UITableViewCell {

      static let cellModel = HPBCellModel(identifier: String(describing: HPBRPSendTotalCell.self), height: 45)
    
    @IBOutlet weak var tipLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
         self.contentView.backgroundColor = UIColor.init(withRGBValue: 0xFCFCFC)
    }
    
    var model: HPBSendDetailLists?{
        willSet{
            guard let `newValue` = newValue else {return}
            let coinStr = HPBStringUtil.converHpbMoneyFormat(newValue.totalCoin, 2).noneNull
            var stateStr = "News-RedPacket-Received".localizable
            switch newValue.redPacketSendStatus {
            case .success:
                let isAllReceive =  newValue.usedNum ==   newValue.totalNum
                if isAllReceive{
                    stateStr = "News-RedPacket-State-Receive-Over".localizable
                }else{
                    switch newValue.redpacketOver{
                    case .ongoing:
                        stateStr = "News-RedPacket-Received".localizable
                    case .end:
                        stateStr = "News-RedPacket-State-Expired".localizable
                    default:()
                    }
                }
            case .confirm:
                stateStr = "News-RedPacket-State-Conforming".localizable
            default:()
            }
            var totalMoneyLocation = "共\(coinStr)HPB"
            if HPBLanguageUtil.share.language == .english{
                totalMoneyLocation = "\(coinStr)HPB in Total"
            }
            var extralStr = ""
            if HPBLanguageUtil.share.language == .english{
                extralStr = " "
            }
            tipLabel.text =  stateStr +  extralStr + "\(newValue.usedNum)/\(newValue.totalNum),\(totalMoneyLocation)"
            
        }
    }
    
    var title: String = ""{
        willSet{
          tipLabel.text = newValue
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
