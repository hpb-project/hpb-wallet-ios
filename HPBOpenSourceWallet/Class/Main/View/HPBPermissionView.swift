//
//  HPBPermissionView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPermissionView: UIView {

    var logoImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "common_lock_logo"))
    var centerLabel: UILabel = UILabel()
    var stepLabel: UILabel = UILabel()
    
    init() {
         super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
         steupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func steupView(){
        self.addSubview(logoImage)
        self.addSubview(centerLabel)
        self.addSubview(stepLabel)
        logoImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
            make.width.height.equalTo(100)
        }
        
        centerLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(60)
            make.top.equalTo(logoImage.snp.bottom).offset(20)
        }
        centerLabel.textAlignment = .center
        centerLabel.textColor = UIColor.paBlack
        centerLabel.numberOfLines = 0
        centerLabel.text = "Common-Photo-Auth".localizable
        
        stepLabel.snp.makeConstraints { (make) in
            make.top.equalTo(centerLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        stepLabel.numberOfLines = 0
        stepLabel.textColor = UIColor.paBlack
        stepLabel.text = "Common-Photo-Open".localizable
        
    }
    

}
