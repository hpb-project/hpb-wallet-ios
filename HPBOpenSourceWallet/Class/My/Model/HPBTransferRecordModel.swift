//
//  HPBTransferRecordModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

//交易记录
struct HPBTransferRecordModel: Mappable{
    
    init?(map: Map) {
        
    }
    var currentAddress = ""   //缓存使用
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPBTransferRecord] = []
  
    // Mappable
    mutating func mapping(map: Map) {
        pageNum  <- map["pageNum"]
        pages    <- map["pages"]
        list     <- map["list"]
        currentAddress >>> map["currentAddress"]
        currentAddress <- map["currentAddress"]
    }
}

struct HPBTransferRecord: Mappable{

    init?(map: Map) {
        
    }
    init(){
        
    }
    
    var transactionHash: String = ""
    var fromAccount: String = ""
    var toAccount: String = ""
    var nonce: Int = 0
    var blockNumber: Int = 0
    var actulTxFee: String = ""
    var tValue: String = ""
    var txHash: String?{
        willSet{
            guard let `newValue` = newValue else {
                return
            }
           transactionHash = newValue
        }
    }
    private var decimals: String = "18"{
        willSet{
            formatDecimals = newValue.intValue
        }
    }
    var formatDecimals: Int = 0
    
    var customTtimeTap: Double?{
        willSet{
            guard let `newValue` = newValue else {return}
            tTimestap = newValue
        }
    }
    
    var tTimestap: Double?{
        willSet{
            guard let `newValue` = newValue else {return}
            let date = Date(timeIntervalSince1970: newValue)
            monthStr = HPBStringUtil.noneNull(date.toString(by:"yyyy-MM"))
            formatStr = date.formatToCustom(yearFormate: "YYYY-MM-dd HH:mm")
        }
    }
    // HRC721专用
    var blockTimestamp: Double?{
        willSet{
            guard let `newValue` = newValue else {return}
            tTimestap = newValue
        }
    }

    var tokenId: String = ""
    var monthStr: String = ""
    var formatStr: String = ""
    var tokenSymbol: String = ""  //代币简称
    var contractAddress: String = ""
    // Mappable
    mutating func mapping(map: Map) {
        transactionHash <- map["transactionHash"]
        txHash          <- map["txHash"]        // token721/idDetail这边用txHash
        fromAccount     <- map["fromAddress"]
        toAccount       <- map["toAddress"]
        nonce           <- map["nonce"]
        blockNumber     <- map["blockNumber"]
        actulTxFee      <- map["actulTxFee"]
        tValue          <- map["tValue"]
        customTtimeTap       <- map["tTimestap"]
        tokenSymbol     <- map["tokenSymbol"]
        contractAddress  <- map["contractAddress"]
         /// HRC721专用
        blockTimestamp       <- map["blockTimestamp"]
        tokenId        <- map["tokenId"]
        fromAccount     <- map["fromAccount"]
        toAccount       <- map["toAccount"]
        
        /// HRC20专用
        decimals  <- map["decimals"]
    }

}
