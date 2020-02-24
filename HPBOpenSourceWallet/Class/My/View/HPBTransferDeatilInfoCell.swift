//
//  HPBTransferDeatilInfoCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTransferDeatilInfoCell: HPBBaseTableCell {

     static let cellModel = HPBCellModel(identifier: String(describing: HPBTransferDeatilInfoCell.self))
    var copyBlock: ((String)->Void)?
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trailConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImage: UIImageView!
    func configData(title: String?,content: String?){
        self.titleLabel.text = title
        self.contentLabel.text = content
    }
    
    var isSpecial: Bool = false {
        willSet{
            self.rightImage.isHidden = !newValue
            self.trailConstraint.constant = newValue ? 43 : 22
        }
    }
    
    
    @IBAction func copyBtnClick(_ sender: UIButton) {
        self.copyBlock?(self.contentLabel.text.noneNull)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
