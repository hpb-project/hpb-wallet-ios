//
//  HPBMessageCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMessageCell: HPBBaseTableCell {

    //删除配置关闭
    static let cellModel = HPBCellModel(identifier: String(describing: HPBMessageCell.self),canEdit: false)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var redView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.paBackground
        self.separatorLineStyle = .doubleSpace
        self.redView.layer.cornerRadius = 4
    }

    
    func configData(_ title: String?,content: String?,time: String?,isHiddenRed: Bool){
        self.titleLabel.text = title
        self.contentLabel.text = content
        self.timeLabel.text = time
        self.redView.isHidden = isHiddenRed
    }
   
    
}
