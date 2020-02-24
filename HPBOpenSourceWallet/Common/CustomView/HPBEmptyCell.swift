//
//  HPBEmptyCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/7.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBEmptyCell: HPBBaseTableCell {

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initOtherData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initOtherData()
    }
    
    private func initOtherData(){
        
        self.contentView.backgroundColor = UIColor.paBackground
        self.selectionStyle = .none
        
    }
    
    
    static func cellModel(_ height: CGFloat = 10) -> HPBCellModel{
        return HPBCellModel(identifier: "HPBEmptyCell", height: height, classType: HPBEmptyCell.self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


