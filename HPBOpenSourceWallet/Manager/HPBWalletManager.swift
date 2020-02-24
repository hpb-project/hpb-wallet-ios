//
//  HPBOpenSourceWalletManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/8.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//  钱包存放在本地的WalletInfo文件下的realm数据库中

import Foundation
import AESCrypto
import HPBWeb3SDK
import RealmSwift


struct HPBWalletManager {

    typealias WalletManagerResult = (state: Bool,errorMsg: String? )
    typealias WalletDataResult    = (state: Bool,errorMsg: String?,data:Data?)
    
    /// 获取存储在本地所有钱包基本信息
    static func getAllWalletInfo() -> Results<HPBWalletRealmModel>?{
        do {
            let realm = try Realm()
            let models =  realm.objects(HPBWalletRealmModel.self)
            return models
        }catch{
            return nil
        }
    }
    
    //获取映射钱包列表
    static func getMappingListWalletInfo() -> Results<HPBWalletRealmModel>?{
        let models = getAllWalletInfo()
        let mappingModels = models?.filter("mappingState = '1'")
        return mappingModels
    }
    
    /// 获取指定地址的walletModel
    static func getWalletInfoBy(address: String) ->  HPBWalletRealmModel?{
        do {
            let realm = try Realm()
            let model = realm.object(ofType: HPBWalletRealmModel.self, forPrimaryKey: address)
           return model
        }catch{
            return nil
        }
        
    }
    

    /// 保存新创建（导入）的新钱包数据model
    static func storeWalletInfo(_ walletModel: HPBWalletRealmModel)-> WalletManagerResult{
        
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
    
    /// 保存当前钱包的地址
    static func storeCurrentWalletAddress(_ addressStr: String?){
           UserDefaults.standard.set(addressStr, forKey: HPBUserDefaultsKey.currentWalletAddressKey)
    }
    
    
    /// 获取当前钱包数据model
    static func getCurrentWalletInfo() -> HPBWalletRealmModel?{
        if let address =  UserDefaults.standard.object(forKey: HPBUserDefaultsKey.currentWalletAddressKey) as? String{
            return getWalletInfoBy(address: address)
        }else if let models = HPBWalletManager.getAllWalletInfo(){
            if models.count > 0{
                return models[0]
            }
        }
        return nil
    }
    
}


extension HPBWalletManager{
    
    /// 随机生成助记词
    static func generateMnemonics(complete: ((Data,String)->Void)? ) -> WalletManagerResult{
        guard let mnemonicStr = try? BIP39.generateMnemonics(bitsOfEntropy: 128, language: BIP39Language.english),let mnemonic = mnemonicStr else{
            return WalletManagerResult(false,"Common-Generate-Wallet-Faile".localizable)
        }
        guard let seed = BIP39.seedFromMmemonics(mnemonic, language: BIP39Language.english) else{
             return WalletManagerResult(false,"Common-Generate-Wallet-Faile".localizable)
        }
        let privateKey = seed.sha256()
        complete?(privateKey,mnemonic)
        return WalletManagerResult(true,nil)
    }
    
    
    /// 通过privateKey和密码生成Kstore文件并存储在本地
    static func generateKstoreFileBy(_ privateKey: Data,password: String,complete: ((String,String)->Void)?) -> WalletManagerResult{
        
        guard let ethereumKeystore = try? HPBKeystoreV3(privateKey: privateKey, password: password),let ks = ethereumKeystore else{
            return WalletManagerResult(false,"Common-Generate-KS-Faile".localizable)
        }
        guard  let keydata = try? JSONEncoder().encode(ks.keystoreParams)
            else{
            return WalletManagerResult(false,"Common-Get-KS-Faile".localizable)
        }
        guard let adress = ks.getAddress() else{
           return WalletManagerResult(false,"Common-Get-KS-Faile".localizable)
        }
        //创建普通的keystore文件
        let filename = HPBFileManager.generateFileName(address: adress.addressData)
        if FileManager.default.createFile(atPath: HPBFileManager.getKstoreDirectory() + filename, contents: keydata, attributes: nil){
            complete?(filename,adress.address.lowercased())
            return WalletManagerResult(true,nil)
        }else{
            return  WalletManagerResult(false,"Common-Generate-KS-Faile".localizable)
        }
    }
    
    
}

extension HPBWalletManager{
    
