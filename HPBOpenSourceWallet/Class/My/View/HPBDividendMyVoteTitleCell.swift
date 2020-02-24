//
//  HPBDividendMyVoteTitleCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/18.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBDividendMyVoteTitleCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBDividendMyVoteTitleCell.self), height: 40)

    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var voteNumberLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var dividendLabel: UILabel!
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
        dividendLabel.text = "News-Dividend-FenHong-Precent".localizable
    }
    
  
    
}
