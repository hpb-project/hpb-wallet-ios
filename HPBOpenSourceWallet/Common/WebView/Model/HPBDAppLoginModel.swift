//
//  HPBDAppLogionModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/23.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

class  HPBLoginBaseModel: Mappable{
    required init?(map: Map) {
    }
    init(){
        
    }
    var `protocol`: String = ""
    var  version  : String = ""
    var  action  : String = ""
    var  uuID : String    = ""
    var  blockchain: String = "HPB"
    
    func mapping(map: Map) {
        `protocol` <- map["protocol"]
        version   <- map["version"]
        action    <- map["action"]
        uuID      <- map["uuID"]
        blockchain      <- map["blockchain"]
    }
}


//h5 传递给APP参数
class HPBLoginReqModel: HPBLoginBaseModel {
  
    var  dappName : String = ""
    var  dappIcon : String = ""
    var  expired : String = ""
    var  loginMemo : String = ""
    var  loginUrl : String = ""
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        dappName  <- map["dappName"]
        dappIcon  <- map["dappIcon"]
        expired   <- (map["expired"],HPBStringTransform())
        loginMemo <- map["loginMemo"]
        loginUrl <- map["loginUrl"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}


//App 回传给H5的参数
class HPBLoginRespModel: HPBLoginBaseModel {
    
    var  timestamp : String = "0"
    var   account: String = ""
    var   ref:     String = "HPBWallet"
    var   sign:     String = ""
    
    
   override func mapping(map: Map) {
        super.mapping(map: map)
        timestamp  <- map["timestamp"]
        account    <- map["account"]
        ref        <- map["ref"]
        sign        <- map["sign"]
    }

    init(model: HPBLoginReqModel,sign: String,account: String,timestamp: String) {
        super.init()
        self.protocol = model.protocol
        self.version = model.version
        self.action = model.action
        self.uuID = model.uuID
        self.sign = sign
        self.account = account
        self.timestamp = timestamp
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
}
