//
//  HPBPagecontrolView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/5.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPagecontrolView: UIView {

    static let selectImageWidth = 26
    fileprivate var selectImageView = UIImageView(image: #imageLiteral(resourceName: "news_pagecontrol_select"))
    fileprivate var backImageView =  UIImageView(image: #imageLiteral(resourceName: "news_pagecontrol_back"))
    var  pageControlIndex: Int = 0{
        willSet{
            if newValue == 0{
                self.selectImageView.snp.updateConstraints { (make) in
                    make.left.equalToSuperview()
                }
            }else{
                UIView.animate(withDuration: 0.3) {
                    self.selectImageView.snp.updateConstraints { (make) in
                        make.left.equalToSuperview().offset(newValue * HPBPagecontrolView.selectImageWidth)
                    }
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(backImageView)
        self.addSubview(selectImageView)
        self.layer.masksToBounds  = true
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        selectImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(HPBPagecontrolView.selectImageWidth)
            make.left.equalToSuperview().offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
