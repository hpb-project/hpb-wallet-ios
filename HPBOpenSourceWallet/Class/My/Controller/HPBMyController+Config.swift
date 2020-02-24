//
//  HPBMyController+Config.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/8.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

extension HPBMyController{
    
    enum CellConfig: String{
        case setting = "My-Settings"
        case help  = "My-Help-Center"
        case walletManage = "ManageWallet-Title"
        case transferRecord = "gl0-wy-bCF.text"
        case empty = ""
        
        var image: UIImage{
            switch self {
            case .setting:
                return #imageLiteral(resourceName: "my_setting")
            case .help:
                return #imageLiteral(resourceName: "my_help_center")
            case .walletManage:
                return #imageLiteral(resourceName: "my_wallet_manage")
            case .transferRecord:
                return #imageLiteral(resourceName: "my_transfer_record")
            case .empty:
                return #imageLiteral(resourceName: "main_list_creat")
            }
        }
        init?(row: Int){
            switch row{
            case 0:  //第一区
                self = .walletManage
            case 1:
                self = .transferRecord
            case 3:  //第二区
                self = .setting
            case 4:
                self = .help
            default:
                return nil
            }
        }
    }
}
