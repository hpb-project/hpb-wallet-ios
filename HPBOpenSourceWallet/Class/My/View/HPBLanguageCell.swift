//
//  HPBLanguageCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/10.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBLanguageCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBLanguageCell.self), height: 66,classType:HPBLanguageCell.self)
    
    lazy var leftTitle: UILabel = {
        return HPBLabel(titleColor: UIColor.paNavigationColor,fontValue: 15, alignment: .left)
    }()
    
    lazy var selectImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "my_language_selected"))
        return image
    }()
    
    var title: String?{
        willSet{
            leftTitle.text = newValue
        }
    }
    
    var isSelect: Bool = false{
        willSet{
            selectImage.isHidden = !newValue
            leftTitle.textColor =  newValue ? UIColor.paNavigationColor : UIColor.hpbPurpleColor
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        steupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        steupViews()
    }
    
    fileprivate func steupViews(){
        self.addSubview(leftTitle)
        self.addSubview(selectImage)
        leftTitle.adjustsFontSizeToFitWidth = true
        leftTitle.minimumScaleFactor = 0.5
        leftTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-45)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        selectImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(14)
            make.height.equalTo(11)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
