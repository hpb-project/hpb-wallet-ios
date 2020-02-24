//
//  HPBMainCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMainCell: UITableViewCell {
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBMainCell.self), height: 342)
    
    enum HPBActionType: Int{
        case scan = 100
        case receipt
        case transfer
        case copy
        case hiddeenAssert
        case syncAssert
    }
    enum HPBEyeState{
        case close,open
    }
    
    struct MainAssertModel{
        var addressStr: String? = ""
        var coinMoneyStr: String? = "0"
        var eyeState: HPBEyeState = .open
        var coldState: Bool = false
        init(addressStr: String? = HPBAPPConfig.hiddenAssertStr,coinMoneyStr: String? = "0",eyeState: HPBEyeState,coldState: String? = "0") {
            self.addressStr = addressStr
            self.coinMoneyStr = coinMoneyStr
            self.eyeState = eyeState
            self.coldState = (coldState == "1")
        }
    }
   
    @IBOutlet weak var hotScanLabel: UILabel!
    @IBOutlet weak var hotTransferLabel: UILabel!
    @IBOutlet weak var hotReceiptLabel: UILabel!
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var receiptLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var scanLabel: UILabel!
    @IBOutlet weak var coinNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var coldLabel: UILabel!
    @IBOutlet weak var topBackView: UIView!
    
    @IBOutlet weak var moneyTitleLabel: UILabel!
    @IBOutlet weak var rightBackView: UIView!
    @IBOutlet weak var walletNameLabel: UILabel!
    
    @IBOutlet weak var coldBackView: UIView!
    @IBOutlet weak var hotBackView: UIView!
    
    
    var scanBlock: (()->Void)?
    var receiptBlock: (()->Void)?
    var transferBlock: (()->Void)?
    var copyBlock: (()->Void)?
    var hiddenBlock: ((Bool)->Void)?
    var selectWalletBlock: (()->Void)?
    var syncAssertBlock: (()->Void)?
    
    
    
    var model: MainAssertModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            topTitleLabel.text = "TabBar-Main.title".localizable
            moneyTitleLabel.text = "Main-Total-Assert".localizable
            switch newValue.eyeState {
            case .open:
                coinNumberLabel.text = newValue.coinMoneyStr
            case .close:
                coinNumberLabel.text = HPBAPPConfig.hiddenAssertStr
            }
            addressLabel.text = newValue.addressStr
            self.coldLabel.isHidden = !newValue.coldState
            self.hotBackView.isHidden = newValue.coldState
            self.coldBackView.isHidden = !newValue.coldState
            if let walletInfo = HPBUserMannager.shared.currentWalletInfo{
                self.rightBackView.isHidden = false
                let walletName = walletInfo.walletName
                walletNameLabel.text = walletName
            }else{
                self.rightBackView.isHidden = true
            }
        }
    }
    
        
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        topBackView.layer.shadowColor = UIColor.black.cgColor
        topBackView.layer.shadowOffset = CGSize.zero
        topBackView.layer.shadowOpacity = 0.2
        topBackView.layer.shadowRadius = 20
        
        rightBackView.layer.cornerRadius = 13
        rightBackView.layer.shadowColor = UIColor.black.cgColor
        rightBackView.layer.shadowOffset = CGSize.zero
         topBackView.layer.shadowOpacity = 0.2
        rightBackView.layer.shadowRadius = 10
        localizableConfig()
    }
    
    fileprivate func localizableConfig(){
        coldLabel.text = "Common-ColdWallet-Btn-Title".localizable
        receiptLabel.text = "Main-Receipt".localizable
        paymentLabel.text = "Main-Transfer".localizable
        scanLabel.text = "Main-Scan".localizable
        syncLabel.text = "Main-Sync".localizable
        hotReceiptLabel.text = "Main-Receipt".localizable
        hotScanLabel.text = "Main-Scan".localizable
        hotTransferLabel.text =  "Main-Transfer".localizable
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        let actionType = HPBActionType(rawValue: sender.tag)
        guard actionType != nil else{return}
        switch actionType! {
        case .scan:
            scanBlock?()
        case .receipt:
            receiptBlock?()
        case .transfer:
            transferBlock?()
        case .copy:
            copyBlock?()
        case .hiddeenAssert:
            guard let `model` = model else{return}
            hiddenBlock?(model.eyeState == .open)  //现在是open，接下来是hidden
        case .syncAssert:
            syncAssertBlock?()
        }
    }
    @IBAction func selectWalletClick(_ sender: UIButton) {
        selectWalletBlock?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
