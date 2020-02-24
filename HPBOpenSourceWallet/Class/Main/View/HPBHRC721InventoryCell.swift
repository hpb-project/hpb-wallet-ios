//
//  HPBHRC721InventoryCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721InventoryCell: UICollectionViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var transferTimeTitleLabel: UILabel!
    @IBOutlet weak var transferNumberLabel: UILabel!
    @IBOutlet weak var tokenIdTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transferTimeTitleLabel.text =  "Transfer-Transfer-Times".localizable
        tokenIdTitle.text = "Transfer-Token-ID".localizable
        self.layer.cornerRadius = 8
    }
    
    var model: HPB721StockModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            transferNumberLabel.text = "\(newValue.count)"
            nameLabel.text = newValue.tokenId
            if let imageURL = URL(string: newValue.tokenURI){
                logoImage.sd_setImage(with:imageURL, placeholderImage: UIImage.init(named: "common_head_placehoder"))
            }else{
                logoImage.image = UIImage.init(named: "common_head_placehoder")
            }
            
        }
        
        
    }

}
