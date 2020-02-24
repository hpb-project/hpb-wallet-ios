//
//  HPBTransferDetail721IDCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/4.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTransferDetail721IDCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBTransferDetail721IDCell.self), height: 47)

    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var idContentLabel: UILabel!
    @IBOutlet weak var idImage: UIImageView!
    @IBOutlet weak var morelabel: UILabel!
    
    
    var content: String?{
        willSet{
          idContentLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftTitleLabel.text = "Transfer-Token-ID".localizable
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
