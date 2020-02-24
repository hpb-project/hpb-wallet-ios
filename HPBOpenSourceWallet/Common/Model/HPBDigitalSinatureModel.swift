//
//  HPBDigitalSinatureModel.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/11/5.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import RealmSwift

//realm 数据库
class HPBDigitalSinatureModel: Object{
    
    @objc dynamic var  uuid: String = NSUUID.init().uuidString
    @objc dynamic var  addressStr: String?
    @objc dynamic var  time: Double = 0
    @objc dynamic var  waitSinatureStr: String?
    @objc dynamic var  sinatureStr: String?
    
    override static func primaryKey() -> String? {
        return "uuid"
    }

}
