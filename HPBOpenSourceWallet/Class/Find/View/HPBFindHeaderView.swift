//
//  HPBFindHeaderView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/20.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBFindHeaderView: UITableViewHeaderFooterView {

    var titleLabel: UILabel = HPBLabel(titleColor: UIColor.paNavigationColor,fontValue: 16, alignment: .left)
    var titile: String?{
        willSet{
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.text = newValue
        }
    }
    let bottomView = UIView()
    var isHaveBottomView: Bool = false
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        if isHaveBottomView{
            self.addSubview(bottomView)
            bottomView.backgroundColor = UIColor.paDividing
            bottomView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(1)
                make.bottom.equalToSuperview()
            }
        }
        self.addSubview(titleLabel)
        self.contentView.backgroundColor = UIColor.white
       
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
