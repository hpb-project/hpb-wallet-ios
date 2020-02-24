//
//  HPBMainCreateCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/14.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMainCreateCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBMainCreateCell.self), height: 270)
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var bottomBtn: UIButton!
    var creatBlock: (()-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomBtn.layer.shadowColor = UIColor.black.cgColor
        bottomBtn.layer.shadowOffset = CGSize.zero
        bottomBtn.layer.shadowOpacity = 0.2
        bottomBtn.layer.shadowRadius = 10
        leftTitleLabel.text = "Main-No-Wallet-1".localizable
        bottomBtn.setTitle(" " + "Main-No-Wallet-2".localizable, for: .normal)
        self.contentView.backgroundColor =  UIColor.white
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
