//
//  HPBAddressBookModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/18.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import RealmSwift

//realm 数据库
class HPBAddressBookRealmModel: Object{
    
    @objc dynamic var  addressStr: String?
    @objc dynamic var  contractName: String?
    @objc dynamic var  uuid: String?
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    func configModel(_ address: String,
                     name: String){
        self.addressStr = address
        self.contractName = name
        self.uuid = NSUUID.init().uuidString
    }
    
}
