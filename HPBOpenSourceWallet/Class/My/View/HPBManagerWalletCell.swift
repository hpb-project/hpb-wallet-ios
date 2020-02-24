//
//  HPBManagerWalletCell.swift
//  LXLTest1
//
//  Created by 刘晓亮 on 2018/5/23.
//  Copyright © 2018年 朝夕网络. All rights reserved.
//

import UIKit

class HPBManagerWalletCell: HPBBaseTableCell {
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBManagerWalletCell.self), height: 118)

    struct DataModel{
        var name     : String? = ""
        var address  : String? = ""
        var money    : String? = ""
        var mnemonics: String? = ""
        var headImageName: String? = ""
        var coldState: Bool = false
        init(name: String?,
             address: String?,
             money: String?,
             mnemonics: String?,
             headImageName: String?,
             coldState: String? = "0") {
            self.name = name
            self.address = address
            self.money = money
            self.headImageName = headImageName
            self.mnemonics = mnemonics
            self.coldState = (coldState == "1")
        }
    }
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var backUpBtn: UIButton!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    var model: DataModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            nameLabel.text = newValue.name
            moneyLabel.text = newValue.money.noneNull
            addressLabel.text = newValue.address
            if newValue.mnemonics.noneNull.isEmpty{
                backUpBtn.isHidden = true
            }else{
                backUpBtn.isHidden = false
            }
            headImage.image = UIImage(contentsOfFile:HPBFileManager.getHeadImageDirectory() + newValue.headImageName.noneNull)
            
            //判断是否是冷钱包，要显示
            if newValue.coldState{
               backUpBtn.isHidden = false
                backUpBtn.setTitle("Common-ColdWallet-Btn-Title".localizable, for: .normal)
                backUpBtn.setBackgroundImage(UIImage(named: "my_manager_backup_cold"), for: .normal)
            }else{
                backUpBtn.setBackgroundImage(UIImage(named: "my_manager_backup"), for: .normal)
                backUpBtn.setTitle("WalletHandel-No-Backup".localizable, for: .normal)
            }
        }
    }
    
    
    var showAssertFlag: Bool = true{
        willSet{
            if newValue == false{
                moneyLabel.text = HPBAPPConfig.hiddenAssertStr
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        backImage.layer.masksToBounds = true
        backImage.layer.cornerRadius = 8
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowRadius = 5
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
