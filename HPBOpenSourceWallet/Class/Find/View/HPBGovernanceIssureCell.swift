//
//  HPBGovernanceIssureCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/9.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceIssureCell: UITableViewCell {

    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBGovernanceIssureCell.self), height: 0)

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var issuseLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateTimeLabel: UILabel!
    @IBOutlet weak var dateLineTimeLabel: UILabel!
    @IBOutlet weak var voteNumberLabel: UILabel!
    var timer: Timer?
    var remainTime: Double = 0
    
    @objc func countdownHandel(){
        self.remainTime =  self.remainTime - 10
        if self.remainTime <= 0{
            timer?.invalidate()
            self.remainTime = 0
        }
        let dayHourMinute = Date.getCutDownStr(timeRemain: self.remainTime)
        dateLineTimeLabel.attributedText = HPBNewsViewModel.timeAttributeStrColor(dayHourMinute)
    }
    
    
    var model: HPBProposalModel?{
        willSet{
            guard let `newValue`  = newValue else{return}
            issuseLabel.text = newValue.titleName
            contentLabel.text = newValue.desc
            stateLabel.text = newValue.voteType.rawValue.localizable
            //议题发起时间
            let beginDate =  Date(timeIntervalSince1970: TimeInterval(newValue.beginTime / 1000.0))
            stateTimeLabel.text = "News-Governance-Proposal-Start-Time".localizable + beginDate.toString(by: "yyyy/MM/dd HH:mm")
            
            //投票截止时间
            let endDate =  Date(timeIntervalSince1970: TimeInterval(newValue.endTime / 1000.0))
            dateLineTimeLabel.attributedText = ("News-Governance-Voting-Ends".localizable + endDate.toString(by: "yyyy/MM/dd HH:mm")).attributeStrColorAndFont(HPBNewsViewModel.bottomDatelineColor)
            
            // 社区总投票数
            voteNumberLabel.text = "News-Governance-Community-Vote-Number".localizable + HPBStringUtil.converHpbMoneyFormat(newValue.totalNum, 0).noneNull
             timer?.invalidate()
            switch newValue.voteType {
            case .ongoing:
                self.backImage.image = UIImage(named: "governance_list_shen")
                self.bottomImage.image = UIImage(named: "governance_detail_toupiao")
                 self.stateImage.image = UIImage(named: "governance_list_toupiao")
                self.remainTime = newValue.endTime / 1000 - Date().timeIntervalSince1970
                self.remainTime  = self.remainTime  + 10
                self.countdownHandel()
                timer =  Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(countdownHandel), userInfo: nil, repeats: true)
            case .pass:
                self.stateImage.image = UIImage(named: "governance_list_pass")
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.bottomImage.image = UIImage(named: "governance_detail_pass")
            case .revealed:
                self.stateImage.image = UIImage(named: "governance_list_jiexiao")
                self.backImage.image = UIImage(named: "governance_list_shen")
                self.bottomImage.image = UIImage(named: "governance_detail_jiexiao")
            case .obsolete:
                self.stateImage.image = UIImage(named: "governance_list_zuofei")
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.bottomImage.image = UIImage(named: "governance_detail_zuofei")
            case .veto:
                self.stateImage.image = UIImage(named: "governance_list_foujue")
                self.backImage.image = UIImage(named: "governance_list_qian")
                self.bottomImage.image = UIImage(named: "governance_detail_foujue")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowOpacity = 0.1
        backView.layer.shadowRadius = 7
    }

    
    deinit {
        timer?.invalidate()
    }

}
