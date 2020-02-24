//
//  HPBMessageModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/13.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

struct HPBMessageModel: Mappable {
    init?(map: Map) {
        
    }
    var list: [HPBMessage] = []
    var pageNum: Int = 0
    var pages: Int = 0
   
    // Mappable
    mutating func mapping(map: Map) {
        pageNum  <- map["pageNum"]
        pages    <- map["pages"]
        list     <- map["list"]
    }
}

struct HPBMessage: Mappable {

    init?(map: Map) {
        
    }
    var content: String = ""
    private var oraintalContent: String = ""{
        willSet{
            content = newValue.replacingOccurrences(of: "<br />", with: "\n")
        }
    }
    var title: String = ""
    var publishTime: Double = 0{
        willSet{
           let date =  Date(timeIntervalSince1970: TimeInterval(newValue/1000.0))
           timeStr =  date.toString(by: "YYYY-MM-dd HH:mm")
            allTimeStr = date.toString(by: "YYYY-MM-dd HH:mm:ss")
        }
    }
    var timeStr: String = ""
    var allTimeStr: String = ""
    var summary: String = ""
    var msgID: String = ""
    var readState: Int = 0{
        willSet{
            isRead = newValue == 1
        }
    }
    
    var isRead: Bool = true
    // Mappable
    mutating func mapping(map: Map) {
        oraintalContent  <- map["content"]
        title           <- map["title"]
        publishTime    <- map["updatedAt"]
        summary    <- map["summary"]
        msgID   <- (map["id"],HPBStringTransform())
        readState <- map["readState"]
    }
}
