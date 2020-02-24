//
//  HPBHRCModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/15.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper



struct HPBHRCModel: Mappable{
    
    init?(map: Map) {
        
    }
    var symbol: String = ""
    var tokenNum: String = "0"  //token余额
    var balance: String = "0"  //余额 HPB使用
    var contractAddress: String = ""
    private var decimals: String = "18"{
        willSet{
          formatDecimals = newValue.intValue
        }
    }
    var formatDecimals: Int = 0
    
    mutating func mapping(map: Map) {
        symbol <- map["symbol"]
        tokenNum <- map["tokenNum"]
        balance <- map["balance"]
        contractAddress  <- map["contractAddress"]
        decimals <- map["decimals"]
    }
    
}
