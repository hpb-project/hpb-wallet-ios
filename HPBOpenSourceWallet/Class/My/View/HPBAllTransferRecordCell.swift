//
//  HPBAllTransferRecordCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBAllTransferRecordCell: HPBBaseTableCell{
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBAllTransferRecordCell.self), height: 74)
    fileprivate var currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tokenNumberLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeBackView: UIView!
    
    var tokenType: HPTransferRecordController.HPBContractType = .mainNet
    
    var model: HPBTransferRecord?{
        willSet{
            guard let `newValue` = newValue else{return}
            var signStr: String?
            if currentAddress.noneNull.lowercased() == HPBStringUtil.noneNull(newValue.toAccount).lowercased(){
                addressLabel.text = newValue.fromAccount.cutOutAddress()
                tokenNumberLabel.textColor = UIColor.init(withRGBValue: 0x44C8A3)
                leftImage.image = #imageLiteral(resourceName: "my_transferRecord_in")
                signStr = "+ "
            }else{
                addressLabel.text = newValue.toAccount.cutOutAddress()
                tokenNumberLabel.textColor = UIColor.init(withRGBValue: 0xE86A6A)
                leftImage.image = #imageLiteral(resourceName: "my_transferRecord_out")
                signStr = "- "
            }
            timeLabel.text = newValue.formatStr
            
            typeBackView.isHidden = false
            if self.tokenType == .mainNet{
                typeBackView.isHidden = true
            }
           typeLabel.text = tokenType.rawValue
            
            switch tokenType {
            case .mainNet:
               tokenNumberLabel.text = signStr.noneNull + HPBStringUtil.converHpbMoneyFormat(newValue.tValue).noneNull + " HPB"
            case .hrc20:
                tokenNumberLabel.text = signStr.noneNull + newValue.tValue + " " + newValue.tokenSymbol
            case .hrc721:
                tokenNumberLabel.text = signStr.noneNull + "\("Transfer-Token-ID".localizable): \(newValue.tokenId)"
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

  
    
    
}
