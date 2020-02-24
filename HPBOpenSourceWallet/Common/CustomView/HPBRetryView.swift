//
//  HPBRetryView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/20.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import SnapKit


class HPBRetryView: UIView {
    
    var retryBlock: (()-> Void)?
    var title: String?
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "main_cell_creat_back")
        imageView.contentMode = .scaleAspectFit
        return imageView //1:1
    }()
    
    var titleLabel: HPBLabel = {
        var label = HPBLabel(titleColor: UIColor.hpbPurpleColor, fontValue: 16)
        label.numberOfLines = 0
        return label
    }()
    
    var reteyBtn: HPBButton = {
       let btn =  HPBButton(type: .custom)
        btn.setTitle("Common-Reload".localizable, for: .normal)
        btn.layer.cornerRadius = 3
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.paNavigationColor
        return btn
    }()
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.paBackground
        configureView(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(_ title: String) {
        
        titleLabel.text = title
        
        let backView = UIView()
        backView.backgroundColor = UIColor.paBackground
        addSubview(backView)
        backView.addSubview(imageView)
        backView.addSubview(titleLabel)
        backView.addSubview(reteyBtn)
        reteyBtn.addClickEvent(){[weak self] in
           self?.retryBtnClick()
        }
        backView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(UIScreen.width)
            make.height.equalTo(280)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(102)
            make.width.equalTo(102)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(21)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        reteyBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.width.equalTo(150)
            make.height.equalTo(35)
        }
    }
    
    @objc func retryBtnClick(){
        retryBlock?()
    }
    
}



