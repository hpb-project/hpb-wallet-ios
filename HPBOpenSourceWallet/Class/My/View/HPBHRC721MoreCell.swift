//
//  HPBHRC721MoreCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/4.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721MoreCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBHRC721MoreCell.self), height: 66)

    @IBOutlet weak var idContentLabel: UILabel!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var idImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorLineStyle = .bottom
    }

    
    var model: HPB721StockModel?{
        willSet{
            guard let `newValue` = newValue else {return}
            idContentLabel.text = newValue.tokenId
            if let imageURL = URL(string: newValue.tokenURI){
                idImage.sd_setImage(with:imageURL, placeholderImage: UIImage.init(named: "common_head_placehoder"))
            }else{
                idImage.image = UIImage.init(named: "common_head_placehoder")
            }
           
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
