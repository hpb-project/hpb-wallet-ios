//
//  HPBCacheManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/16.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

//缓存本地key
struct HPBCacheKey{
    static let carouselCacheKey           = "carousel_cache"
    static let expressCacheKey            = "express_cache"
    static let newsCacheKey               = "news_cache"
    static let messageCacheKey            = "message_cache"
    static let transferRecordCacheKey     = "transfer_record_cache"
    static let dAppRecordCacheKey         = "dapp_record_cache"
    static let mainPageTokenCacheKey         = "main_page_token_cache"
}


struct  HPBCacheManager{
    
    //缓存数据
    static func setCacheModel<T: Mappable>(_ model: T,name: String){
        let path = HPBFileManager.getNetworkCacheDirectory() + name
        let fileUrl =  URL(fileURLWithPath: path)
        do{
            let json = model.toJSONString()
            try json?.write(to: fileUrl, atomically: true, encoding: .utf8)
        }catch{
            
        }
    }
    
    static func setCacheModels<T: Mappable>(_ model: [T],name: String){
        let path = HPBFileManager.getNetworkCacheDirectory() + name
        let fileUrl =  URL(fileURLWithPath: path)
        do{
            let json = model.toJSONString()
            try json?.write(to: fileUrl, atomically: true, encoding: .utf8)
        }catch{
            
        }
    }
    
    //获取缓存
    static func getCacheModels<T: Mappable>(_ name: String) -> [T]? {
        let filePath = HPBFileManager.getNetworkCacheDirectory() + name
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8){
        return [T].init(JSONString: str)
        }
        return nil
    }
    
    static func getCacheModel<T: Mappable>(_ name: String) -> T? {
        let filePath = HPBFileManager.getNetworkCacheDirectory() + name
        if let str = try? String(contentsOfFile: filePath, encoding: .utf8){
            return T.init(JSONString: str)
        }
        return nil
    }

}
