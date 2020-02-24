//
//  HPBMainAddCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/2.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMainAddCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBMainAddCell.self), height: 46)
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    var addBlock: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        leftLabel.text = "Main-Asset-List".localizable
        self.backgroundColor = UIColor.white
    }
    @IBAction func addbtnClick(_ sender: UIButton) {
        addBlock?()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
