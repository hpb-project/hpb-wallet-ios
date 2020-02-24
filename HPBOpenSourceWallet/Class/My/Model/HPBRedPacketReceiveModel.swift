//
//  HPBRedPacketModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

struct HPBRedPacketReceiveLists: Mappable{
    
    init?(map: Map) {
        
    }
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPBRedPacketReceiveModel] = []
    var total: Int = 0
    // Mappable
    mutating func mapping(map: Map) {
        pageNum    <- map["pageNum"]
        pages      <- map["pages"]
        list       <- map["list"]
        total       <- map["total"]
    }
    
}


struct HPBRedPacketReceiveModel: Mappable{

    enum HPBRedPacketSourceType{
        case shake
        case normal
    }

    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    var sourceType: HPBRedPacketSourceType = .normal
    var fromAddr: String = ""
    var toAddr: String = ""
    var redPacketNo: String = ""
    var coinValue: String = "0"
    var redPacketType: String = ""
    var title: String = ""
    var showStatus: String = ""
    var enterType: String = "1"{ //1 代表红包, 2代表 摇一摇
        willSet{
            if newValue == "1"{
               sourceType = .normal
            }else if newValue == "2"{
               sourceType = .shake
            }
        }
    }
    var status: String = ""{
        willSet{
            if newValue == "0"{
                showStatus = "News-RedPacket-State-Faile".localizable
            }else if newValue == "1"{
                showStatus = "News-RedPacket-Received".localizable
            }else if newValue == "2"{
                showStatus = "News-RedPacket-State-Conforming".localizable
            }
        }
    }
    
    var type: String = ""{
        willSet{
            if newValue == "1"{
                redPacketType = "News-RedPacket-Send-Type-Normal".localizable
            }else if newValue == "2"{
                redPacketType = "News-RedPacket-Send-Type-Random".localizable
            }
        }
    }
    var showTime: String = ""
    var startTime: Double = 0{
        willSet{
            let date =  Date(timeIntervalSince1970: TimeInterval(newValue/1000.0))
            showTime = date.toString(by: "yyyy-MM-dd HH:mm:ss")
        }
    }
    // Mappable
    mutating func mapping(map: Map) {
        fromAddr    <- map["fromAddr"]
        toAddr    <- map["toAddr"]
        redPacketNo    <- map["redPacketNo"]
        coinValue <- map["coinValue"]
        status <- map["status"]
        type <- map["redPacketType"]
        startTime <- map["gmtCreate"]
        title <- map["title"]
        enterType <- map["title"]
        
    }


}



