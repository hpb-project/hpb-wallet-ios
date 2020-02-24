//
//  HPB721StockModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/11.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper



struct HPB721StockList: Mappable{
    
    init?(map: Map) {
        
    }
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPB721StockModel] = []
    var total: Int = 0
    // Mappable
    mutating func mapping(map: Map) {
        pageNum    <- map["pageNum"]
        pages      <- map["pages"]
        list       <- map["list"]
        total       <- map["total"]
    }
    
}




struct HPB721StockModel: Mappable{
    
    init?(map: Map) {
        
    }
    var tokenId: String = ""
    var tokenURI: String = ""
    var count: Int = 0
   
    
    // Mappable
    mutating func mapping(map: Map) {
        
        tokenId <- map["tokenId"]
        tokenURI <- map["tokenURI"]
        count <- map["count"]
      
    }
    
}
