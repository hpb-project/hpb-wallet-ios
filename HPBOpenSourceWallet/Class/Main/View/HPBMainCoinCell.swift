//
//  HPBMainCoinCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/7.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMainCoinCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBMainCoinCell.self), height: 68)

   
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinNumberLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var coinMoneyLabel: UILabel!
    @IBOutlet weak var typebackView: UIView!
    @IBOutlet weak var tokenTypeLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headImage: UIImageView!
    var showAssertFlag: Bool = true{
        willSet{
            if newValue == false{
                coinNumberLabel.text = HPBAPPConfig.hiddenAssertStr
                coinMoneyLabel.text = HPBAPPConfig.hiddenAssertStr
            }
        }
    }
    
    var isHiddenBottomView: Bool = true{
        willSet{
            bottomView.isHidden = newValue
        }
    }
    
    
    var model: HPBTokenManagerModel?{
        willSet{
            guard let `newValue`  = newValue else{return}
            
            
            coinNameLabel.text = newValue.tokenSymbol
            
            switch newValue.type {
            case .mainNet:
                 coinNumberLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.balanceOfToken)
            case .hrc20:
                 coinNumberLabel.text = HPBStringUtil.converCustomDigitsFormat(newValue.balanceOfToken, decimalCount: newValue.formatDecimals)
            case .hrc721:
                 coinNumberLabel.text = newValue.balanceOfToken
            }
             coinMoneyLabel.isHidden = newValue.cnyPrice.isEmpty
            let showBalance = HPBMoneyStyleUtil.share.showFormatMoney(newValue.cnyTotalValue, newValue.usdTotalValue)
            coinMoneyLabel.text = showBalance
            typebackView.isHidden = newValue.type == .mainNet
            tokenTypeLabel.text = newValue.contractType
            if let imageURL = URL(string: newValue.tokenSymbolImageUrl){
                headImage.sd_setImage(with:imageURL, placeholderImage: UIImage.init(named: "common_head_placehoder"))
            }else{
                headImage.image = UIImage.init(named: "common_head_placehoder")
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
