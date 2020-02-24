//
//  HPBTryTimesManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/30.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//  对于备份助记词 + 修改密码 + 导出私钥 + 导出助记词 + 转账  最多1小时内可尝试失败maxTimes，
//  超过后锁定1小时

import Foundation


struct  HPBTryTimesManager{
    
    static let shared: HPBTryTimesManager = HPBTryTimesManager()
    static let maxTimes = 5
    
    var tryTimesDic: [String : Any]?
    private init() {
        //        let documentDir =  HPBFileManager.getDocumentDirectory()
        //        let KstoreDirectoryPath = documentDir + ""
        //        tryTimesDic = NSDictionary.init(contentsOfFile: "")
    }
    
    static func getTryTimes(_ address: String) -> Int{
        
       return 0
    }
}
