//
//  HPBHRC721IDDetailCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/4.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721IDDetailCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBHRC721IDDetailCell.self), height: 78)

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    var model: HPBTransferRecord?{
        willSet{
            guard let `newValue` = newValue else{return}
            self.timeLabel.text = newValue.formatStr
            self.bottomLabel.text = newValue.fromAccount.cutOutAddress() + " To " + newValue.toAccount.cutOutAddress()
        }
    }

}
