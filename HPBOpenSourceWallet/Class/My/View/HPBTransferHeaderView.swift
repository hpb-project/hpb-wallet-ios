//
//  HPBTransferHeaderView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/13.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTransferHeaderView: UITableViewHeaderFooterView {

    var titleLabel: UILabel = HPBLabel(titleColor: UIColor.paNavigationColor,fontValue: 16, alignment: .left)
    var leftImage = UIImageView(image: #imageLiteral(resourceName: "my_transfer_header"))
    var titile: String?{
        willSet{
            titleLabel.text = newValue
        }
    }
    let backView = UIView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backView.backgroundColor = UIColor.hpbCellSelectColor
        self.addSubview(backView)
        self.addSubview(leftImage)
        self.addSubview(titleLabel)
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        leftImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.width.equalTo(8)
            make.height.equalTo(11)
            make.centerY.equalToSuperview()
        }
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImage.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
