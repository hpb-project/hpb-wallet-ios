//
//  Date+Extension.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation

private var dateFormatterCache = [String: DateFormatter]()
let weekDaysStr = ["Common-week-7","Common-week-1","Common-week-2","Common-week-3","Common-week-4","Common-week-5","Common-week-6"]

public extension DateFormatter{
    
    /// 创建DateFormatter和修改DateFormatter.dateFormat同样耗费性能
    /// 参考文章：https://stackoverflow.com/questions/27321993/is-caching-a-nsdateformatter-application-wide-good-idea
    /// 获取 DateFormatter， 该方法会缓存DateFormatter，优化性能
    ///
    /// - Parameter key: formate
     static func cache(formate key: String) -> DateFormatter {
        var formatter = dateFormatterCache[key]
        if formatter == nil {
            let tempFormatter = DateFormatter()
            tempFormatter.dateFormat = key
            dateFormatterCache[key] = tempFormatter
            formatter = tempFormatter
        }
        return formatter!
    }
}

extension Date{
    
    ///获取星期几
    public func getWeekDay() -> String{
        let component = Calendar.current.dateComponents([.year,.month,.day,.weekday], from: self)
        if let dayIndex = component.weekday{
            return weekDaysStr[dayIndex - 1]
        }
        return ""
    }
    
    /// 创建一个只含有`年月`的日期字符串, 默认格式是"yyyy-MM"
    public func toMonthString() -> String {
        return toString(by: "yyyy-MM")
    }
    
    /// 通过给定的日期格式创建一个日期字符串, 默认的formate是"yyyy-MM-dd"
    public func toString(by formate: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter.cache(formate: formate)
        return dateFormatter.string(from: self)
    }
    
    /// 返回24小时制时间
    public func toHMSString(by formate: String = "HH:mm:ss") -> String {
        let dateFormatter = DateFormatter.cache(formate: formate)
        return dateFormatter.string(from: self)
    }
    
    
    /**
     //     和当前时间比较
     //     1）1分钟以内 显示        :    刚刚
     //     2）1小时以内 显示        :    X分钟前
     //     3）24小时以内 显示        :   X小时前
     //     4）今天或者昨天 显示      :    今天 09:30   昨天 09:30
     //     5) 今年显示        显示       :   2013/09/09
     //     6) 大于本年      显示    :    2013/09/09
     //
     //     @param dateString @"2016-04-04 20:21"
     //     @param formate    @"YYYY-MM-dd HH:mm"
     //     hh与HH的区别:分别表示12小时制,24小时制
     **/
    public func formatToCustom(monthFormat: String = "MM-dd HH:mm",yearFormate: String =  "YYYY-MM-dd HH:mm") -> String{
        
        var dateStr = ""
        let nowDate = Date()
        debugLog(DateFormatter.cache(formate: "HH:mm").string(from: nowDate))
        
        let component = Calendar.current.dateComponents([.year,.month,.day], from: nowDate)
        guard let todayStartDate = Calendar.current.date(from: component) else {return dateStr}
        guard let todayEndDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: todayStartDate) else {return  dateStr}
        guard let lastStartDate = Calendar.current.date(byAdding: Calendar.Component.day, value: -1, to: todayStartDate)else {return dateStr}
        let timeInterval = nowDate.timeIntervalSince(self)    //当前距给定的时间的时间差
        if  self >= lastStartDate && self < todayEndDate{
            if timeInterval < (60  * 5){                             //// 5分钟以内的
               dateStr = "Common-Now".localizable
            }else {                                          //// 在两天内的
                let isSameDay = self >= todayStartDate
                dateStr = (isSameDay ? "Common-Today".localizable : "Common-Yesterday".localizable) + DateFormatter.cache(formate: " HH:mm").string(from: self)
            }
        }
            
      /*
        let isSameDay = isSameDayOrYear(nowDate,"YYYY-MM-dd")
        if  isSameDay{
            let timeInterval = nowDate.timeIntervalSince(self)    //当前距给定的时间的时间差
            if timeInterval<60 * 5 {                          //// 5分钟以内的
                dateStr = "Common-Now".localizable
            }else {                                          //// 在两天内的
                dateStr = "Common-Today".localizable + " " + DateFormatter.cache(formate: "HH:mm").string(from: self)
            }
        }
        */
          else{
            let isSameYear = isSameDayOrYear(nowDate,"YYYY")
            if isSameYear{
                dateStr =  DateFormatter.cache(formate: monthFormat).string(from: self)
            }else{
                dateStr = DateFormatter.cache(formate: yearFormate).string(from: self)
            }
        }
        return dateStr
    }
    
    public func isSameDayOrYear(_ comPareDate: Date,_ formate: String = "YYYY-MM-dd") -> Bool{
        let dateFormatter = DateFormatter.cache(formate: formate)
        let need_yMd = dateFormatter.string(from: self)
        let now_yMd = dateFormatter.string(from: comPareDate)
        return need_yMd == now_yMd
    }
    
    
    
    //给定日期计算倒计时(天,时,分)
    static public func getCutDownStr(timeRemain: Double,formartStr: String =  "D-H-M") -> (String,String,String){
        let day = Int(timeRemain / (3600 * 24))
        let hour = (Int(timeRemain) % (3600 * 24)) / 3600
        let minute = (Int(timeRemain) % 3600 ) / 60
        return ("\(day)","\(hour)","\(minute)")
    }
    
}
