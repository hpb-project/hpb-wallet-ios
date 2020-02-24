//
//  HPBCallbackModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/26.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

class  HPBRequestAccountModel: Mappable{

    required init?(map: Map) {
    }
    init() {
    }
    var  language  : String    = ""   //en是其他语言，cn是中文
    var  account   : String    = ""
    var  type      : String    = ""
    
    func mapping(map: Map) {
        language     <- map["language"]
        account      <- map["account"]
        type          <- map["type"]
    }


}
