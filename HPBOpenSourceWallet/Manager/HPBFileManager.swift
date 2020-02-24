//
//  HPBFileManager.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/23.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import CryptoSwift

struct  HPBFileManager{
  
   static let calendar = Calendar(identifier: .iso8601)
    
    ///获取document文件夹
   static func getDocumentDirectory() -> String{
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return userDir
    }
    
    ///获取网络cache文件夹
    static func getNetworkCacheDirectory() -> String{
        let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let cacheDirect = cacheDir + "/netwokCache/"
        creatDirectory(path: cacheDirect)
        return cacheDirect
    }
    
    ///获取头像存储文件夹
    static func getHeadImageDirectory() -> String{
        let documentDir = getDocumentDirectory()
        let headImageDirectoryPath = documentDir + "/headImage/"
        creatDirectory(path: headImageDirectoryPath)
        return headImageDirectoryPath
    }
    
    
    ///获取kstore文件地址
    static func getKstoreDirectory() -> String{
        let documentDir = getDocumentDirectory()
        let KstoreDirectoryPath = documentDir + "/keystore/"
        creatDirectory(path: KstoreDirectoryPath)
        return KstoreDirectoryPath
    }
    
    //获取realm数据库文件夹
    static func getRealmDataBasePath()-> String{
        let infoName = "walletInfo.realm"
        let directory = getDocumentDirectory() + "/walletInfo/"
        let infosPath = directory + infoName
        creatDirectory(path: directory)
        return infosPath
    }
    
    ///创建kstore文件夹
    private static func creatDirectory(path: String){
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                showBriefMessage(message: "createDirectory failed", view: AppDelegate.shared.window)
            }
        }
    }
}

extension HPBFileManager{
    
    //生成唯一地址
    static func generateFileName(address: Data, date: Date = Date(), timeZone: TimeZone = .current) -> String {
        return "UTC--\(filenameTimestamp(for: date, in: timeZone))--\(address.hexString)"
    }
    
    private static func filenameTimestamp(for date: Date, in timeZone: TimeZone = .current) -> String {
        var tz = ""
        let offset = timeZone.secondsFromGMT()
        if offset == 0 {
            tz = "Z"
        } else {
            tz = String(format: "%03d00", offset/60)
        }
        
        let components = calendar.dateComponents(in: timeZone, from: date)
        guard let year = components.year,let month = components.month,let day = components.day,
        let hour = components.hour,let minute = components.minute,let second = components.second,
            let nanosecond = components.nanosecond
            else{
                return Date().toString(by: "yyyy-MM-dd-HH:mm:ss")
                
        }
        return String(format: "%04d-%02d-%02dT%02d-%02d-%02d.%09d%@", year, month, day, hour, minute, second, nanosecond, tz)
    }
}

