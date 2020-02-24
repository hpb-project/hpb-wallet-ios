//
//  HPBRedPacketModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/20.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

struct HPBRedPacketReadyModel: Mappable{
    
    init?(map: Map) {
        
    }
    var valuesArr: [String] = []
    var packetNo: String = ""
    var contractAddr: String = ""
    var proxyAddr: String = ""
    
    // Mappable
    mutating func mapping(map: Map) {
        packetNo       <- map["packetNo"]
        valuesArr      <- map["valuesArr"]
        contractAddr  <- map["contractAddr"]
        proxyAddr  <- map["proxyAddr"]
    }
    
}
