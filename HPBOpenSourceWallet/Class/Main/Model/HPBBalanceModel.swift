//
//  HPBBalanceModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/15.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper



struct HPBBalanceListModels: Mappable{
    
    init?(map: Map) {
        
    }
    var cnyTotalValue: String = "0"  //人民币
    var usdTotalValue: String = "0"  //美元
    var list: [HPBBalanceModel] = []
    
    mutating func mapping(map: Map) {
        cnyTotalValue <- map["cnyTotalValue"]
        usdTotalValue <- map["usdTotalValue"]
        list <- map["list"]
    }
    
}


struct HPBBalanceModel: Mappable{
    
    init?(map: Map) {
        
    }
    var cnyTotalValue: String = "0"  //人民币
    var usdTotalValue: String = "0"  //美元
    var address: String = ""
    
    mutating func mapping(map: Map) {
        cnyTotalValue <- map["cnyTotalValue"]
        usdTotalValue <- map["usdTotalValue"]
        address <- map["address"]
    }
    
}
