//
//  HPBTransferConfirmView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/21.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTransferConfirmView: UIViewController {
    
    struct HPBConfirmModel{
        var toAddress: String = ""
        var myAddress: String = ""
        var money    : String = ""
        var fee      : String = ""
        var desc     : String = ""
        var sympol   : String = ""
        var sympolType: String = ""
        init( _ myAddress: String,_ toAddress: String,_ money: String,_ fee: String,desc: String = "",sympol: String = "HPB",sympolType: String = ""){
            self.toAddress = toAddress
            self.myAddress = myAddress
            self.money = money
            self.fee = fee
            self.desc = desc
            self.sympol = sympol
            self.sympolType = sympolType
        }
    }
    var isDappPay: Bool = false
    var type: HPBMainViewModel.HPBTransferType = .transfer
    @IBOutlet weak var payDetailLabel: UILabel!
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var transferTipLabel: UILabel!
    @IBOutlet weak var transferInTipLabel: UILabel!
    @IBOutlet weak var payWalletTipLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var transferFeeTitleLabel: UILabel!
    @IBOutlet weak var transferFeeContentLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    
    
    // 其他信息
    @IBOutlet weak var otherInfoTitleLabel: UILabel!
    @IBOutlet weak var otherInfoContentLabel: UILabel!
    @IBOutlet weak var otherInfoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var sympolLabel: UILabel!
    
    let bottomHeight: CGFloat = 425 + UIScreen.tabbarSafeBottomMargin
    var closeBlock: (()-> Void)?
    var confirmBlock: (()-> Void)?
    var model: HPBConfirmModel?{
        didSet{
            guard  let `model` = model else {
                return
            }
            toAddressLabel.text = model.toAddress
            currentAddressLabel.text = model.myAddress
            moneyLabel.text = model.money
            transferFeeContentLabel.text = model.fee
            otherInfoContentLabel.text = model.desc
            sympolLabel.text = model.sympol
            //HRC-721显示的是代币ID
            if model.sympolType == "HRC-721"{
                sympolLabel.text = nil
                moneyLabel.text = model.money
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocalizable()
        showAnimation()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeBtnClick))
        topView.addGestureRecognizer(gesture)
        
    }
    
    private func steupLocalizable(){
        switch type {
        case .transfer,.signTransfer:
            transferTipLabel.text = "Transfer-Title-Transfer".localizable
            payDetailLabel.text = "TransferConfirm-Details".localizable
        }
        transferFeeTitleLabel.text = "TransferDetail-Fees".localizable
        orderInfoLabel.text = "TransferConfirm-Order-Info".localizable
      
        transferInTipLabel.text = "TransferConfirm-Receiver".localizable
        payWalletTipLabel.text = "TransferConfirm-Sender".localizable
        confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
        
        //Dapp支付特有的
        otherInfoTitleLabel.text = "TransferConfirm-Addition-Info".localizable
        otherInfoContentLabel.text = ""
        if !self.isDappPay{
          otherInfoTitleLabel.isHidden = true
          otherInfoContentLabel.isHidden = true
          otherInfoTopConstraint.constant = -20
        }
        
    }
    
    private func showAnimation(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        bottomConstraint.constant = -bottomHeight
        btnBottomConstraint.constant = UIScreen.tabbarSafeBottomMargin + 25
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func hideAnimation(finish: (()-> Void)?){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint.constant = -self.bottomHeight
            self.view.layoutIfNeeded()
        }) {(state) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            finish?()
        }
    }
    
    
    deinit {
        debugLog("释放了")
    }
}

extension HPBTransferConfirmView{
    
    @IBAction func confirmBtnClick(_ sender: UIButton) {
        confirmBlock?()
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        hideAnimation {
             self.closeBlock?()
        }
    }
    
   
    
}
