//
//  HPBStrSinatureManager.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/11/5.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import RealmSwift

struct HPBStrSinatureManager {
    
    typealias WalletManagerResult = (state: Bool,errorMsg: String? )
    typealias WalletDataResult    = (state: Bool,errorMsg: String?,data:Data?)
    
    /// 获取存储在本地所有记录
       static func getAllRecordInfo() -> Results<HPBDigitalSinatureModel>?{
           do {
               let realm = try Realm()
               let models =  realm.objects(HPBDigitalSinatureModel.self)
               return models
           }catch{
               return nil
           }
       }
       
    
    //获取指定地址的生成记录
      static func getRecordListInfo(address: String) -> Results<HPBDigitalSinatureModel>?{
          do {
              let realm = try Realm()
              let models =  realm.objects(HPBDigitalSinatureModel.self).filter("addressStr = '\(address)'")
              return models
          }catch{
              return nil
          }
      }
    
    

       

       /// 保存新创建数据
       static func storeRecordInfo(_ walletModel: HPBDigitalSinatureModel) -> WalletManagerResult{
           
           do {
               let realm = try Realm()
               try realm.write {
                realm.add(walletModel, update: .all)
               }
               return WalletManagerResult(true,nil)

           }catch{
              return WalletManagerResult(false,"Common-Save-Wallet-Faile".localizable)
           }
       }
    
    
    
    /// 删除
    static func deleteRecordInfoBy(hash: String) -> Bool{
        if hash.isEmpty{
            return false
        }
        do{
            let realm = try Realm()
            let model = realm.object(ofType: HPBDigitalSinatureModel.self, forPrimaryKey: hash)
            if let `model` = model{
                try realm.write {
                    realm.delete(model)
                }
                  return true
            }
             return false
        }catch{
              return false
        }
    }
}
