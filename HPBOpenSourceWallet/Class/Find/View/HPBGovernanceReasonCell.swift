//
//  HPBGovernanceReasonCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/9.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceReasonCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBGovernanceReasonCell.self), height: 0)

    @IBOutlet weak var tiitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tiitleLabel.text = "News-Governance-Proposal-Invalid-Reason".localizable
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 8
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowOpacity = 0.1
        backView.layer.shadowRadius = 10
    }

    var content: String = ""{
        willSet{
            contentLabel.text = newValue
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
