//
//  HPBTransferDetailRemarkCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTransferDetailRemarkCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBTransferDetailRemarkCell.self), height: 50)
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String = ""{
        willSet{
            contentLabel.text = newValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.paBackground
    }

   
    
}
