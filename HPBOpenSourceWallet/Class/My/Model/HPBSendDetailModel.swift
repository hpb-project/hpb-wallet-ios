//
//  HPBSendDetailModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/21.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

struct HPBSendDetailLists: Mappable{
    
    //红包结束状态
    enum HPBRedPacketOverState {
        case ongoing
        case over
    }
    
    //红包类型
    enum HPBRedPacketType{
        
        case random
        case normal
    }
    
    //红包领取的时候,判断状态,针对领取的列表刷新
    enum HPBRedPacketDrawStatus{
        case confirm
        case success
        case faile
        case none
        
    }
    
    //红包发送的时候,判断状态,针对领取的列表刷新
    enum HPBRedPacketSendStatus{
        case confirm
        case success
        case faile
        case none
        
    }
    
    
    //红包是否结束
    enum HPBRedPacketOver{
        case ongoing
        case end
        case none
        
    }
    
    
    init?(map: Map) {
        
    }
    
    var redPacketType: HPBRedPacketType = .normal
    var redpacketOver: HPBRedPacketOver = .none
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPBSendDetailModel] = []
    var total: Int = 0
    var title: String = ""
    var usedNum: Int = 0
    var totalNum: Int = 0
    var totalCoin: String = "0"
    var status: String = ""
    var isOver: String = "0"{   // "1",是否结束：1-进行中，2-已结束,
        willSet{
            if newValue == "1"{
                redpacketOver = .ongoing
            }else if newValue == "2"{
                redpacketOver = .end
            }
        }
    }
    var fromAddr: String = ""
    var type: String = ""{
        willSet{
            if newValue == "1"{
               redPacketType = .normal
            }else {
               redPacketType = .random
            }
        }
    }
    ///发送红包详情独有的字段
    var redPacketSendStatus: HPBRedPacketSendStatus = .none
    var packetStatus: String = ""{

        willSet{
            if newValue == "1"{
                redPacketSendStatus = .success
            }else if newValue == "0"{
                redPacketSendStatus = .faile
            }else if newValue == "2"{
                redPacketSendStatus = .confirm
            }else{
                redPacketDrawStatus = .none
            }
        }
    }
    
    /////领取红包时候的字端,独有的字段
    var isKeyVaild: Bool = false
    var isValue: String = ""{
        willSet{
            if newValue == "0"{
                isKeyVaild = true
            }else {
                isKeyVaild = false
            }
        }
    }
    var tokenId: String = ""
    var currentValue = "0"
    var redPacketDrawStatus: HPBRedPacketDrawStatus = .none
    var drawStatus = ""{
        willSet{
            if newValue == "1"{
                redPacketDrawStatus = .success
            }else if newValue == "0"{
                 redPacketDrawStatus = .faile
            }else if newValue == "5"{
                redPacketDrawStatus = .confirm
            }else{
                redPacketDrawStatus = .none
            }
        }
    }
    // Mappable
    mutating func mapping(map: Map) {
        usedNum     <- map["usedNum"]
        pageNum    <- map["pageNum"]
        pages      <- map["pages"]
        list       <- map["list"]
        total       <- map["total"]
        title       <- map["title"]
        totalCoin  <- map["totalCoin"]
        totalNum  <- map["totalPacketNum"]
        status <- map["status"]
        isOver  <- map["isOver"]
         fromAddr    <- map["from"]
         type    <- map["type"]
        
        packetStatus <- map["packetStatus"]
        
        //领取红包时候的字端
        isValue    <- map["keyIsVaild"]
        tokenId    <- map["tokenId"]
        currentValue <- map["tokenValue"]
        drawStatus <- map["drawStatus"]
    }
    
}


struct HPBSendDetailModel: Mappable{
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    var toAddr: String = ""
    var coinValue: String = "0"
    var showTime: String = ""
     var maxFlag: String?
    var startTime: Double = 0{
        willSet{
            let date =  Date(timeIntervalSince1970: TimeInterval(newValue/1000.0))
            showTime = date.toString(by: "yyyy-MM-dd HH:mm:ss")
        }
    }
    // Mappable
    mutating func mapping(map: Map) {
        toAddr    <- map["toAddr"]
        coinValue <- map["coinValue"]
        startTime <- map["tradeTime"]
       maxFlag <- map["maxFlag"]
    }
    
    
}



