//
//  UITabBar+badge.swift
//  wanjia2B
//
//  Created by shuo on 16/9/29.
//  Copyright © 2016年 pingan. All rights reserved.
//

import UIKit

extension UITabBar {

    func changeMessageBadge() {
        if HPBSystemMsgManager.share.isShowRed{
            showBadgeOnItemIndex(2)
        } else {
            removeBadgeOnItemIndex(2)
        }
    }

    func showBadgeOnItemIndex(_ index: Int) {
        let tabbarItemNums = 3
        removeBadgeOnItemIndex(index)
        let badgeView = UIView()
        badgeView.backgroundColor = UIColor.red
        badgeView.tag = 666 + index

        let tabFrame = frame
        let percentX: CGFloat = CGFloat(CGFloat(index) + 0.6) / CGFloat(tabbarItemNums)
        let x = CGFloat(ceilf(Float(percentX * CGFloat(tabFrame.size.width))))
        let y = CGFloat(ceilf(Float(0.1 * CGFloat(tabFrame.size.height))))
        badgeView.frame = CGRect(x: x, y: y, width: CGFloat(8), height: CGFloat(8))
        badgeView.layer.cornerRadius = 4
        addSubview(badgeView)
    }

    func removeBadgeOnItemIndex(_ index: Int) {
        for subView in subviews {
            if subView.tag == 666 + index {
                subView.removeFromSuperview()
                break
            }
        }
    }

}
