//
//  HPBAdManager.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/4.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper
import SDWebImage

//开屏广告
struct HPBAdRequestModel: Mappable{
    
    init?(map: Map) {
        
    }
    var name: String = ""
    var picUrl: String =  "a"
    var skipType: String = "2"  //-url跳转类型：1-内部，2-H5
    var skipUrl: String =  ""
    var startTime: Double = 0
    var endTime: Double = 0
    var state: String =  "" //"2",状态：1-待上架，2-已上架，3-已下架，4-已结束
    var nextPage: String = ""
    // Mappable
    mutating func mapping(map: Map) {
        name  <- map["name"]
        picUrl    <- map["picUrl"]
        skipType     <- map["skipType"]
        skipUrl <- map["skipUrl"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        state <- map["state"]
        nextPage <- map["nextPage"]
    }
}

class HPBAdManager{

static let share = HPBAdManager()
 
    enum HPBAdSkipType{
        case page,h5
    }
    enum HPBPageType{
        case redPacket,transfer
    }
    
    var skipType: HPBAdSkipType = .h5
    var pageType: HPBPageType = .redPacket
    
    var model: HPBAdRequestModel?{
        //1-红包，2-我的投票，3-转账
        willSet{
            guard let `newValue` = newValue  else{
                return
            }
            if newValue.skipType == "1"{
                self.skipType = .page
                if newValue.nextPage == "1"{
                    self.pageType = .redPacket
                }else if newValue.nextPage == "2"{
                   
                }else if newValue.nextPage == "3"{
                    self.pageType = .transfer
                }
            }else if newValue.skipType == "2"{
                self.skipType = .h5
            }
        }
    }
    
    //开机Image
    var adImage: UIImage?

    //获取开屏广告的信息
    func requestAdNetwork(success: (()->Void)? = nil,faile: (()->Void)? = nil){
        let (requestUrl,param) = HPBAppInterface.getAdvertise()
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBAdRequestModel? else{
                    return
                }
                self.model = model
                //判断是否下载好开机图
                if let cacheImage =  SDImageCache.shared()?.imageFromDiskCache(forKey: model.picUrl){
                    self.adImage = cacheImage
                    success?()
                }else{
                    //下载图片并存储
                    guard let imageUrl = URL(string: model.picUrl) else{return}
                    SDWebImageManager.shared()?.downloadImage(with: imageUrl, options: .retryFailed, progress: nil, completed: { (image, error, cacheType,finished,url) in
                        if error == nil{
                            SDImageCache.shared()?.store(image, forKey: model.picUrl, toDisk: true)
                            success?()
                        }else{
                          faile?()
                        }
                    })
                }
            }else{
               faile?()
            }
        }
    }
    
    
    
    //判断是否显示
    func isShowAd() -> Bool{
        
       
        
        //如果过了日期并且是未发布状态不显示
        if let adModel = self.model{
            let currentDate  = Date().timeIntervalSince1970
            if currentDate * 1000 < adModel.startTime{
                return false
            }else if currentDate * 1000 > adModel.endTime{
                return false
            }else if adModel.state != "2"{
                return false
            }
        }
        
        //今天显示过了不显示
        let todayStr  = Date().toString()
        let userDefault = UserDefaults.standard
        let recordeStr = userDefault.string(forKey: HPBUserDefaultsKey.todayShowAdKey)
        if todayStr == recordeStr{
            return false
        }else{
            return true
        }
    }
    
    //记录当天日期到本地
    func recordTodayDate(){
        let todayStr  = Date().toString()
        let userDefault = UserDefaults.standard
        userDefault.set(todayStr, forKey: HPBUserDefaultsKey.todayShowAdKey)
        userDefault.synchronize()
    }

}
