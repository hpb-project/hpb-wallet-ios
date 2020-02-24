//
//  HPBEmptyView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/26.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBEmptyView: UIView {
    
    var title: String?
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView//1:1
    }()
    
    
    init() {
        super.init(frame: CGRect.zero)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(imageView)
        if HPBLanguageUtil.share.language == .chinese{
            imageView.image  = UIImage.init(named: "common_list_empty_cn")
        }else{
            imageView.image  = UIImage.init(named: "common_list_empty_en")
        }
        imageView.snp.makeConstraints { (make) in
           make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
}
