//
//  HPBRedPacketSendCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRedPacketSendCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBRedPacketSendCell.self), height: 70)

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var redPacketTypeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    
    var model: HPBRedPacketSendModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            moneyLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.totalCoin, 2).noneNull + newValue.coinSymbol
            timeLabel.text =  newValue.showTime
            redPacketTypeLabel.text = newValue.redPacketType
            stateLabel.textColor = UIColor.hpbPurpleColor
            var stateStr: String?
            switch newValue.redpacketState {
            case .confim:          //确认中
                stateStr = "News-RedPacket-State-Conforming".localizable
            case .success:         //发送成功
                if newValue.usedNum == newValue.totalNum{ //已领完
                    stateStr = "News-RedPacket-State-Receive-Over".localizable
                }else{
                    switch newValue.redpacketOver{
                    case .ongoing:
                        stateStr = "News-RedPacket-State-Ongoing".localizable //进行中
                        stateLabel.textColor = UIColor.init(withRGBValue: 0x4A5FE2)
                    case .end:
                        stateStr = "News-RedPacket-State-Expired".localizable  //已结束
                    default:()
                    }
                }
            default:()
            }
            
            stateLabel.text = stateStr.noneNull +  " \(newValue.usedNum)/\(newValue.totalNum)"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorLineStyle = .space
    }

  
}
