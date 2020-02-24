//
//  HPBContractCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBContractCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: "HPBContractCell", height: 65,classType: HPBContractCell.self)
    
    var leftLabel: UILabel = {
        let label = HPBLabel(fontValue: 15, alignment: .left)
        return label
    }()
    var rightLabel: UILabel = {
        let label = HPBLabel(titleColor: UIColor.hpbPurpleColor, fontValue: 15, alignment: .right)
        return label
    }()
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        steupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    func steupView(){
        self.selectionStyle = .none
        self.separatorLineStyle = .doubleSpace
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.left.equalTo(leftLabel.snp.right).offset(10)
        }
        rightLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        rightLabel.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
    }
    
    func configData(_ title: String?,_ content: String?){
         self.leftLabel.text = title
         self.rightLabel.text = content
    }
 
}
