//
//  HPBTokenManager.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/11.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import RealmSwift

class HPBTokenManager{
    static let share = HPBTokenManager()
      var storeArr: [String] = []
    
    /// 记录tokenID到本地
     func setRecordTokenIDsUserDefault(){
        //防止漏掉HPB
        if !storeArr.contains("HPB"){
            storeArr.insert("HPB", at: 0)
        }
        //此步骤是为了防止重复
        var elemnetArr: [String] = []
        for element in storeArr{
            if !elemnetArr.contains(element){
                elemnetArr.append(element)
            }
        }
        storeArr = elemnetArr
        UserDefaults.standard.set(elemnetArr, forKey: HPBUserDefaultsKey.tokenManagerKey)
        UserDefaults.standard.synchronize()
    }
    
    
    
     func initLocalRecordTokenIDs(){
        if let recordTokens = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.tokenManagerKey) as? [String]{
            storeArr = recordTokens
        }else{
             storeArr = []
        }
    }

    
 
    
    @discardableResult
    func sortSelectTokenID(fromID: String,toID:String) -> [String]{
        if self.storeArr.contains(fromID) &&  self.storeArr.contains(toID){
            var recordFromIndex: Int = -1
            var recordToIndex: Int = -1
            if let fromIndex =   self.storeArr.index(of: fromID){
                recordFromIndex = fromIndex
            }else {
                return self.storeArr
            }
            if let toIndex =  self.storeArr.index(of: toID){
                recordToIndex = toIndex
            }else {
                return self.storeArr
            }
            self.storeArr[recordFromIndex] = toID
            self.storeArr[recordToIndex] = fromID
            setRecordTokenIDsUserDefault()
        }
        return self.storeArr
    }
    
   
    
}

extension HPBTokenManager{
    
    /// 删除之前保存的id,但是后台删除了,就在本地删除掉
    func compareRemoveDeleteToken(_ models: [HPBTokenManagerModel]) {
        var allIDs: [String] = []
        /// 代币管理界面的所有id
        for model in models{
            allIDs.append(model.tokenID)
        }
        storeArr = storeArr.filter {
            let selectCondition = allIDs.contains($0) || $0 == "HPB"
            return selectCondition
        }
        
        setRecordTokenIDsUserDefault()
    }
    
    
    /// 获取代币管理界面排序后的model
    func  sortTokenModel(_ models: [HPBTokenManagerModel]) -> [HPBTokenManagerModel] {
        var finialModels: [HPBTokenManagerModel] = []
        var allIDs: [String] = []
        /// 代币管理界面的所有id
        for model in models{
            allIDs.append(model.tokenID)
        }
        
        //排序后的models
        for storeId in storeArr{
            let filterModels =  models.filter {
                return storeId == $0.tokenID
            }
            if !filterModels.isEmpty{
                var oneModel = filterModels[0]
                oneModel.isCanSort = true
                finialModels.append(oneModel)
            }
            /// 删除排过序的
            if  let removeIndex = allIDs.index(of: storeId){
                allIDs.remove(at: removeIndex)
            }
        }
        
        for otherId in allIDs{
            let filterModels =  models.filter {
                return otherId == $0.tokenID
            }
            if !filterModels.isEmpty{
                var oneModel = filterModels[0]
                oneModel.isCanSort = false
                finialModels.append(filterModels[0])
            }
        }
        
        return finialModels
    }
    
    
    
}

extension HPBTokenManager{
    
    func getRecordModels(_ newModels: [HPBTokenManagerModel]) -> [HPBTokenManagerModel]{
        
        /// 第一次下载的时候先保存在本地
        if self.storeArr.isEmpty{
            newModels.forEach {
                self.storeArr.append($0.tokenID)
            }
            setRecordTokenIDsUserDefault()
        }
        
        //从老的缓存管理列表中查询(比代币管理多个HPB)
        if let localModels = HPBCacheManager.getCacheModels(HPBCacheKey.mainPageTokenCacheKey) as  [HPBTokenManagerModel]?{
            /// 添加新增的tokenID
            var allLocalIDs: [String] = []
            localModels.forEach {
                allLocalIDs.append($0.tokenID)
            }
            var newModelsIDs: [String] = []
            newModels.forEach {
                newModelsIDs.append($0.tokenID)
            }
            let addModels = newModelsIDs.filter{
                return !allLocalIDs.contains($0)
            }
            addModels.forEach {
                self.storeArr.append($0)
            }
            /// 删除后台删除减少的
            compareRemoveDeleteToken(newModels)
        }
        
        // 把最新的保存在本地
        HPBCacheManager.setCacheModels(newModels, name: HPBCacheKey.mainPageTokenCacheKey)
        
        //排序后的models
        var storeModels: [HPBTokenManagerModel] = []
        for storeId in storeArr{
            //从缓存列表中查找
            if let model = getTokenManagerModelBy(storeId){
                storeModels.append(model)
            }
        }
        return storeModels
    }
    
    func getTokenManagerModelBy(_ id: String) -> HPBTokenManagerModel? {
        
        //从主页列表中查询
        if let tokenManagerModels = HPBCacheManager.getCacheModels(HPBCacheKey.mainPageTokenCacheKey) as  [HPBTokenManagerModel]?{
            let filterModels =  tokenManagerModels.filter {
                return id == $0.tokenID
            }
            if !filterModels.isEmpty{
                return filterModels[0]
            }
        }
        return nil
    }
}
