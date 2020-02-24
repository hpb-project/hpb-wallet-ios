//
//  HPBControllerUtil.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit


class HPBControllerUtil {

    static func instantiateControllerWithIdentifier(_ identifier: String, StoryboardName name: String = "Main", bundle: Bundle? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

}


class HPBViewUtil {
    
    static func instantiateViewWithBundeleName<T: UIView>(_ T: AnyClass, bundle: Bundle? = nil) -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T
    }

}

  