    private static func getLocalKstoreData(_ kstoreName: String) -> WalletDataResult{
        let kstorePath  =  HPBFileManager.getKstoreDirectory().appending(kstoreName)
        guard let fileData =  FileManager.default.contents(atPath: kstorePath) else{
            return WalletDataResult(false,"Common-File-Read-Faile".localizable,nil)
        }
         return WalletDataResult(true,nil,fileData)
    }
    
    /// 导出Kstore文件
    static func exportKstore(_ kstoreName: String,password: String) -> WalletDataResult{
        
        //先看是否能导出私钥
        let privateKeyResult = exportPrivateKey(kstoreName, password: password)
        if privateKeyResult.state == false{
            return privateKeyResult
        }
        let getDataResult = HPBWalletManager.getLocalKstoreData(kstoreName)
        guard let fileData = getDataResult.data else{
            return getDataResult
        }
        return WalletDataResult(true,nil,fileData)
    }
    
    
    /// 导出私钥
    static func exportPrivateKey(_ kstoreName: String,password: String) -> WalletDataResult{
        
        let result = HPBWalletManager.getLocalKstoreData(kstoreName)
        guard let fileData = result.data else{
            return result
        }
        let ethv3 = HPBKeystoreV3(fileData)
        guard let ethAddress = ethv3?.getAddress() else {
            return WalletDataResult(false,"Common-GetAddress-Faile".localizable,nil)
        }
        guard let data = try? ethv3?.UNSAFE_getPrivateKeyData(password: password, account: ethAddress)
            else{
                return WalletDataResult(false,"WalletHandel-Password-Error".localizable,nil)
        }
         return WalletDataResult(true,nil,data)
    }
}


extension HPBWalletManager{


    /// 删除钱包信息，并将新的存储在本地 和 移除kstore文件
    static func deleteWallet(_ kStoreName: String,address: String,password: String) -> WalletManagerResult{
        let result = HPBWalletManager.exportKstore(kStoreName, password: password)
        if result.state == false{
            return WalletManagerResult(false,result.errorMsg)
        }
        //移除kstore文件 和 对应的信息文件
        let kstorePath = HPBFileManager.getKstoreDirectory().appending(kStoreName)
        do{
            if HPBWalletManager.deleteWalletInfoBy(address: address){
                guard let walletModels = HPBWalletManager.getAllWalletInfo() else{
                    return WalletManagerResult(false,"Common-GetWalletInfo-Faile".localizable)
                }
                // 如果删除后还有其他的账户，就选择当前账户为数组中的第一个，
                //如果是最后一个，就删除当前的currentInfo
                if walletModels.count > 0{
                    HPBWalletManager.storeCurrentWalletAddress(walletModels[0].addressStr)
                }else{
                    HPBWalletManager.storeCurrentWalletAddress(nil)
                }
                //删除kstore文件
                try FileManager.default.removeItem(atPath: kstorePath)
                return WalletManagerResult(true,nil)
            }else{
                return WalletManagerResult(false,"Common-Delete-Faile".localizable)     //逻辑删除失败
            }
        }catch{
            return WalletManagerResult(false,"Common-Delete-Kstore-Faile".localizable)    //删除本地Kstore文件失败
        }
        
    }

    /// 删除冷钱包
    static func deleteColdWallet(_ address: String) -> WalletManagerResult{
        if HPBWalletManager.deleteWalletInfoBy(address: address){
            guard let walletModels = HPBWalletManager.getAllWalletInfo() else{
                return WalletManagerResult(false,"Common-GetWalletInfo-Faile".localizable)
            }
            // 如果删除后还有其他的账户，就选择当前账户为数组中的第一个，
            //如果是最后一个，就删除当前的currentInfo
            if walletModels.count > 0{
                HPBWalletManager.storeCurrentWalletAddress(walletModels[0].addressStr)
            }else{
                HPBWalletManager.storeCurrentWalletAddress(nil)
            }
            return WalletManagerResult(true,nil)
        }else{
            return WalletManagerResult(false,"Common-Delete-Faile".localizable)     //逻辑删除失败
        }
    }
    
    
    /// 根据地址删除本地存储的钱包信息
    private static func deleteWalletInfoBy(address: String) -> Bool{
        do{
            let realm = try Realm()
            let model = realm.object(ofType: HPBWalletRealmModel.self, forPrimaryKey: address)
            if let `model` = model{
                try realm.write {
                 realm.delete(model)
                }
                return true
            }
            return false
        }catch{
            showBriefMessage(message: "Common-Delete-Faile".localizable) //"本地储存出错！"
            return false
        }
    }

}


extension HPBWalletManager{
    
