//
//  HPBVoteModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/8/14.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper


struct HPBVoteRankModel: Mappable{
    enum HPBOpenStyle{
        case open
        case close
    }
    
    init?(map: Map) {
        
    }
    var pageNum: Int = 0
    var pages: Int = 0
    var bonusIsOpen: String = "0"{
        willSet{
            if newValue == "1"{
              openState = .open
            }else{
               openState = .close
            }
        }
    }
    var list: [HPBVoteModel] = []
    var openState: HPBOpenStyle = .close
    // Mappable
    mutating func mapping(map: Map) {
        pageNum    <- map["pageNum"]
        pages      <- map["pages"]
        list       <- map["list"]
        bonusIsOpen <- map["bonusIsOpen"]
    }
    
}


struct HPBVoteModel: Mappable {
    
    enum HPBVoteDidendType{
        case noSet,showRate,noEnouth
    }
    
    
    enum HPBVoteState{
        case voting,end
    }
    
    enum HPBVoteModifyFlag{
        case can,cannot,authorize
    }
    
    init?(map: Map) {
        
    }
    //候选人ID
    var voterId: String = ""
    
    var coinbase: String = ""
    var name: String = ""
    var address: String = ""
    var rank: String = ""
    var count: String = "0"{
        willSet{
         countFormat = HPBStringUtil.converHpbMoneyFormat(newValue, 0)
        }
    }
    var linkUrl: String = ""
    var description: String = ""
    var countFormat: String? = ""
    
    
    //1.5.0版本修改
    var holderAddr: String = ""      //持币地址
    var  flag: String = ""{          //"1",标识：1-容许修改持币地址，0-节点地址未给当前地址授权
        willSet{
            if newValue == "2"{
                voteModifyFlag = .authorize
            }else if newValue == "1"{
                voteModifyFlag = .can
            }else{
                 voteModifyFlag = .cannot
            }
        }
        
        
    }
    private var isRunUpStage: String = ""{ //“1”,是否是竞选中：1-竞选中，0-竞选结束,只有竞选结束后，才可以修改持币地址
        willSet{
            if newValue == "0"{
              voteState = .end
            }else{
                voteState = .voting
            }
        }
    }
     var voteState: HPBVoteState = .voting
     var voteModifyFlag: HPBVoteModifyFlag = .cannot
    
    
    ///2.0.0添加是否设置分红
    var bonusRate: String  = "0"
    var bonusFlag: String = ""{
        willSet{
            if newValue == "1"{
              showType = .noSet
            }else if newValue == "3" || newValue == "4" || newValue == "6"{
               showType = .noEnouth
            }else if newValue == "2" || newValue == "5"{
                 showType = .showRate
            }
        }
    }
    var showType: HPBVoteDidendType = .noSet
    
    // Mappable
    mutating func mapping(map: Map) {
        voterId <- map["id"]
        coinbase  <- map["coinbase"]
        name    <- map["name"]
        address    <- map["address"]
        count    <- map["count"]
        linkUrl    <- map["linkUrl"]
        description    <- map["description"]
        rank <- map["rank"]
        holderAddr <- map["holderAddr"]
        flag <- map["flag"]
        isRunUpStage <- map["isRunUpStage"]
        
        bonusRate <- map["bonusRate"]
        bonusFlag <- map["bonusFlag"]
    }
}




//我的投票
struct HPBMyVoteModel: Mappable{
    init?(map: Map) {
    }
    var currentBlockNumber: String = "0"   //当前的区块号
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPBMyVoteItemModel] = []
    
    fileprivate var aviliable: String = "0"{
        willSet{
            formatAviliable = HPBStringUtil.converHpbMoneyFormat(newValue,0)
        }
    }
    
    fileprivate var  totalVoteNum: String = "0"{
        willSet{
            formatTotalVote = HPBStringUtil.converHpbMoneyFormat(newValue, 0)
        }
    }
    var  formatAviliable: String? = ""
    var  formatTotalVote: String? = ""
    
    
    // Mappable
    mutating func mapping(map: Map) {
        pageNum       <- map["pageNum"]
        pages         <- map["pages"]
        list          <- map["list"]
        aviliable       <- (map["extention.aviliable"],HPBStringTransform())
        totalVoteNum  <- (map["extention.totalVoteNum"],HPBStringTransform())
        currentBlockNumber  <- map["extention.currentBlockNumber"]
    }
    
}


struct HPBMyVoteItemModel: Mappable{
    
    init?(map: Map) {
        
    }
    var tTimestap: Double = 0{
        willSet{
            let date =  Date(timeIntervalSince1970: TimeInterval(newValue/1000.0))
            allTimeStr = date.toString(by: "YYYY/MM/dd hh:mm:ss")
        }
    }
    var allTimeStr: String = ""
    var voteNum: String = "0"{
        willSet{
            formatVoteNum = HPBStringUtil.converHpbMoneyFormat(newValue, 0)
        }
    }
    fileprivate var countNum: String = "0"{
        willSet{
            formatCountNumNum = HPBStringUtil.converHpbMoneyFormat(newValue, 0)
        }
    }
    var name: String = ""
    var voterId: String = ""
    var blockNumber: String = "0"
    var state: String? = "0" //撤销状态, 1撤销
    var opeartionTimestap: Double = 0   //操作的时间戳
    var toAccount: String = ""
    var transactionHash: String = ""
    //投票的个数
    var formatVoteNum: String? = ""
    var formatCountNumNum: String? = ""
    // Mappable
    mutating func mapping(map: Map) {
        tTimestap     <- map["tTimestap"]
        voteNum       <- map["voteNum"]
        countNum      <- map["countNum"]
        name         <- map["name"]
        transactionHash    <- map["transactionHash"]
        toAccount   <- map["toAccount"]
        blockNumber  <- map["blockNumber"]
        state        <- map["state"]
        opeartionTimestap  <- map["opeartionTimestap"]
        voterId  <- map["voterId"]
    }
    
}


struct HPBPersonalInfoModel: Mappable{

    var balance: String? = "0"
    var totalVoteNum: String? = "0"
    var aviliable: String? = "0"
    var numForNode: String? = "0"
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        balance       <- map["balance"]
        totalVoteNum  <- map["totalVoteNum"]
        aviliable      <- map["aviliable"]
        numForNode <- map["numForNode"]
    }
}




//获取成功失败的状态

struct HPBTransferStateModel: Mappable{
    
    var status: String? = ""{
        willSet{
            if newValue == "0x1"{
              isSuccess = true
            }else if newValue == "0x0"{
              isFaile = true
            }
        }
    }
    var isSuccess: Bool = false
    var isFaile: Bool = false

    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        status   <- map["status"]      //0x1表示成功
    }
}
