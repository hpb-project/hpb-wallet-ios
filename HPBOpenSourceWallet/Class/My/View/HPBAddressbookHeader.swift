//
//  HPBAddressbookHeader.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/11.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBAddressbookHeader: UITableViewHeaderFooterView {

    
    fileprivate var topView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor.paBackground
        return topView
    }()
    
    fileprivate var titleLabel: UILabel = HPBLabel(titleColor: UIColor.init(withRGBValue:0x66688F),fontValue: 16, alignment: .left)
    var title: String?{
        willSet{
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.text = newValue
        }
    }
    let bottomView = UIView()
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        self.addSubview(topView)
        self.addSubview(titleLabel)
        self.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.paDividing
        titleLabel.backgroundColor = UIColor.white
        topView.snp.makeConstraints { (make) in
           make.left.top.right.equalToSuperview()
           make.height.equalTo(10)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
