//
//  HPBGovernanceVoteCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/9.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceVoteCell: UITableViewCell {

    
    enum HPBGovernanceVoteType{
        
        case agree,against
        
        var typeValue: Int{
            get{
                if self == .agree{
                    return 1
                }else{
                    return 0
                }
            }
        }
    }
    
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBGovernanceVoteCell.self), height: 115)
    
    let progressBackColor: UIColor = UIColor.init(withRGBValue: 0xEDEFF1)
    let progressLeftColor: UIColor = UIColor.init(withRGBValue: 0x02B8F7)
    
    @IBOutlet weak var piaoLabel: UILabel!
    @IBOutlet weak var progressBackView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var radioLabel: UILabel!
    @IBOutlet weak var voteNumberLabel: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var widthContraint: NSLayoutConstraint!
    var voteBlock: ((HPBGovernanceVoteType)->Void)?
    
    var model: HPBProposalModel?{
        willSet{
         guard let `newValue`  = newValue else{return}
               voteBtn.isHidden = true
            if newValue.voteType == .ongoing{
                voteBtn.isHidden = false
            }
            piaoLabel.text = "Vote-Confirm-Max-Piao".localizable
            switch type{
            case .agree:
                if  newValue.value1Rate.doubleValue == 0{
                   self.radio = 0
                }else{
                    self.radio = CGFloat(newValue.value1Rate.doubleValue)
                }
                self.stateLabel.text = newValue.option1Name
                voteNumberLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.value1Num, 0)
                radioLabel.text =  "(" + HPBStringUtil.converDecimal(newValue.value1Rate, "100", 0, type: .multiplying, roundingMode: .down) + "%)"
                numberLabel.text = "News-Governance-Community-Votes-Casted".localizable + HPBStringUtil.converHpbMoneyFormat(newValue.peragreeNum, 0).noneNull

            case .against:
                if  newValue.value2Rate.doubleValue == 0{
                    self.radio = 0
                }else{
                    self.radio = CGFloat(newValue.value2Rate.doubleValue)
                }
                self.stateLabel.text = newValue.option2Name
                voteNumberLabel.text =  HPBStringUtil.converHpbMoneyFormat(newValue.value2Num, 0).noneNull
                radioLabel.text = "(" + HPBStringUtil.converDecimal(newValue.value2Rate, "100", 0, type: .multiplying, roundingMode: .down) + "%)"
                numberLabel.text = "News-Governance-Community-Votes-Casted".localizable + HPBStringUtil.converHpbMoneyFormat(newValue.perdisagreeNum, 0).noneNull

            }
        }
    }

    
    
   private var radio: CGFloat = 0{
        willSet{
           widthContraint.constant = (UIScreen.width - 76) * newValue
        }
    }
    
    var type: HPBGovernanceVoteType = .agree{
        willSet{
            switch newValue {
            case .agree:
                voteNumberLabel.textColor = UIColor.init(withRGBValue: 0x02B8F7)
                progressView.backgroundColor = UIColor.init(withRGBValue: 0x02B8F7)
                leftImage.image = UIImage(named: "governance_detail_agree")
            case .against:
                  voteNumberLabel.textColor = UIColor.init(withRGBValue: 0xFFB428)
                  progressView.backgroundColor = UIColor.init(withRGBValue: 0xFFB428)
                leftImage.image = UIImage(named: "governance_detail_againt")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 8
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowOpacity = 0.1
        backView.layer.shadowRadius = 7
        progressBackView.layer.cornerRadius = 3
        progressBackView.layer.masksToBounds = true
        voteBtn.setTitle("Vote-Vote-Btn".localizable, for: .normal)
    }
    
    
    @IBAction func voteBtnClick(_ sender: UIButton) {
        voteBlock?(self.type)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
