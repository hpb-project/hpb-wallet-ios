//
//  HPBAddressBookManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/18.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

struct HPBAddressBookManager {

    /// 获取存储在本地所有联系人
    static func getAllAddressBooks() -> Results<HPBAddressBookRealmModel>?{
        do {
            let realm = try Realm()
            let models =  realm.objects(HPBAddressBookRealmModel.self)
            return models
        }catch{
            return nil
        }
    }

    /// 删除本地所有数据
    static func deleteAllAddressBooks(){
        do {
            let realm = try Realm()
            let models = getAllAddressBooks()
            if let `models` = models{
                try realm.write {
                    realm.delete(models)
                }
            }
        }catch{
        }
    }
    
    
    /// 判断数据库中是否存在
    static func judgeExistInfo(_ model: HPBAddressBookRealmModel) -> Bool{
        do {
            let realm = try Realm()
            let models =  realm.objects(HPBAddressBookRealmModel.self).filter("addressStr = '\(model.addressStr.noneNull)' AND contractName = '\(model.contractName.noneNull)'")
            if models.isEmpty{
                return false
            }else{
                return true
            }
            
        }catch{
            return false
        }
    }
    
    
    
    /// 插入一个联系人信息
    static func insertContractInfo(_ model: HPBAddressBookRealmModel){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(model, update: .error)
            }
        }catch{
        }
    }
    
    /// 删除一个联系人信息
    static func deleteContractInfoBy(hash: String){
        do{
            let realm = try Realm()
            let model = realm.object(ofType: HPBAddressBookRealmModel.self, forPrimaryKey: hash)
            if let `model` = model{
                try realm.write {
                    realm.delete(model)
                }
            }
        }catch{
        }
    }
    
    // 修改一个联系人信息
    static func updateContractInfoBy(hash: String,address: String,name: String){
        do{
            let realm = try Realm()
            let model = realm.object(ofType: HPBAddressBookRealmModel.self, forPrimaryKey: hash)
            if let `model` = model{
                try realm.write {
                    model.setValue(address, forKey:  "addressStr")
                    model.setValue(name, forKey:  "contractName")
                }
            }
        }catch{
        }
    }
    
    //合并远程代码和本地代码
    static func mergeLocalAndCould(clouldModels: [HPBiCouldDataModel]){
        
        do {
            let realm = try Realm()
            for couldModel in clouldModels{
            let models =  realm.objects(HPBAddressBookRealmModel.self).filter("addressStr = '\(couldModel.addressContact)' AND contractName = '\(couldModel.mark)'")
                if models.isEmpty{
                    let realmModel = HPBAddressBookRealmModel()
                    realmModel.configModel(couldModel.addressContact, name: couldModel.mark)
                  insertContractInfo(realmModel)
                }
            }
        }catch{

        }
    }
    
    
    
    
   //从远程拉取云端保存的数据
    static func downloadiCouldList(success: @escaping (([HPBiCouldDataModel]) -> Void), failure: @escaping ((String?) -> Void)) {
        var allAddress: [String] = []
        if let models = HPBUserMannager.shared.walletInfos{
            for model in models{
                allAddress.append(model.addressStr.noneNull)
            }
        }
        let (requestUrl,param) = HPBAppInterface.getPullContractList(allWallets: allAddress)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                guard let resultDic = result as? [String: Any],let dataArr = resultDic["data"]  else{ return}
                guard let model =  HPBBaseModel.mp_effectiveModels(result: dataArr) as [HPBiCouldDataModel]? else{return}
                    success(model)
            }else{
                failure(errorMsg)
            }
        }
    }
    
    //Push数据到云端
    static func pushLocalListToCould(success: @escaping (() -> Void), failure: @escaping ((String?) -> Void)){
        
        var pushAllDatas: [Any] = []
        let  allWallets = HPBUserMannager.shared.walletInfos
        let allAddressBooks =  HPBAddressBookManager.getAllAddressBooks()
        var addressBooksDicArr: [NSDictionary] = []
        
        //拼接所有钱包地址(add1,add2,add3,...)
        if let `allWallets` = allWallets{
            if allWallets.count == 0{
                failure("")
                return
            }
            var stitchAddressStr = ""
            for wallet in allWallets{
               stitchAddressStr.append(wallet.addressStr.noneNull)
               stitchAddressStr.append(",")
            }
            stitchAddressStr.removeLast()
            pushAllDatas.append(stitchAddressStr)
        }
        //拼接所有本地数据
        if let `allAddressBooks` = allAddressBooks{
            for addressBook in allAddressBooks{
                let dic = ["addressContact": addressBook.addressStr.noneNull,"mark": addressBook.contractName.noneNull]
                addressBooksDicArr.append(dic as NSDictionary)
            }
            if !JSONSerialization.isValidJSONObject(addressBooksDicArr){
                failure("")
                return
            }
            //换成json的形式
            if let data = try? JSONSerialization.data(withJSONObject: addressBooksDicArr, options: .prettyPrinted),let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                pushAllDatas.append(jsonStr)
            }
        }
        let (requestUrl,param) = HPBAppInterface.getPushContractList(allDatas: pushAllDatas)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                success()
            }else{
               failure(errorMsg)
            }
        }
    }
}


struct HPBiCouldDataModel:  Mappable{
    init?(map: Map) {
    }
    var addressContact: String = ""
    var mark: String = ""
    
    // Mappable
    mutating func mapping(map: Map) {
        addressContact    <- map["addressContact"]
        mark               <- map["mark"]
    }
}



