//
//  HPBSelectMnemonicCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/10.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSelectMnemonicCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBSelectMnemonicCell.self), height: 30)

    @IBOutlet weak var showLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var content: String = "" {
        willSet{
         self.showLabel.text = newValue
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
