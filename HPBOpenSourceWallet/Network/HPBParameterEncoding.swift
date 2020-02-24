//
//  HPBParameterEncoding.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/28.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import Alamofire

struct JSONStringArrayEncoding: ParameterEncoding {
    
    public static var `default`: JSONStringArrayEncoding { return JSONStringArrayEncoding() }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        guard let array = parameters?["parameter"] as? [Any] else{
            return urlRequest!
        }
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest?.httpBody = data
        
        return urlRequest!
    }
}

