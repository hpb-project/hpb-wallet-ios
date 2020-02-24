//
//  HPBProposalModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/13.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

//题案列表
struct HPBProposalLists: Mappable{
    
    init?(map: Map) {
        
    }
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPBProposalModel] = []
    var total: Int = 0
    // Mappable
    mutating func mapping(map: Map) {
        pageNum    <- map["pageNum"]
        pages      <- map["pages"]
        list       <- map["list"]
        total       <- map["total"]
    }
    
}
    
struct HPBProposalModel: Mappable{
    
    
    enum HPBGovernanceType: String{
        case ongoing  =   "News-Governance-State-Voting"   //进行中
        case pass     = "News-Governance-State-Passed"    //已通过
        case revealed = "News-Governance-State-Processed"   //揭晓中
        case obsolete = "News-Governance-State-Invalid"  //已作废
        case veto     = "News-Governance-State-Vetoed"   //被否决
    }
    
    init?(map: Map) {
        
    }
    var issueNo: String = ""
    var voteType: HPBGovernanceType = .ongoing
    var titleName: String = ""
    private var voteStatus: String = ""{  // "voteStatus":"1",投票状态：0-初始化，1-投票中，2-揭晓中，3-已通过，4-被否决，5-已作废
        willSet{
            if newValue == "1"{
              voteType = .ongoing
            }else if newValue == "2"{
                voteType = .revealed
            }else if newValue == "3"{
                voteType = .pass
            }else if newValue == "4"{
                voteType = .veto
            }else if newValue == "5"{
                voteType = .obsolete
            }
        }
    }
   var nameZh: String = ""{
        willSet{
            if HPBLanguageUtil.share.language == .chinese{
              titleName = newValue
            }
        }
    }
   var nameEn: String = ""{
        willSet{
            if HPBLanguageUtil.share.language == .english{
                titleName = newValue
            }
        }
        
    }
    
    
    
    var beginTime: Double = 0
    var endTime: Double = 0
    var countDownTime: Double = 0
    var value1Rate: String = "0"  //选项一占比
    var value2Rate : String = "0" //选项二占比
    var value1Num  : String  = "0" //选项一数量
    var value2Num : String = "0"  //选项二数量
    
    var option1Name: String = ""
    var option2Name: String = ""
    private var value1Zh: String = ""{  //选项一标题
        willSet{
            if HPBLanguageUtil.share.language == .chinese{
                option1Name = newValue
            }
        }
    }
    
    private var value2Zh : String = ""{
        willSet{
            if HPBLanguageUtil.share.language == .chinese{
                option2Name = newValue
            }
        }
    }
    private var value1En  : String  = ""{ //选项二标题
        willSet{
            if HPBLanguageUtil.share.language == .english{
                option1Name = newValue
            }
        }
    }
    private var value2En : String = ""{
        willSet{
            if HPBLanguageUtil.share.language == .english{
                option2Name = newValue
            }
        }
    }
    
    var floorNum: String  = "0"    //投票限度
    
    //投票详情独有
    var desc: String = ""
    var descZh: String = ""{
        willSet{
            if HPBLanguageUtil.share.language == .chinese{
                desc = newValue
            }
        }
    }
    var descEn: String = ""{
        willSet{
            if HPBLanguageUtil.share.language == .english{
                desc = newValue
            }
        }
    }
    
    var aviliableNum: String = "0"
    var totalNum: String = "0"
    var peragreeNum: String = "0"   //选项一 自己,已投数量
    var perdisagreeNum: String = "0" //选项二 自己,已投数量
    
    var issurContractAddress: String = ""
    // Mappable
    mutating func mapping(map: Map) {
        countDownTime <- map["countDownTime"]
        issueNo <- map["issueNo"]
        voteStatus <- map["voteStatus"]
        nameZh    <- map["nameZh"]
        nameEn    <- map["nameEn"]
        beginTime <- map["beginTime"]
        endTime <- map["endTime"]
        value1Rate  <- map["value1Rate"]
        value2Rate    <- map["value2Rate"]
        value1Num    <- map["value1Num"]
        value2Num    <- map["value2Num"]
        descZh <- map["descZh"]
        descEn <- map["descEn"]
        
        value1Zh <- map["value1Zh"]
        value2Zh  <- map["value2Zh"]
        value1En  <- map["value1En"]
        value2En <- map["value2En"]
        totalNum <- map["totalNum"]
        aviliableNum <- map["aviliableNum"]
        peragreeNum <- map["peragreeNum"]
        perdisagreeNum <- map["perdisagreeNum"]
        issurContractAddress <- map["issurContractAddress"]
        floorNum <- map["floorNum"]
    }
    
}
