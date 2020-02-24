//
//  UIScreen+Extension.swift
//  WJExtension
//
//  Created by shuo on 2017/6/5.
//  Copyright © 2017年 wanjia. All rights reserved.
//

import UIKit

public extension UIScreen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let navigationBarHeight: CGFloat = 44
    static var statusHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    static var navigationHeight: CGFloat {
        return statusHeight + navigationBarHeight
    }
    static let tabbarHeight: CGFloat = 49
    static var tabbarSafeBottomMargin: CGFloat {
        if UIDevice.isIPHONE_X {
            return 34.0
        }
        return 0
    }
    static let separatorSize = CGFloat(1.0 / UIScreen.main.scale)
    static let roundRectButtonBorderWidth = 1.5 / UIScreen.main.scale
    
    static func scaleSizeIphonePlus(_ size: CGFloat) -> CGFloat {
        return floor((size) / 414.0 * width)
    }
    
    static func scaleFontIphone6(_ size: CGFloat) -> CGFloat {
        return floor((size) / 375.0 * width)
    }
    
    static let greatestSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
}
