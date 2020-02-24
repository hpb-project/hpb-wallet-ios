//
//  HPBTransferDetailBottomCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import LBXScan

class HPBTransferDetailBottomCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBTransferDetailBottomCell.self), height: 200)
    
    struct InfoModel{
        var blockNumberStr: String?
        var transferFeeStr: String?
        var transferTimeStr: String?
        var isTransfer: Bool = true
    }

    @IBOutlet weak var blockNo: UILabel!
    @IBOutlet weak var transferFee: UILabel!
    @IBOutlet weak var transferTime: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    //本地化配置
    @IBOutlet weak var transferFeeLabel: UILabel!
    @IBOutlet weak var blockNoTipLabel: UILabel!
    @IBOutlet weak var transferTimeTipLabel: UILabel!
    
    var isMainNet: Bool = true{
        willSet{
            if newValue == false{
               topConstraint.constant = 0
               transferFeeLabel.text = ""
               transferFee.text = ""
            }
        }
    }
    
    var model: InfoModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            blockNo.text = newValue.blockNumberStr
            transferFee.text = newValue.transferFeeStr
            transferTime.text = newValue.transferTimeStr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        steupLocalizable()
    }
    
    private func steupLocalizable(){
        transferFeeLabel.text = "TransferDetail-Fees".localizable
        blockNoTipLabel.text = "TransferDetail-Block".localizable
        transferTimeTipLabel.text = "TransferDetail-Time".localizable
    }
 
}
