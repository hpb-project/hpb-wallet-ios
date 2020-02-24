//
//  HPBMyVoteTitleCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/8/7.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMyVoteTitleCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBMyVoteTitleCell.self), height: 40)
    
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var voteNumberLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    var backColor: UIColor = .clear{
        didSet {
            self.contentView.backgroundColor = backColor
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorLineStyle = .doubleSpace
        rankLabel.text = "Vote-Rank-Title".localizable
        nameLabel.text = "Vote-Name-Title".localizable
        voteNumberLabel.text = "Vote-Number-Title".localizable
        voteLabel.text = "Vote-Vote-Title".localizable
    }

   
    
}
