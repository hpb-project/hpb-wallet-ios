//
//  HPBGovernanceVoteView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/13.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGovernanceVoteView: UIView {
  
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var hadVoteField: UILabel!
    @IBOutlet weak var aviableVoteField: UILabel!
    var voteType: HPBGovernanceVoteCell.HPBGovernanceVoteType = .agree

    var confirmBlock: ((HPBGovernanceVoteCell.HPBGovernanceVoteType,String)-> Void)?
    
    let heightValue = UIScreen.tabbarSafeBottomMargin + 226
    override func awakeFromNib() {
        super.awakeFromNib()
        allBtn.setTitle("Common-All".localizable, for: .normal)
        confirmBtn.setTitle("News-Governance-Confirm-Vote".localizable, for: .normal)
        backView.layer.borderWidth = 1
        //和蓝湖上不同,测试拿到修改的
        backView.layer.borderColor = UIColor.init(withRGBValue: 0xD8D8D8).cgColor
        backView.layer.cornerRadius = 3
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        topView.addGestureRecognizer(tapgesture)
        configInitLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(frameChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
       
    }
    
    @objc fileprivate  func frameChange(_ notification:Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        print(offsetY)
        UIView.animate(withDuration: 0.3) {
            if offsetY == 0 {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
            }else{
                self.transform = CGAffineTransform(translationX: 0, y: offsetY)
            }
        }
    }
      
    
    func configInitLayout(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        bottomConstraint.constant = -heightValue
        self.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25) {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.bottomConstraint.constant = 0
                self.layoutIfNeeded()
            }
        }
    }
    
    
    var model: HPBProposalModel?{
        willSet{
            guard let `newValue` = newValue else{return}
             textField.placeholder = String(format: "News-Governance-Vote-Placehoder".localizable, HPBStringUtil.converHpbMoneyFormat(newValue.floorNum, 0).noneNull)
            switch voteType {
            case .agree:
                self.topImage.image = UIImage(named: "governance_detail_agree")
                self.stateLabel.text = newValue.option1Name
                self.hadVoteField.text = "News-Governance-Community-Votes-Casted".localizable + HPBStringUtil.converHpbMoneyFormat(newValue.peragreeNum, 0).noneNull
            default:
                self.topImage.image = UIImage(named: "governance_detail_againt")
                 self.stateLabel.text = newValue.option2Name
                 self.hadVoteField.text = "News-Governance-Community-Votes-Casted".localizable + HPBStringUtil.converHpbMoneyFormat(newValue.perdisagreeNum, 0).noneNull
                
            }
            self.aviableVoteField.text = "News-Governance-Community-Votes-Available".localizable + HPBStringUtil.converHpbMoneyFormat(newValue.aviliableNum, 0).noneNull

        }
    }
    
    @IBAction func confirmBtnClick(_ sender: UIButton) {
         guard let `model` = self.model else{return}
         let voteStr = HPBStringUtil.moneyFormatToString(value: textField.text.noneNull)
        let voteNum = textField.text.noneNull.doubleValue
        if voteNum == 0{
            showBriefMessage(message: "Vote-Confirm-Numeber-Empty".localizable)
            return
        }else if  HPBStringUtil.compare(HPBStringUtil.converEthMoneyStr(voteStr), model.aviliableNum) == .orderedDescending{ //
            showBriefMessage(message: "Vote-Confirm-beyound".localizable)
            return
        }else if  HPBStringUtil.compare(model.floorNum, HPBStringUtil.converEthMoneyStr(voteStr)) == .orderedDescending{ //
            showBriefMessage(message: "Vote-Confirm-lower-Vote".localizable)
            return
        }
        tapDismiss()
        confirmBlock?(voteType,textField.text.noneNull)
        
    }
    
    @objc func tapDismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint.constant = -self.heightValue
            self.layoutIfNeeded()
        }) {(state) in
            self.removeFromSuperview()
        }
    }
    
    
    @IBAction func allBtnClick(_ sender: UIButton) {
         guard let `model` = self.model else{return}
         textField.text = HPBStringUtil.converHpbMoneyFormat(model.aviliableNum, 0).noneNull
    }
    

}
