//
//  HPBDAppModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/20.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

struct HPBDAppModel: Mappable{


    init?(map: Map) {
        
    }
    var commonName: String{
        return HPBLanguageUtil.share.language == .chinese ? nameCn : nameEn
    }
    var appid: String = ""
    var nameEn: String = ""
    var nameCn: String = ""
    var logo: String = ""
    var url: String = ""
    fileprivate var isOuter: Int = 0{
        willSet{
            if newValue == 1{
              isOpenSafari = true
            }
        }
    }
    var isOpenSafari: Bool = false
    var authState: Bool = false
    fileprivate var solutionType: String = "0" {
        willSet{
            if newValue == "1"{
                isIntercept = false
            }
        }
    }
    var isIntercept: Bool = true
    
    // Mappable
    mutating func mapping(map: Map) {
        nameEn      <- map["nameEn"]
        nameCn      <- map["nameCn"]
        logo       <- map["logo"]
        url        <- map["url"]
        appid        <- (map["id"],HPBStringTransform())
        isOuter        <- map["isOuterBrowserOpen"]
        authState   <- map["isAuthorize"]
        solutionType <- map["solutionType"]
        
    }




}
