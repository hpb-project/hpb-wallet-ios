//
//  HPBNewsCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/7.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import SDWebImage

class HPBNewsCell: HPBBaseTableCell {

    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBNewsCell.self), height: 102)
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var readNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.white
        separatorLineStyle = .none
        rightImage.layer.cornerRadius = 4
        
    }
    
    func configData(_ content: String,time: String,imageName: String?,readNumber: String){
        self.contentLabel.text = content
        self.timeLabel.text = time
        if !imageName.noneNull.isEmpty{
            rightImage.isHidden = false
            rightImage.sd_setImage(with: URL(string: imageName.noneNull), placeholderImage: #imageLiteral(resourceName: "bannerPlaceholder"))
        }else{
            rightImage.isHidden = true
        }
        readNumberLabel.text = readNumber + "News-Reads".localizable
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