    fileprivate static func updateWallet(address: String,type: String,kstoreName: String = "",walletName: String = "",mnemonics: String? = nil) -> WalletManagerResult{
       
        if address.isEmpty{
            return WalletManagerResult(false,"Common-Address-Faile".localizable)
        }
        do{
            let realm = try Realm()
            let model = realm.object(ofType: HPBWalletRealmModel.self, forPrimaryKey: address)
            if let `model` = model{
                switch type{
                case "Mnemonics":
                    try realm.write {
                        model.setValue(nil, forKey: "mnemonics")
                    }
                case "kStoreName":
                    try realm.write {
                        model.setValue(kstoreName, forKey: "kstoreName")
                    }
                case "walletName":
                    try realm.write {
                       let headerName =  HPBHeaderManager.randomGeneratHeadimageName(walletName, address: address)
                        model.setValue(walletName, forKey: "walletName")
                        model.setValue(headerName, forKey: "headName")
                    }
                   
                case "MnemonicsAndkStoreName":
                    try realm.write {
                        model.setValue(kstoreName, forKey: "kstoreName")
                        model.setValue(mnemonics, forKey: "mnemonics")
                    }
                case "mappingState":
                    try realm.write {
                        model.setValue(walletName, forKey: "mappingState")
                    }
                default:
                    break
                }
                return WalletManagerResult(true,nil)
            }
            return WalletManagerResult(false,"Common-Address-Faile".localizable)
        }catch{
            return WalletManagerResult(false,"Common-Update-Faile".localizable)
        }
    }
    
    /// 更新钱包助记词通过给定的地址
    static func updataWalletMnemonics(address: String)-> WalletManagerResult{
        return  HPBWalletManager.updateWallet(address: address, type: "Mnemonics")
    }
    
    /// 更新钱包Kstore通过给定的地址
    static func updataWalletKstoreName(address: String,kstoreName: String)-> WalletManagerResult{
        return  HPBWalletManager.updateWallet(address: address, type: "kStoreName",kstoreName: kstoreName)
    }
    
    /// 更新钱包名称通过给定的地址
    static func updataWalletName(address: String,walletName: String)-> WalletManagerResult{
        return  HPBWalletManager.updateWallet(address: address, type: "walletName",walletName: walletName)
    }
    
    /// 更新是否映射的状态位通过给定的地址
    static func updataWalletMappingState(address: String,mappingState: String = "1")-> WalletManagerResult{
        return  HPBWalletManager.updateWallet(address: address, type: "mappingState",walletName: mappingState)
    }
    
    /// 更新钱包助记词 + KStoreName通过给定的地址
    static func updataWalletMnemonicsAndKstoreName(address: String,mnemonics: String?,kstoreName: String)-> WalletManagerResult{
        return  HPBWalletManager.updateWallet(address: address, type: "MnemonicsAndkStoreName",kstoreName:kstoreName, mnemonics: mnemonics)
    }
    
