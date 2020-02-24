//
//  HPBDAppPayModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/7.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

class  HPBPayBaseModel: Mappable{
    required init?(map: Map) {
    }
    init(){
        
    }
    var `protocol`: String = ""
    var  version  : String = ""
    var  action  : String = ""
    var  amount : String    = "0"  //金额
    var  precision : Int = 8     //精度
    var  blockchain: String = "HPB"
    
    func mapping(map: Map) {
        `protocol`  <- map["protocol"]
        version     <- map["version"]
        action      <- map["action"]
        blockchain  <- map["blockchain"]
        amount      <- map["amount"]
        precision   <- map["precision"]
    }
}


//h5 传递给APP参数
class  HPBPayReqModel: HPBPayBaseModel{
    
    var  dappName : String = ""
    var  dappIcon : String = ""
    var  expired : String = ""
    var  desc : String = ""
    var  to : String = ""
    var  notifyUrl: String = ""
    var  isSend: Bool  = true
    var  orderId: String = ""
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        dappName  <- map["dappName"]
        dappIcon  <- map["dappIcon"]
        expired   <- (map["expired"],HPBStringTransform())
        desc <- map["desc"]
        to <- map["to"]
        notifyUrl <- map["notifyUrl"]
        isSend <- map["isSend"]
        orderId <- map["orderId"]
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
}


//App 回传给H5的参数
class  HPBPayRespModel: HPBPayBaseModel{
    
    var  result : String = ""   //1成功，0失败，-1取消
    var  txID : String = ""
    var  signature : String = ""

    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map: map)
        result  <- map["result"]
        txID  <- map["txID"]
        signature  <- map["signature"]
    }
    
    init(model: HPBPayReqModel,txHash: String? = "",signature: String? = "",result: String) {
        super.init()
        self.protocol = model.protocol
        self.version = model.version
        self.action = model.action
        self.amount = model.amount
        self.blockchain = model.blockchain
        self.precision = model.precision
        self.txID = txHash.noneNull
        self.result = result
        self.signature = signature.noneNull
    }
    
    
    required init?(map: Map) {
        super.init(map: map)
    }
}
