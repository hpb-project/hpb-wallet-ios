//
//  HPBNetwork.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import Alamofire

typealias HPBResponseBlock = (_ result: Any?,_ errorMsg: String?) -> Void

struct HPBNetwork{
    
    public static let `default` = HPBNetwork()
    public let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        configuration.httpMaximumConnectionsPerHost = 4
        return SessionManager(configuration: configuration)
    }()
    
    
    ///普通网络请求
    @discardableResult
    public func request(
        _ url: URLConvertible,
        method: HTTPMethod = .post,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONStringArrayEncoding.default,
        headers: HTTPHeaders? = nil,complation:  @escaping HPBResponseBlock) -> DataRequest{
        let dataRequest = SessionManager.default.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
            ).responseJSON(){ dataResponse in
                self.printRequestURL(url, parameters)  //打印请求地址
                self.responseConvert(response: dataResponse){
                    complation($0,$1)
                }
        }
        return dataRequest
    }
    
    ///表单上传图片
    public func upload(_ url: URLConvertible,
                       parameters: Parameters,
                       imageDatas: [Data],
                       complation:  @escaping HPBResponseBlock){
        SessionManager.default.upload(multipartFormData:{ (formData) in
            for key in parameters.keys{
                if let str = parameters[key] as? String,let data = str.data(using: .utf8){
                    formData.append(data, withName: key)
                }
            }
            for data in imageDatas{
                formData.append(data, withName: "files", fileName: Date().toString(by: "yyyy-MM-dd-HH:mm:ss") + ".png", mimeType: "image/png")
            }
        }, to: url) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON(){ (response) in
                    self.responseConvert(response: response){
                        complation($0,$1)
                    }
                }
            case .failure(let error):
                debugLog(error)
                if NetworkReachabilityManager.init()?.isReachable == false{
                    complation(nil,"Common-NO-Network".localizable)
                }else{
                    complation(nil,HPBError.commonErrorMessage.localizable)
                }
            }
        }
    }
    
    
    fileprivate func responseConvert(response: DataResponse<Any>,complation: @escaping HPBResponseBlock){
        switch response.result{
        case .success(let response):
            guard let `response` = response as? [Any] else{return }
            let baseModel = HPBBaseModel(responses: response)
            if baseModel.status.noneNull == "000000"{
                complation(baseModel.result,nil)
            }else{
                complation(nil,HPBError.errorMessage(withStatusCode: baseModel.errorMsg.noneNull))
            }
        case .failure(let error):
            debugLog(error)
            if NetworkReachabilityManager.init()?.isReachable == false{
                 complation(nil,"Common-NO-Network".localizable)
            }else{
                 complation(nil,HPBError.commonErrorMessage.localizable)
            }
           
        }
    }
    
    
    
    fileprivate func printRequestURL(_ url: URLConvertible,_ parameters: Parameters?){
        #if DEBUG
        guard let array = parameters?["parameter"] as? [Any] else{ return}
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: [])else{return}
        let jsonStr = String(data: data, encoding: String.Encoding.utf8)
        debugLog(">>>接口请求:👉👉👉👉👉👉",
                 (url as? String).noneNull,
                 ">>>参数👇👇👇👇",jsonStr.noneNull)
        #endif
    }
}


class HPBError: Error{
    
   static let  commonErrorMessage =  "Network-Datarequest-Faile"
    
    enum ErrorMessage: String{
        case errorBlockInfo   = "40101"
        case invalueAddress   = "10104"
        case invalueTradHash  = "10105"
        case invalueBlockHash = "10106"
        case errorParam       = "10101"
        
        var errorMsg: String{
            switch self {
            case .errorBlockInfo:
                return "Network-Error-Block-Error"
            case .invalueAddress:
                return "Network-Error-Invalue-Address"
            case .invalueTradHash:
                return "Network-Error-Invalue-TradeHash"
            case .invalueBlockHash:
                return "Network-Error-Invalue-BlockHash"
            case .errorParam:
                return "Network-Error-Error-Param"
            }
        }
    }
    
    enum Error32000Msg: String{
        case nonceTooLow      = "nonce too low"
        case errorPacking     = "replacement transaction underpriced"
        case insufficientFunds = "insufficient funds for gas * price + value"
        var errorMsg: String{
            switch self {
            case .nonceTooLow:
                return "Network-Error-Nonce-Low"
            case .errorPacking:
                return "Network-Error-Pack"
            case .insufficientFunds:
                return "Network-Error-No-Funds"
            }
        }
    }
    
    static func errorMessage(withStatusCode code: String) -> String {
        
        var errorMessage = ""
        //目前只对枚举中的做判断，后续可以自行添加
        if let errorMsgEnum = ErrorMessage(rawValue: code){
            errorMessage = errorMsgEnum.errorMsg.localizable
        }else{
            if let e3200Msg = Error32000Msg.init(rawValue: code){
                errorMessage = e3200Msg.errorMsg.localizable
            }else{
                errorMessage = code
            }
        }
        return errorMessage
    }
    
}


