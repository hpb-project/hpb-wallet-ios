//
//  HPBRedPacketSendModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

struct HPBRedPacketSendLists: Mappable{
  
    init?(map: Map) {
        
    }
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPBRedPacketSendModel] = []
    var total: Int = 0
    // Mappable
    mutating func mapping(map: Map) {
        pageNum    <- map["pageNum"]
        pages      <- map["pages"]
        list       <- map["list"]
        total       <- map["total"]
    }
    
}


struct HPBRedPacketSendModel: Mappable{
    
    enum HPBSendListState{
        case success
        case faile
        case confim
    }
    
    enum HPBSendListOver{
        case ongoing
        case end
        case none
       
    }
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    var redpacketState: HPBSendListState = .faile
    var redpacketOver: HPBSendListOver = .none
    var totalCoin: String = "0"
    var redPacketNo: String = ""
    var coinSymbol: String = ""
    var totalNum: Int = 0
    var usedNum: Int = 0
    var redPacketType: String = ""
    var showTime: String = ""
    var status: String = ""{
        willSet{
            if newValue == "1"{
                redpacketState = .success
            }else if newValue == "2"{
                redpacketState = .confim
            }else{
                redpacketState = .faile
            }
        }
    }
    var isOver: String = "0"{
        willSet{
            if newValue == "1"{
                redpacketOver = .ongoing
            }else if newValue == "2"{
                redpacketOver = .end
            }
        }
        
    }
    var startTime: Double = 0{
        willSet{
            let date =  Date(timeIntervalSince1970: TimeInterval(newValue/1000.0))
            showTime = date.toString(by: "yyyy-MM-dd HH:mm:ss")
        }
    }
    var type: String = ""{
        willSet{
            if newValue == "1"{
                redPacketType = "News-RedPacket-Identical".localizable
            }else if newValue == "2"{
                redPacketType = "News-RedPacket-Random".localizable
            }
        }
    }
    var fromAddr: String = ""
    var toAddr: String = ""
    var title: String = ""
    // Mappable
    mutating func mapping(map: Map) {
        redPacketNo    <- map["redPacketNo"]
        coinSymbol      <- map["coinSymbol"]
        totalNum  <- map["totalNum"]
        type <- map["redPacketType"]
        usedNum <- map["usedNum"]
        startTime <- map["gmtCreate"]
        totalCoin <- map["totalCoin"]
         status <- map["status"]
        fromAddr    <- map["fromAddr"]
        toAddr    <- map["toAddr"]
        title  <- map["title"]
         isOver  <- map["isOver"]
    }
    
    
}





