//
//  HPBTokenManagerModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/10.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper



//首页token列表
struct HPBMainTokenLists: Mappable{
    init?(map: Map) {
        
    }
    
    var hpbBalance: String = "0"
    var ptCnyValue: String = "0"
    var ptUsdValue: String = "0"
    var list: [HPBTokenManagerModel] = []
    // Mappable
    mutating func mapping(map: Map) {
        ptCnyValue    <- map["ptCnyValue"]
        ptUsdValue      <- map["ptUsdValue"]
        hpbBalance  <- map["hpbBalance"]
        list       <- map["list"]
    }
}






struct HPBTokenManagerModel: Mappable{
    
    
    enum HPBContractType: String {
        case mainNet = "HPB"
        case hrc20 = "HRC-20"
        case hrc721 = "HRC-721"
        
    }
    init(){
        
    }
    
    init?(map: Map) {
        
    }
    var tokenID: String = ""
    var tokenSymbol: String = ""  //代币简称
    var tokenSymbolImageUrl: String = ""  //代币图片地址
    var tokenName: String = ""  //代币名称
    var contractType: String = "HPB"{  //合约类型
        willSet{
            type = HPBContractType(rawValue: newValue) ?? HPBContractType.mainNet
        }
    }
    var cnyTotalValue: String = "0"  //人民币
    var usdTotalValue: String = "0"  //美元
    var contractAddress: String = ""  //合约地址
    var balanceOfToken: String = "0"  //当前币的数量
    var cnyPrice: String = ""
    
    var type: HPBContractType = .mainNet
    
    private var decimals: String = "18"{
        willSet{
            formatDecimals = newValue.intValue
        }
    }
    var formatDecimals: Int = 0

    ///自定义字段(排序专用)
    var isCanSort: Bool = false
    
    // Mappable
    mutating func mapping(map: Map) {
    
        tokenID <- map["id"]
        tokenSymbol <- map["tokenSymbol"]
        tokenSymbolImageUrl <- map["tokenSymbolImageUrl"]
        tokenName <- map["tokenName"]
        contractType <- map["contractType"]
        cnyTotalValue <- map["cnyTotalValue"]
        usdTotalValue <- map["usdTotalValue"]
        contractAddress <- map["contractAddress"]
        balanceOfToken <- map["balanceOfToken"]
        decimals  <- map["decimals"]
        cnyPrice <- map["cnyPrice"]
    }
    
}
