//
//  HPBEncryptManager.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/24.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import RealmSwift

//realm 数据库
class HPBWalletRealmModel: Object{
    @objc dynamic var  addressStr: String?
    @objc dynamic var  kstoreName: String?
    @objc dynamic var  walletName: String?
    @objc dynamic var  mnemonics:  String?
    @objc dynamic var  tipInfo  :  String?
    @objc dynamic var  mappingState  :  String?
    @objc dynamic var  headName  :  String?
    @objc dynamic var  isColdAddress  :  String?
    
    override static func primaryKey() -> String? {
        return "addressStr"
    }
    
    func configModel(_ address: String,
                     kstoreName: String? = nil,
                     walletName: String,
                     mnemonics: String?,
                     tipInfo: String? = nil,
                     isColdAddress: String? = "0",
                     mappingState: String? = "0",
                     headName: String? = "common_head_1"){
        self.addressStr = address
        self.kstoreName = kstoreName
        self.walletName = walletName
        self.mnemonics = mnemonics
        self.tipInfo = tipInfo
        self.mappingState = mappingState
        self.headName = headName
        self.isColdAddress = isColdAddress
    }
}



