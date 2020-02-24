//
//  HPBStartReceiveCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBStartReceiveCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBStartReceiveCell.self), height: UIScreen.scaleFontIphone6(267))

    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var moneyUnitLabel: UILabel!
    @IBOutlet weak var bottomStateLabel: UILabel!
    
    var selectBlock: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectBtn.isHidden = true
        self.moneyLabel.text = "0"
        self.bottomStateLabel.text = "News-RedPacket-Receive-Invalid-Tip".localizable
        selectBtn.setTitle("News-RedPacket-Receive-Select-Address".localizable, for: .normal)
        var locationStr = "的HPB红包"
        if HPBLanguageUtil.share.language == .english{
            locationStr = "Red Packet from "
        }
         self.topLabel.text = locationStr
        var typeImageName = "redpacket_white_pin"
        if HPBLanguageUtil.share.language == .english{
            typeImageName.append("_en")
        }
        typeImage.image = UIImage(named: typeImageName)
    }

    var model: HPBSendDetailLists?{
        willSet{
            
            guard let `newValue` = newValue else {return}
            var locationStr = newValue.fromAddr.cutOutAddress() + "的HPB红包"
            if HPBLanguageUtil.share.language == .english{
                locationStr = "Red Packet from " + newValue.fromAddr.cutOutAddress()
            }
            self.topLabel.text = locationStr
            var typeImageName = ""
            switch newValue.redPacketType {
            case .normal:
                typeImageName = "redpacket_white_pu"
            default:
                 typeImageName = "redpacket_white_pin"
            }
            if HPBLanguageUtil.share.language == .english{
                typeImageName.append("_en")
            }
            typeImage.image = UIImage(named: typeImageName)

            self.tipLabel.text = newValue.title
            self.selectBtn.isHidden = true
            self.moneyLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.currentValue, 4).noneNull
            //适配已领取等状态
            if  newValue.redPacketDrawStatus != .none{
                switch newValue.redPacketDrawStatus{
                case .success:
                    self.bottomStateLabel.text = "News-RedPacket-Receive-Success-Tip".localizable
                    
                case .faile:
                    self.bottomStateLabel.text = "News-RedPacket-State-Faile".localizable
                case .confirm:
                    self.bottomStateLabel.text = "News-RedPacket-Receive-Confirm-State-1".localizable
                default:
                    self.bottomStateLabel.text = ""
                }
                
                return
            }
            //适配刚进来领取的时候的状态
            let isAllReceive =  newValue.usedNum ==   newValue.totalNum
            if isAllReceive{   //已经领完
                self.bottomStateLabel.text = "News-RedPacket-State-Had-All-Received".localizable
            }else{
                if newValue.redpacketOver == .end{   //红包已失效
                    self.bottomStateLabel.text = "News-RedPacket-Receive-End-Tip".localizable
                }else if newValue.redpacketOver == .ongoing{
                    if newValue.isKeyVaild == false{   //key失效
                        self.bottomStateLabel.text = "News-RedPacket-State-Faile".localizable
                    }else{
                         self.bottomStateLabel.text = ""
                        self.selectBtn.isHidden = false
                    }
                }
            }

        }
    }
 
    @IBAction func selectBtnClick(_ sender: UIButton) {
        
        selectBlock?()
        
        
    }
    
}
