//
//  HPBGovernanceListCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/8.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceListCell: UITableViewCell {

    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBGovernanceListCell.self), height: 0)

    let progressBackColor: UIColor = UIColor.init(withRGBValue: 0xEDEFF1)
    let progressLeftColor: UIColor = UIColor.init(withRGBValue: 0x02B8F7)
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var radioConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var agreeNumberLabel: UILabel!
    @IBOutlet weak var agreePrecentLabel: UILabel!
    @IBOutlet weak var againstNumberLabel: UILabel!
    @IBOutlet weak var againstPrecentLabel: UILabel!
    
    
    @IBOutlet weak var leftProgressView: UIView!
    @IBOutlet weak var agreeTitleLabel: UILabel!
    @IBOutlet weak var againstTitleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    var timer: Timer?
    var remainTime: Double = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        detailLabel.text = "News-Governance-More".localizable
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowRadius = 7
    }

    var radio: CGFloat = 0{
        willSet{
            if newValue == 1{
                radioConstraint.constant = UIScreen.width - 76
                rightConstraint.constant = 0
            }else if newValue == 0{
                radioConstraint.constant = 0
                rightConstraint.constant = 0
            }else{
                rightConstraint.constant = 2
                radioConstraint.constant = (UIScreen.width - 78) * newValue
            }
          
        }
    }
    
    @objc func countdownHandel(){
        self.remainTime =  self.remainTime - 10
        if self.remainTime <= 0{
             timer?.invalidate()
            self.remainTime = 0
        }
        let dayHourMinute = Date.getCutDownStr(timeRemain: self.remainTime)
        bottomLabel.attributedText = HPBNewsViewModel.timeAttributeStrColor(dayHourMinute)
    }
    
    var model: HPBProposalModel? {
        willSet{
            guard let `newValue` = newValue else {
                return
            }
           
            agreeNumberLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.value1Num, 0)
            againstNumberLabel.text = HPBStringUtil.converHpbMoneyFormat(newValue.value2Num, 0)
            agreePrecentLabel.text = "(" + HPBStringUtil.converDecimal(newValue.value1Rate, "100", 0, type: .multiplying, roundingMode: .down) + "%)"
            againstPrecentLabel.text = "(" + HPBStringUtil.converDecimal(newValue.value2Rate, "100", 0, type: .multiplying, roundingMode: .down)  + "%)"
            agreeTitleLabel.text = newValue.option1Name
            againstTitleLabel.text = newValue.option2Name
            self.stateLabel.text = newValue.voteType.rawValue.localizable
            
            //投票截止时间
            let endDate =  Date(timeIntervalSince1970: TimeInterval(newValue.endTime / 1000.0))
            bottomLabel.attributedText = ("News-Governance-Voting-Ends".localizable + endDate.toString(by: "yyyy/MM/dd HH:mm")).attributeStrColorAndFont(HPBNewsViewModel.bottomDatelineColor)
            detailLabel.backgroundColor = UIColor.white
            detailLabel.textColor = UIColor.init(withRGBValue: 0x283041)
            timer?.invalidate()
            switch newValue.voteType {
            case .ongoing:
                
                self.backImage.image = UIImage(named: "governance_list_shen")
                self.topImage.image = UIImage(named: "governance_list_toupiao")
                self.remainTime = newValue.endTime / 1000 - Date().timeIntervalSince1970
                self.remainTime  = self.remainTime  + 10
                self.countdownHandel()
                timer =  Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(countdownHandel), userInfo: nil, repeats: true)
            case .pass:
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.topImage.image = UIImage(named: "governance_list_pass")
            case .revealed:
                self.backImage.image = UIImage(named: "governance_list_shen"
                )
                self.topImage.image = UIImage(named: "governance_list_jiexiao")
            case .obsolete:
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.topImage.image = UIImage(named: "governance_list_zuofei")
            case .veto:
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.topImage.image = UIImage(named: "governance_list_foujue")
            }
            questionLabel.text = newValue.titleName
            leftProgressView.backgroundColor = progressLeftColor
            if  newValue.value1Rate.doubleValue == 0 && newValue.value2Rate.doubleValue == 0{
                self.radio = 1
                leftProgressView.backgroundColor = progressBackColor
            }else{
                self.radio = CGFloat(newValue.value1Rate.doubleValue)
            }
        }
        
    }
    

    deinit {
        debugLog("HPBGovernanceListCell释放了")
         timer?.invalidate()
    }
}
