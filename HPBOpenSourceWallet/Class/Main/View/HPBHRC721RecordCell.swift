//
//  HPBHRC721RecordCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/12.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721RecordCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBHRC721RecordCell.self), height: 80)

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var currentAddress: String? = HPBUserMannager.shared.currentWalletInfo?.addressStr
    
    
    var model: HPBTransferRecord?{
        willSet{
            guard let `newValue` = newValue else{return}
            addressLabel.text = newValue.fromAccount.cutOutAddress() + "   To   " + newValue.toAccount.cutOutAddress()
            if currentAddress.noneNull.lowercased() == HPBStringUtil.noneNull(newValue.toAccount).lowercased(){
                leftImage.image = #imageLiteral(resourceName: "my_transferRecord_in")
            }else{
                leftImage.image = #imageLiteral(resourceName: "my_transferRecord_out")
            }
           timeLabel.text = newValue.formatStr
            idLabel.text = "\("Transfer-Token-ID".localizable): " + newValue.tokenId
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
