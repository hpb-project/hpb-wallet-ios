//
//  HPBRetryViewProtocol.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/20.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

protocol HPBRetryViewProtocol: class {
    var retryView: HPBRetryView? {get set}
}


extension HPBRetryViewProtocol{
    
    func isHiddenRetryView(_ isHidden:Bool,topMagrn: CGFloat = 0,topView: UIView, title: String = "Common-Load-faile".localizable,retry: (() -> Void)?  = nil){
        if(isHidden){
            if retryView?.superview != nil{
                retryView?.removeFromSuperview()
            }
        }else{
            if retryView?.superview != nil{ return }
            if retryView == nil {
                retryView =  HPBRetryView(title: title)
                retryView?.retryBlock = {
                    retry?()
                }
            }
            topView.addSubview(retryView!)
            retryView?.snp.makeConstraints{ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: topMagrn, left: 0, bottom: 0, right: 0))
            }
        }
    }
}

