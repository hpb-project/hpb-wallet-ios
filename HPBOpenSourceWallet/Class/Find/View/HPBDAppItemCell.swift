//
//  HPBDAppItemCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/25.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit
import SDWebImage

class HPBDAppItemCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImage.layer.cornerRadius = 8
        itemImage.clipsToBounds = true
    }
    
    func config(name: String,imageUrl: String){
         itemLabel.text = name
         itemImage?.sd_setImage(with: URL(string:imageUrl), placeholderImage: #imageLiteral(resourceName: "bannerPlaceholder"))
    }

}
