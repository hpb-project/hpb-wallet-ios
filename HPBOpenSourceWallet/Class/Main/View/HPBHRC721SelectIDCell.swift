//
//  HPBHRC721SelectIDCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/6.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721SelectIDCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBHRC721SelectIDCell.self), height: 66)
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    var confirmBlock: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var indexStr: String?{
        willSet{
          indexLabel.text = newValue
        }
    }
    var select: Bool = false{
        willSet{
            leftButton.isSelected = newValue
        }
    }
    var model: HPB721StockModel?{
        willSet{
            guard let `newValue` = newValue else {
                return
            }
          idLabel.text = newValue.tokenId
          self.logoImage.sd_setImage(with: URL(string: newValue.tokenURI), placeholderImage:UIImage(named: "common_head_placehoder"))
            
        }
    }
    
    
    
    
    
    @IBAction func selectBtnCLick(_ sender: UIButton) {
        sender.isSelected =  !sender.isSelected
        if sender.isSelected{
            self.confirmBlock?()
        }
        
    }
    
}
