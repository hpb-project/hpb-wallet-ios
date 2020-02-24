//
//  HPBDAppTransationModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/15.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper


//h5 传递给APP参数
class  HPBTransationReqModel: Mappable{
    
    required init?(map: Map) {
    }
    
    var  from : String = ""
    var  to : String = ""
    var  gas : String = ""
    var  gasPrice : String = ""
    var  value: String = ""
    var  data: String  = ""
    var  action: String = "Transation"
    var  isSend: Bool = true
    var  dappName: String = ""
    var  desc: String = ""
    
    // Mappable
    func mapping(map: Map) {
        from  <- map["from"]
        to  <- map["to"]
        gas   <- map["gas"]
        gasPrice <- map["gasPrice"]
        value <- map["value"]
        data <- map["data"]
        action <- map["action"]
        dappName <- map["dappName"]
        desc <- map["desc"]
    }
    
}


//App 回传给H5的参数
class  HPBTransationRespModel: Mappable{
    
    required init?(map: Map) {
    }
    
    init() {
        
    }
    
    var  txID : String = ""
    var  action: String = "Transation"
    
    
    // Mappable
    func mapping(map: Map) {
        txID  <- map["txID"]
        action <- map["action"]
        
    }
}

