//
//  Optional+EXtension.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/24.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation

// MARK: - String
public protocol  OptionalSting {}
extension String : OptionalSting {}
extension Optional where Wrapped: OptionalSting {
    /// 对可选类型的String(String?)安全解包
    var noneNull: String {
        if let value = self as? String {
            return value
        } else {
            return ""
        }
    }
    
    
    /// 解包可选字符串 并对空字符串设置默认值
    ///
    /// - Parameter defaultStr: 默认值
     func noneNull(defaultStr: String) -> String {
        if self.noneNull.isEmpty {
            return defaultStr
        } else {
            return self.noneNull
        }
    }
}

