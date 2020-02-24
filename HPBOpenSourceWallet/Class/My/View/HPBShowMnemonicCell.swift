//
//  HPBShowMnemonicCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/11.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShowMnemonicCell: HPBBaseTableCell {
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBShowMnemonicCell.self))

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipContentLabel: UILabel!
    @IBOutlet var showLabelArr: [UILabel]!
     let showLabelFirstTag   = 201
    
    /// 助记词赋值
    var mnemonics: String? = ""{
        willSet{
            guard let `newValue` = newValue else{return}
            let mnemosArr = newValue.components(separatedBy: " ")
            if mnemosArr.count == 12{    //为保持正确性更高，判断是否能生成12个单词的助记词字符串
                for index in 0..<12{
                    if let label = self.viewWithTag(showLabelFirstTag+index) as? UILabel{
                        label.text = mnemosArr[index]
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.paBackground
        self.separatorLineStyle = .none
        titleLabel.text = "qge-X7-fsh.text".MainLocalizable
        tipContentLabel.text = "xcA-N4-R4C.text".MainLocalizable
    }

  
}


