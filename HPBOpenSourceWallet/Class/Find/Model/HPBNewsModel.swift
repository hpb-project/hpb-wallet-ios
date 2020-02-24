//
//  HPBNewsModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

//轮播图
struct HPBCarouselModel: Mappable{
    
    init?(map: Map) {
        
    }
    var articleId: Int = 0
    var source: String = ""
    var sourceUrl: String = ""
    var summary: String = ""
    private var oraintalContent: String = ""{
        willSet{
         content = newValue.replacingOccurrences(of: "<br />", with: "\n")
        }
    }
    var content: String = ""
    var images: String = ""
    var title: String = ""
    var publishTime: Double = 0{
        willSet{
            let date =  Date(timeIntervalSince1970: TimeInterval(newValue/1000.0))
            timeStr =  date.formatToCustom()
            hhmmTimeStr = date.toString(by: "HH:mm")
            week = date.getWeekDay()
            mmddTimeStr = date.toString(by: "MM/dd") + " " + week.localizable
            detailTime = date.toString(by: "yyyy-MM-dd HH:mm:ss")
        }
    }
    var timeStr: String = ""
    //获取小时：分钟
    var hhmmTimeStr: String = ""
    //获取月：日/星期
    var mmddTimeStr: String = ""
    //星期几
    var week: String = ""
    //年月日-时分秒
    var detailTime: String = ""
    
    var viewNum: Int = 0{
        willSet{
            switch HPBLanguageUtil.share.language {
            case .chinese:
                if newValue >= 10000{
                    viewNumStr =  "\(newValue/10000)万"
                }else{
                    viewNumStr = "\(newValue)"
                }
            case .english:
                if newValue >= 1000{
                    viewNumStr =  "\(newValue/1000)K"
                }else{
                    viewNumStr = "\(newValue)"
                }
            }
        }
    }
    
    var viewNumStr: String = "0"
    var showAllContents: Bool = false

    // Mappable
    mutating func mapping(map: Map) {
        source    <- map["source"]
        sourceUrl <- map["sourceUrl"]
        summary   <- map["summary"]
        oraintalContent   <- map["content"]
        images    <- map["images"]
        title          <- map["title"]
        publishTime    <- map["publishTime"]
        articleId <- map["articleId"]
        viewNum <- map["count.viewNum"]
    }
}


//HPB快报.最新资讯
struct HPBNewsModel: Mappable{
    
    init?(map: Map) {
        
    }
    var pageNum: Int = 0
    var pages: Int = 0
    var list: [HPBCarouselModel] = []
    
    // Mappable
    mutating func mapping(map: Map) {
        pageNum    <- map["pageNum"]
        pages      <- map["pages"]
        list       <- map["list"]
    }
}