    /// 更新钱包密码给定的地址
    static func updataWalletPassword(_ walletModel: HPBWalletRealmModel, oldPassword: String,newPassword: String,complation:((Bool,String?)->Void)?)-> WalletManagerResult{
        
        //walletModel 是指针类型，别的地方更改后，这里也会变
        let oldFileName = walletModel.kstoreName
        //先取出本地加密的助记词，用新密码生成新的加密助记词
        var newMnemonics: String? = nil
        if !walletModel.mnemonics.noneNull.isEmpty{
            let decryptMne =  AESCrypt.decrypt(walletModel.mnemonics.noneNull, password: oldPassword)
            let mnemosArr = decryptMne?.components(separatedBy: " ")
            if mnemosArr?.count != 12{    //为保持正确性更高，判断是否能生成12个单词的助记词字符串
                return WalletManagerResult(false,"WalletHandel-Password-Error".localizable)
            }
            newMnemonics = AESCrypt.encrypt(decryptMne, password: newPassword)
        }
        
        //导出私钥
        let  privateKeyResult = HPBWalletManager.exportPrivateKey(walletModel.kstoreName.noneNull, password: oldPassword)
        guard let privateKeyData = privateKeyResult.data else{
            return WalletManagerResult(false,privateKeyResult.errorMsg)
        }
        //生成新的keystore文件
        return self.importByPrivateKey(privateKeyData, password: newPassword,isUpdataPassword: true) {
            //更新加密助记词+ 新的kstore文件
            let updataResult  = HPBWalletManager.updataWalletMnemonicsAndKstoreName(address: walletModel.addressStr.noneNull, mnemonics: newMnemonics, kstoreName: $0.kstoreName.noneNull)
            if updataResult.state{
                //移除先前的kstore文件，并回掉
                try? FileManager.default.removeItem(atPath:  HPBFileManager.getKstoreDirectory() + oldFileName.noneNull)
                complation?(true,nil)
            }else{
                //更新MnemonicsAndKstoreName失败
                complation?(false,updataResult.errorMsg)
            }
        }
    }
    
}


extension HPBWalletManager{
    
    
    /// 导入私钥
    static func importByPrivateKey(_ privateData: Data,password: String,tipInfo: String? = nil,isMapping:String? = "0",isUpdataPassword: Bool = false,success:((HPBWalletRealmModel)->Void)?) -> WalletManagerResult{
        do {
            let keystoreV3 = try HPBKeystoreV3(privateKey: privateData, password: password)
            guard let kV3 = keystoreV3 else {
                return WalletManagerResult(false,"WalletHandel-InCollect-PK".localizable)
            }
            guard let keydata = try? JSONEncoder().encode(kV3.keystoreParams)else{
                return WalletManagerResult(false,"WalletHandel-Import-Faile".localizable)
            }
            guard let adress = kV3.getAddress() else{
                return WalletManagerResult(false,"WalletHandel-Import-Faile".localizable)
            }
            
            //更新密码的时候不做判断
            if let model = self.getWalletInfoBy(address: adress.address.lowercased()){
                if isUpdataPassword == false{
                    return WalletManagerResult(false,"DQQBYCZ" + "###" + adress.address.lowercased() + "###" + model.mappingState.noneNull)
                }
            }
            //创建普通的keystore文件
            let filename = HPBFileManager.generateFileName(address: adress.addressData)
            if FileManager.default.createFile(atPath: HPBFileManager.getKstoreDirectory() + filename, contents: keydata, attributes: nil){
                
                //更新密码的时候钱包编号不递增
                var walletNoStr = ""
                if isUpdataPassword == false{
                    walletNoStr = HPBWalletNumnerManager.getRecentNumner()
                }
               let walletname = "WalletHandel-New-Wallet".localizable + walletNoStr
               let walletModel = HPBWalletRealmModel()
                walletModel.configModel(adress.address,
                                        kstoreName: filename,
                                        walletName: walletname,
                                        mnemonics: nil,
                                        tipInfo:tipInfo,
                                        mappingState: isMapping,
                                        headName: HPBHeaderManager.randomGeneratHeadimageName(walletname, address: adress.address))
                success?(walletModel)
                return WalletManagerResult(true,nil)
            }else{
                return WalletManagerResult(false,"WalletHandel-Keystore-Creat-Faile".localizable)
            }
        }catch{
            return WalletManagerResult(false,"WalletHandel-Import-Faile".localizable)
        }
    }
    
    
    
   /// 导入助记词
    static func importByMnemonics(mmemonics: String,password: String,tipInfo:String? = nil,success:((HPBWalletRealmModel)->Void)?) -> WalletManagerResult{
        guard let seed =  BIP39.seedFromMmemonics(mmemonics, language: BIP39Language.english) else{
            return WalletManagerResult(false,"WalletHandel-Import-Faile".localizable)
        }
        return HPBWalletManager.importByPrivateKey(seed.sha256(), password: password,tipInfo: tipInfo) {
            $0.mnemonics = nil  //通过助记词导入的时候，不保存助记词
            success?($0)
        }
    }
    
    
    ///导入kstore文件
    static func importByKstore(kstore: String,password: String,isMapping:String? = "0",success:((HPBWalletRealmModel)->Void)?) -> WalletManagerResult{
        guard let keystoreV3 = HPBKeystoreV3(kstore),let address = keystoreV3.getAddress() else {
            return WalletManagerResult(false,"WalletHandel-Keystore-Faile".localizable)
        }
        do {
            let privateKeyData =  try keystoreV3.UNSAFE_getPrivateKeyData(password: password, account: address)
            return HPBWalletManager.importByPrivateKey(privateKeyData, password: password,isMapping: isMapping){
                success?($0)
            }
        }catch{
            return WalletManagerResult(false,"WalletHandel-Password-Error".localizable)
        }
    }
    
}


