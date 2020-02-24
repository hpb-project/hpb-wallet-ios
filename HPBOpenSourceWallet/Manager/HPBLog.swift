//
//  HPBLog.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/24.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation


//MARK: - 自定义log
/**
 调试打印
 - note 需要在`Other Swift Flags`中的Debug栏中添加`-D`和`DEBUG`, 同时别忘了添加`${inherited}`
 */
func debugLog(_ items: Any?..., file: String = #file, line: Int = #line) {
    #if DEBUG
    let shortcutFileName = (file as NSString).lastPathComponent
    let printingString = ">>[\(shortcutFileName)]--[line:\(line)]:"
    print(printingString)
    // 如果直接print(items), 打印出来的东西会在最外层带有一对"[]"
    for item in items {
        if item != nil {
            print(item!)
        } else {
            print("nil")
        }
    }
    #endif
}
