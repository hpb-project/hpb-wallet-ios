//
//  HPBBarButton.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBBarButton: UIBarButtonItem {


    var clickBlock: (()-> Void)?
    
    init(title: String = "",image: UIImage? = nil,isHeadImage: Bool = false,textColor: UIColor = UIColor.white){
        super.init()
        let button = UIButton(type: .system)
        if isHeadImage{
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }

        button.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        if !title.isEmpty{
            button.setTitle(title.localizable, for: .normal)
        }else if image != nil{
            if isHeadImage{
                button.setBackgroundImage(image, for: .normal)
            }else{
                button.setImage(image, for: .normal)
            }
        }
        button.setTitleColor(textColor, for: .normal)
        button.addTarget(self, action: #selector(rightItemClicked), for: .touchUpInside)
        self.customView = button
    }
    
    
    @objc func rightItemClicked(){
        clickBlock?()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
