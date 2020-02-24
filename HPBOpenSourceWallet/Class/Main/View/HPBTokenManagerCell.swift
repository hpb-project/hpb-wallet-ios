//
//  HPBTokenManagerCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/2.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTokenManagerCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBTokenManagerCell.self), height: 66)

    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tokenNameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var tokenBalanceLabel: UILabel!
    @IBOutlet weak var tokenTypeLabel: UILabel!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    
    var selectBlock: ((Bool)-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var isLeftSelect: Bool = false{
        willSet{
           leftButton.isSelected = newValue
        }
    }
    
    
    var model: HPBTokenManagerModel? {
        willSet{
            guard let `newValue` = newValue else {return}
           
            descLabel.text = newValue.tokenName
            tokenNameLabel.text = newValue.tokenSymbol
            moneyLabel.isHidden = newValue.cnyPrice.isEmpty
              let showBalance = HPBMoneyStyleUtil.share.showFormatMoney(newValue.cnyTotalValue, newValue.usdTotalValue)
            moneyLabel.text = showBalance
            
            tokenTypeLabel.text = newValue.contractType
            if let imageURL = URL(string: newValue.tokenSymbolImageUrl){
               tokenImage.sd_setImage(with:imageURL, placeholderImage: UIImage.init(named: "common_head_placehoder"))
            }else{
                tokenImage.image = UIImage.init(named: "common_head_placehoder")
            }
            switch newValue.type {
            case .mainNet:
                tokenBalanceLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.balanceOfToken)
            case .hrc20:
                tokenBalanceLabel.text = HPBStringUtil.converCustomDigitsFormat(newValue.balanceOfToken, decimalCount: newValue.formatDecimals)
            case .hrc721:
                tokenBalanceLabel.text = newValue.balanceOfToken
            }
        }
    }
    
    
    var showAssertFlag: Bool = true{
        willSet{
            if newValue == false{
                moneyLabel.text = HPBAPPConfig.hiddenAssertStr
                tokenBalanceLabel.text = HPBAPPConfig.hiddenAssertStr
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func selectBtnClick(_ sender: UIButton) {
        
        sender.isSelected =  !sender.isSelected
        selectBlock?(sender.isSelected)
    }
    
}
