//
//  HPBGovernanceRecordCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/9.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceRecordCell: UITableViewCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBGovernanceRecordCell.self), height: 0)
    
    
    @IBOutlet weak var rightBottomImage: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var againstImage: UIImageView!
    @IBOutlet weak var againstLabel: UILabel!
    @IBOutlet weak var agreeImage: UIImageView!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var timer: Timer?
    var remainTime: Double = 0
    
    @objc func countdownHandel(){
        self.remainTime =  self.remainTime - 10
        if self.remainTime <= 0{
            timer?.invalidate()
            self.remainTime = 0
        }
        let dayHourMinute = Date.getCutDownStr(timeRemain: self.remainTime)
        bottomLabel.attributedText = HPBNewsViewModel.timeAttributeStrColor(dayHourMinute)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    var model: HPBProposalModel?{
        
        willSet{
            guard let `newValue` = newValue else {return}
            self.titleLabel.text = newValue.titleName
            stateLabel.text = newValue.voteType.rawValue.localizable
            //投票截止时间
            let endDate =  Date(timeIntervalSince1970: TimeInterval(newValue.endTime / 1000.0))
            bottomLabel.attributedText = ("News-Governance-Voting-Ends".localizable + endDate.toString(by: "yyyy/MM/dd HH:mm")).attributeStrColorAndFont(HPBNewsViewModel.bottomDatelineColor)
            timer?.invalidate()
            switch newValue.voteType {
            case .ongoing:
                self.rightBottomImage.image = UIImage(named: "governance_detail_toupiao")
                self.backImage.image = UIImage(named: "governance_list_shen")
                self.stateImage.image = UIImage(named: "governance_list_toupiao")
                 self.remainTime = newValue.endTime / 1000 - Date().timeIntervalSince1970
                let dayHourMinute = Date.getCutDownStr(timeRemain: self.remainTime)
                bottomLabel.attributedText = HPBNewsViewModel.timeAttributeStrColor(dayHourMinute)
                timer =  Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(countdownHandel), userInfo: nil, repeats: true)
            case .pass:
                self.rightBottomImage.image = UIImage(named: "governance_detail_pass")
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.stateImage.image = UIImage(named: "governance_list_pass")
            case .revealed:
                self.rightBottomImage.image = UIImage(named: "governance_detail_jiexiao")
                self.backImage.image = UIImage(named: "governance_list_shen")
                self.stateImage.image = UIImage(named: "governance_list_jiexiao")
            case .obsolete:
                self.rightBottomImage.image = UIImage(named: "governance_detail_zuofei")
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.stateImage.image = UIImage(named: "governance_list_zuofei")
            case .veto:
                self.rightBottomImage.image = UIImage(named: "governance_detail_foujue")
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.stateImage.image = UIImage(named: "governance_list_foujue")
            }
            againstImage.image = UIImage(named: "governance_detail_againt")
            againstLabel.text = newValue.option2Name + ": " + HPBStringUtil.converHpbMoneyFormat(newValue.perdisagreeNum, 0).noneNull
            agreeImage.image = UIImage(named: "governance_detail_agree")
            agreeLabel.text = newValue.option1Name + ": " + HPBStringUtil.converHpbMoneyFormat(newValue.peragreeNum, 0).noneNull
            if newValue.peragreeNum.doubleValue == 0{
                againstImage.isHidden = true
                againstLabel.isHidden = true
                topConstraint.constant = 11
                agreeImage.image = UIImage(named: "governance_detail_againt")
                agreeLabel.text = newValue.option2Name + ": " + HPBStringUtil.converHpbMoneyFormat(newValue.perdisagreeNum, 0).noneNull
            }
        }
    }

    
    deinit {
        timer?.invalidate()
    }

}
