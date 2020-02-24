//
//  HPBStringUtil.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/31.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
/////切记：对于含有18个0的数字，应用默认Int最多支持19位数（Int64）2^64 - 1 到 -2^64 - 1,系统会先识别Int，
/// 对于double，float，int的最大值，可以参考
/// double（占8字节,指数部分占11位） 最大值为 2^1024-1 约 1后面308个0，精度小数点后16位
/// float（占4字节，指数部分占7位） 最大值 2^128-1 ，1后面38个0， 精度小数点后7-8位
///
///https://zhidao.baidu.com/question/10538690.html
///https://stackoverflow.com/questions/4706349/what-is-the-max-value-of-a-double-float-on-iphone

import Foundation

struct HPBStringUtil {
    
    
    /// 把返回的NSNumber类型的数字转化为String
    ///由于double由精度问题，所以大数据，后台必须返回string，且用NSDecimalNumber处理，
    /// - Parameter value: NSnumber或String
    /// - Returns: 返回String？
    static func transformFromJSON(_ value: Any?) -> String?{
        if let str = value as? String {
            return str
        }else if let num = value as? NSNumber{
            debugLog(num.doubleValue)
            return String(num.doubleValue)
        }
        return nil
    }
    
    static func noneNull(_ str: String?) -> String{
        if str != nil{
            return str!
        }else{
            return ""
        }
    }
    
}

extension HPBStringUtil{
    
    //HPB地址判断
    static func isValidAddress(_ str: String) -> Bool{
        if str.starts(with: "0x") && str.count == 42{
            if let _ = Data.fromHex(str){
                return true
            }
            return false
        }else{
            return false
        }
    }

    
    
}

extension HPBStringUtil{
    
    enum HPBOperationType {
        case adding,subtracting,multiplying,dividing
    }
    
    /// 去除,的string
    ///
    /// - Parameter value: 删除，
    /// - Returns:
    static func moneyFormatToString(value: String) -> String{
        
        if HPBNumberStyleUtil.share.style == .china{
            let formatStr = (value as NSString).replacingOccurrences(of: ",", with: "")
            return formatStr
        }else{
            let  deleteDotStr = (value as NSString).replacingOccurrences(of: ".", with: "")
            let formatStr = (deleteDotStr as NSString).replacingOccurrences(of: ",", with: ".")
            return formatStr
        }
    }
    

    
    ///输入的数字乘以18个0得到的字符串数字
    ///
    /// - Parameter value:
    /// - Returns: 乘以18个0后的结果
    static func converEthMoneyStr(_ value: String) -> String{
        return converDecimal(value, "1000000000000000000", 0, type: .multiplying)
    }
    
    
    /// ethmoney转化为金额格式化的string
    ///
    /// - Parameters:
    ///   - value: 要转化的string
    ///   - digitsNumber: 要保留的小数位数
    /// - Returns: 转化成功的string,加千分位置
    static func converHpbMoneyFormat(_ value: String,_ digitsNumber: Int16 = 8)-> String?{
        ///防止出现NAn这样的字样
        var formatValue: String = "0"
        if !value.isEmpty{
            formatValue = value
        }
        return self.converDecimal(formatValue, "1000000000000000000", digitsNumber, type: .dividing).addMicrometerLevel(digitsNumber: Int(digitsNumber))
    }
    
    ////金钱保留两位小数
    static func converCustomMoneyFormat(_ value: String)-> String?{
        ///防止出现NAn这样的字样
        var formatValue: String = "0"
        if !value.isEmpty{
            formatValue = value
        }
        return self.converDecimal(formatValue, "1", 2, type: .dividing).addMoneyDecimalNumber()
    }
    
    
    
    ////HRC 转账,自定义位数
    static func converCustomDigitsFormat(_ value: String, decimalCount: Int = 18, digitsNumber: Int16 = 8)-> String?{
        ///防止出现NAn这样的字样
        var formatValue: String = "0"
        if !value.isEmpty{
            formatValue = value
        }
        var decimalStr = "1"
        for _ in 0..<decimalCount{
           decimalStr.append("0")
        }
        
        return self.converDecimal(formatValue, decimalStr, digitsNumber, type: .dividing).addMicrometerLevel(digitsNumber: Int(digitsNumber))
    }
        
    
    
    /// +,-,*,/，然后还能保持精度
    ///
    /// - Parameters:value，value2，digitsNumber，type
    
    static func converDecimal(_ value: String,_ value2: String,_ digitsNumber: Int16 = 8,type: HPBOperationType,roundingMode: NSDecimalNumber.RoundingMode = .down)-> String{
        
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: roundingMode, scale: digitsNumber, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let decNumber = NSDecimalNumber(string: value)
        let decNumber2 = NSDecimalNumber(string: value2)
        
        switch type{
        case .dividing:
            let resultDN =  decNumber.dividing(by: decNumber2, withBehavior: roundingBehavior)
            return resultDN.stringValue
        case .multiplying:
            let resultDN =  decNumber.multiplying(by: decNumber2, withBehavior: roundingBehavior)
            return resultDN.stringValue
        case .adding:
            let resultDN =  decNumber.adding(decNumber2, withBehavior: roundingBehavior)
            return resultDN.stringValue
        case .subtracting:
            let resultDN =  decNumber.subtracting(decNumber2, withBehavior: roundingBehavior)
            return resultDN.stringValue
        }
    }
    
    
    /// 比较两个NSDecimalNumber
    ///
    ///     NSOrderedAscending = -1,    // < 升序
    ///     NSOrderedSame,              // = 等于
    ///     NSOrderedDescending   // > 降序
    static func compare(_ value: String,_ value2: String) -> ComparisonResult{
        let decNumber = NSDecimalNumber(string: value)
        let decNumber2 = NSDecimalNumber(string: value2)
        let result =  decNumber.compare(decNumber2)
        return result
    }
    
    
    static func attributeStr(_ str1: String, str2: String = " HPB",color: UIColor = UIColor.paNavigationColor) -> NSAttributedString{
         let attrString1 = NSAttributedString(string: str1, attributes: [.font: UIFont.systemFont(ofSize: 32), .foregroundColor: color])
         let attrString2 = NSAttributedString(string: str2, attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: color])
        let attribut = NSMutableAttributedString(attributedString: attrString1)
        attribut.append(attrString2)
        return attribut
    }
    
}


