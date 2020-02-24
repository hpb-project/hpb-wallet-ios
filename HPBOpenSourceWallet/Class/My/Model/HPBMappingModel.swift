//
//  HPBMappingModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/8/1.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper


struct HPBMappingBalanceModel: Mappable {
    init?(map: Map) {
        
    }
    var ethBalance: String = "0"
    var hpbToken: String = "0"
    
    // Mappable
    mutating func mapping(map: Map) {
        ethBalance  <- map["ethBalance"]
        hpbToken    <- map["hpbToken"]
    }
}


struct HPBTransferFeeModel: Mappable {
    init?(map: Map) {
        
    }
    var nonce: Int = 0
    var gasLimit: String = "0"
    var gasPrice: String = "0"
    // Mappable
    mutating func mapping(map: Map) {
        nonce  <- map["nonce"]
        gasLimit    <- map["gasLimit"]
        gasPrice    <- map["gasPrice"]
    }
}
