//
//  HPBEmptyViewProtocol.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/26.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit


protocol HPBEmptyViewProtocol: class {
    var emptyView: HPBEmptyView? {get set}
}

extension HPBEmptyViewProtocol {
    func isHiddenEmptyView(_ isHidden:Bool,topView:UIView, marginCenter: CGFloat = 0){
        if(isHidden){
            if emptyView?.superview != nil{
                emptyView?.removeFromSuperview()
            }
        }else{
            if emptyView?.superview != nil{ return }
            if emptyView == nil {
                emptyView =   HPBEmptyView()
            }
            topView.addSubview(emptyView!)
            emptyView?.snp.makeConstraints{ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                var width: CGFloat = 254
                if UIScreen.width - 120 < width{
                   width = UIScreen.width - 120
                }
                make.width.equalTo(width)
                make.height.height.equalTo(width)
            }
        }
        
    }
}
