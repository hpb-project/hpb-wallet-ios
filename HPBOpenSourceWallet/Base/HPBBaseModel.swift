//
//  HPBBaseModel.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/31.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

struct HPBBaseModel{
    
    var status: String? = "-1"
    var result: Any?
    var errorMsg: String? = ""
    
    init(responses: [Any]) {
        for (index,value) in responses.enumerated(){
            switch index{
            case 0:
                self.status = value as? String
            case 1:
                self.errorMsg = HPBStringUtil.transformFromJSON(value)
            case 2:
                 self.result = value
            default:
                debugLog("暂不处理")
            }
        }
    }
    
    
    static func mp_effectiveModels<T: Mappable>(result: Any?,key: String? = nil) -> [T]? {
        var results: Any?
        if key != nil{
            if let resultDic = result as? [String: Any]{
                results = resultDic[key.noneNull]
            }else{
                results = nil
            }
        }else{
            results = result
        }
        if let resultList = results as? [[String: Any]]{
            let modelArr = Mapper<T>().mapArray(JSONArray: resultList)
            return modelArr
        }
        return nil
    }
    
    
    static func mp_effectiveModel<T: Mappable>(result: Any?,key: String? = nil) -> T? {
        var resultData: Any?
        if key != nil{
            if let dic = result as? [String: Any]{
                resultData = dic[key.noneNull]
            }else{
                resultData = nil
            }
        }else{
            resultData = result
        }
        if let resultDic = resultData as? [String: Any]{
            let model = Mapper<T>().map(JSON: resultDic)
            return model
        }
        return nil
    }
}

// 将后台返回的sring或者数值类型转换为String
class HPBStringTransform: TransformType {
    typealias JSON = String
    typealias Object = String
    
    func transformToJSON(_ value: String?) -> String? {
        return value
    }
    
    func transformFromJSON(_ value: Any?) -> String? {
        if let st = value as? String {
            return st
        }else if let num = value as? NSNumber{
            let intValue = num.intValue
            let doubleValue = num.doubleValue
            //可能超过18位以后为负数
            if Double(intValue) == doubleValue && intValue > 0{
                return "\(intValue)"
            }else{
                return "\(doubleValue)"
            }
        }
        return nil
    }
}


