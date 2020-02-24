//
//  HPBMnemonicBackView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/11.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMnemonicBackView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var view  = super.hitTest(point, with: event)
        if view == nil{
            for  subView in self.subviews{
                let tp = subView.convert(point, from: self)
                if subView.bounds.contains(tp){
                  view = subView.subviews.first
                }
            }
        }
        return view
    }

}
