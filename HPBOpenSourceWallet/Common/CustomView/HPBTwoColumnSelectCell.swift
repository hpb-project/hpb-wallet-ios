//
//  HPBTwoColumnSelectCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTwoColumnSelectCell: UITableViewCell {
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBTwoColumnSelectCell.self), height: 52)

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var content: String?{
        willSet{
          contentLabel.text = newValue
        }
    }
    
    var leftSelectCell: Bool = false{
        willSet{
            if newValue == true{
                self.contentView.backgroundColor = UIColor.white
                self.contentLabel.textColor = UIColor.init(withRGBValue: 0x54658B)
            }else{
                self.contentView.backgroundColor = UIColor.init(withRGBValue: 0xF5F6F8)
                self.contentLabel.textColor = UIColor.init(withRGBValue: 0x333333)
            }
        }
    }
    
    var rightSelectCell: Bool = false{
        willSet{
            self.contentView.backgroundColor = UIColor.white
            if newValue == true{
                
                self.contentLabel.textColor = UIColor.init(withRGBValue: 0x54658B)
            }else{
                self.contentLabel.textColor = UIColor.init(withRGBValue: 0x333333)
            }
        }
    }
    
    
    
}
