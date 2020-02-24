//
//  HPBRedPacketReceiveCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRedPacketReceiveCell: HPBBaseTableCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var receiveStateLabel: UILabel!
    
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBRedPacketReceiveCell.self), height: 70)

    
    var model: HPBRedPacketReceiveModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            moneyLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.coinValue, 4).noneNull + "HPB"
            timelabel.text =  newValue.showTime
            typeLabel.text =  newValue.redPacketType
            fromAddressLabel.text = newValue.fromAddr.cutOutAddress()
            receiveStateLabel.text = newValue.showStatus
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorLineStyle = .bottom
    }

  
}
