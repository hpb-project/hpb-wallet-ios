//
//  HPBTransferRecordCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/13.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTransferRecordCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBTransferRecordCell.self), height: 78)
    fileprivate var currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr

    @IBOutlet weak var moneylabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    
    
    struct TransferRecordInfo{
        
        var currentAddress: String = ""
        var toAddress: String   = ""
        var time   :   String = ""
        var money  : String   = ""
        var fromAddress  : String   = ""
        
        init(_ currentAddress: String = "",
             fromAddress: String = "",
              toAddress: String = "",
              time: String = "",
              money: String = ""){
            self.fromAddress = fromAddress
            self.currentAddress = currentAddress
            self.toAddress = toAddress
            self.time = time
            self.money = money
        }
    }
    var isMapping: Bool = false
    var recordInfoModel: TransferRecordInfo? = nil{
        willSet{
            guard let `newValue` = newValue else{return}
            timeLabel.text = newValue.time
            if isMapping{   //映射记录
                addressLabel.text = newValue.currentAddress.cutOutAddress() + "   To   " + newValue.toAddress.cutOutAddress()
                let money =  HPBStringUtil.converHpbMoneyFormat(newValue.money)
                moneylabel.textColor = UIColor.init(withRGBValue: 0xE86A6A)
                moneylabel.text = "-" + money.noneNull
                leftImage.image = #imageLiteral(resourceName: "my_transferRecord_out")
            }else{
                addressLabel.text = newValue.fromAddress.cutOutAddress() + "   To   " + newValue.toAddress.cutOutAddress()
                if newValue.currentAddress.lowercased() == HPBStringUtil.noneNull(newValue.toAddress).lowercased(){
                    moneylabel.textColor = UIColor.init(withRGBValue: 0x44C8A3)
                    moneylabel.text = "+" + newValue.money
                    leftImage.image = #imageLiteral(resourceName: "my_transferRecord_in")
                    
                }else{
                    moneylabel.textColor = UIColor.init(withRGBValue: 0xE86A6A)
                    moneylabel.text = "-" + newValue.money
                    leftImage.image = #imageLiteral(resourceName: "my_transferRecord_out")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorLineStyle = .none
    }
 
}
