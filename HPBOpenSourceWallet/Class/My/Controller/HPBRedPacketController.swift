//
//  HPBRedPacketController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/11.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class HPBRedPacketController: HPBBaseTableController {
    enum HPBRedPacketType: String{
        case normal = "1"
        case random = "2"
    }
    
    @IBOutlet weak var moneyRemainLabel: UILabel!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var remarkTextView: HPBTextView!
    @IBOutlet weak var rPLeftTipLabel: UILabel!
    @IBOutlet weak var rPRightTipLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var moneytitleLabel: UILabel!
    @IBOutlet weak var moneyContentField: HPBTextField!
    @IBOutlet weak var numberTitleLabel: UILabel!
    @IBOutlet weak var numberContentField: HPBTextField!
    @IBOutlet weak var feeTitleLabel: UILabel!
    @IBOutlet weak var feeContentLabel: UILabel!
    @IBOutlet weak var remarkNumberLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var redPacketBtn: HPBBackImgeButton!
    @IBOutlet weak var bottomTip: UILabel!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    let singleMoneyMaxLimit: Int  = 100
    let moneyMaxLimit: Int  = 10000
    let numberMaxLimit: Int = 100
    var redPacketType: HPBRedPacketType = .normal
    var singleFee: String = "-1"
    var currentBalance: String = "0"
    
    var recordRedPacketNo: String = ""
    //当前地址
    private lazy var currentWalletInfo: HPBWalletRealmModel? = {
        return  HPBWalletManager.getCurrentWalletInfo()
    }()
    var transferFeeModel: HPBTransferFeeModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News-Send-RedPacket".localizable
        steupLocalizable()
        steupViews()
        configNavigationItem()
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
     fileprivate func steupLocalizable(){
        typeLabel.text  = "News-RedPacket-Send-Type-Normal".localizable
        currencyTitleLabel.text = "pM2-UB-JvS.text".MainLocalizable
        moneyRemainLabel.text = "Common-balance".localizable + ": " + HPBStringUtil.converHpbMoneyFormat(currentBalance).noneNull + " HPB"
        feeTitleLabel.text = "TransferDetail-Fees".localizable
        numberTitleLabel.text = "News-RedPacket-Number".localizable
        redPacketBtn.setTitle("News-RedPacket-SendButton".localizable, for: .normal)
        rPLeftTipLabel.text = "News-RedPacket-Single-Tip-1".localizable
        rPRightTipLabel.text = "News-RedPacket-Single-Tip-2".localizable
        moneytitleLabel.text  = "News-RedPacket-Single-Money".localizable
        bottomTip.text = "News-RedPacket-BottomTip-24H".localizable
        moneyContentField.placeholder = "News-RedPacket-Money—Input".localizable
        numberContentField.placeholder = "News-RedPacket-Number—Input".localizable
        
    }
    
    
    fileprivate func steupViews(){
        
        //获取手续费
        configTradeFee(){(model) in
            let transferFee = HPBStringUtil.converDecimal(model.gasPrice, model.gasLimit, 0, type: .multiplying)
            self.feeContentLabel.text = HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull + "HPB"
            self.singleFee = HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull
        }
        getBalance()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(modifyRedPacketType))
        rPRightTipLabel.addGestureRecognizer(tapGesture)
        remarkTextView.placehoder = "News-RedPacket-Placehoder".localizable
        remarkTextView.placehoderLabelFont = 14
        remarkTextView.placehoderLabelFont = 14
        remarkTextView.limitMax  = 25
        remarkTextView.inputNumberBlock = {[weak self] in
            self?.remarkNumberLabel.text = "\($0)/25"
        }
        remarkTextView.placehoderLabel.snp.updateConstraints { (make) in
            make.top.equalTo(12)
        }
        remarkTextView.placehoderTopConstraint = 20
        moneyContentField.delegate = self
        numberContentField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange), name: NSNotification.Name.UITextFieldTextDidChange, object: moneyContentField)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange), name: NSNotification.Name.UITextFieldTextDidChange, object: numberContentField)
    }
    
    @objc func modifyRedPacketType(){
        redPacketType =  (redPacketType == .normal) ? .random :  .normal
        switch redPacketType{
        case .normal:
            rPLeftTipLabel.text = "News-RedPacket-Single-Tip-1".localizable
            rPRightTipLabel.text = "News-RedPacket-Single-Tip-2".localizable
            moneytitleLabel.text  = "News-RedPacket-Single-Money".localizable
            typeLabel.text  = "News-RedPacket-Send-Type-Normal".localizable
        case .random:
            rPLeftTipLabel.text = "News-RedPacket-Random-Tip-1".localizable
            rPRightTipLabel.text = "News-RedPacket-Random-Tip-2".localizable
            moneytitleLabel.text  = "News-RedPacket-Total-Money".localizable
            typeLabel.text  = "News-RedPacket-Send-Type-Random".localizable
        }
        
       clearInput()
        
    }
    
    fileprivate func clearInput(){
        moneyContentField.text = ""
        numberContentField.text = ""
        if let model = transferFeeModel{
            let transferFee = HPBStringUtil.converDecimal(model.gasPrice, model.gasLimit, 0, type: .multiplying)
            self.feeContentLabel.text = HPBStringUtil.converHpbMoneyFormat(transferFee).noneNull + "HPB"
        }
        totalMoneyLabel.text = "0.00"
        self.remarkTextView.content = ""
        
    }
    
    fileprivate func configNavigationItem(){
        let barButtonItem = HPBBarButton.init(title: "News-RedPacket-Record".localizable)
        barButtonItem.clickBlock = {[weak self] in
            self?.rightItemClicked()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    
    
    
    @objc func rightItemClicked() {
        
         let redpacketRecordVC = HPBRedPacketRecordController()
        self.navigationController?.pushViewController(redpacketRecordVC, animated: true)
        
    }
    
    fileprivate func configTradeFee(finish: ((HPBTransferFeeModel)-> Void)?){
        
        //HPB公链普通交易
        HPBMainViewModel.getTradeFeeRequest(account: currentWalletInfo?.addressStr, type: .transfer, success: { (model) in
            self.transferFeeModel = model
            finish?(model)
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg, view: self.view)
        }
    }
    
    fileprivate func getBalance(){
        
        //查询交易余额
        HPBMainViewModel.getHPBAccountBalance(address: HPBStringUtil.noneNull(currentWalletInfo?.addressStr), success: { (balance) in
            self.moneyRemainLabel.text = "Common-balance".localizable + ": " + HPBStringUtil.converHpbMoneyFormat(balance.noneNull).noneNull + " HPB"
            self.currentBalance = balance.noneNull
        }) { (errorMsg) in
        }
        
    }
    
    
    
    @IBAction func transferFeeClick(_ sender: UIButton) {
        let webView =   HPBWebViewController()
        webView.webTitle = "TransferDetail-Fees".localizable
        webView.url = HPBWebViewURL.gasprice.webViewUrllocalizable
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    
    
    @IBAction func redBtnClick(_ sender: HPBButton) {
        
        let totalMoneyStr =  totalMoneyLabel.text.noneNull.replacingOccurrences(of: " HPB", with: "")
        let totalFeeStr = feeContentLabel.text.noneNull.replacingOccurrences(of: " HPB", with: "")
        
        let transferFeeStr = self.feeContentLabel.text
        let totalFormatlMoney = HPBStringUtil.moneyFormatToString(value: totalMoneyStr)
        let totalfeeMoney = HPBStringUtil.moneyFormatToString(value: totalFeeStr)
        let allCost = HPBStringUtil.converDecimal(totalFormatlMoney, totalfeeMoney, 8, type: .adding)
        let ethAllCost = HPBStringUtil.converEthMoneyStr(allCost)
        let numberContent = self.numberContentField.text.noneNull
        
        if totalFormatlMoney.doubleValue == 0{
            showBriefMessage(message: "News-RedPacket-Money-Empty-Tip".localizable, view: self.view)
            return
        }else if transferFeeStr == "kBI-lc-vb7.text".MainLocalizable{
            showBriefMessage(message: "Transfer-Get-Fee-Faile".localizable, view: self.view)
            return
        }else if numberContentField.text.noneNull.intValue == 0{
            showBriefMessage(message: "News-RedPacket-Number-Empty-Tip".localizable, view: self.view)
            return
        }
        else if HPBStringUtil.compare(ethAllCost, self.currentBalance) == .orderedDescending{
            showBriefMessage(message: "News-RedPacket-Beyong-MaxMoney-Tip".localizable, view: self.view)
        }else{
            
            //对拼手气红包单独配置
            if redPacketType == .random{
                if totalFormatlMoney.doubleValue / numberContent.doubleValue < 0.01{
                    showBriefMessage(message: "News-RedPacket-Money-0.01HPB-Tip".localizable, view: self.view)
                    return
                }
            }

            //生成预订单
            showHudText(view: self.view)
            
            //获取当前Nonce
            configTradeFee { (model) in
                ///备注:1.5.0版本添加代理地址 proxyAddr,我把它赋值到toAddress上面
                self.getReadySendRedPacketNetwork(success: { (valuesArr, packetNo,proxyAddr) in
                    hideHUD(view: self.view)
                    self.recordRedPacketNo  = packetNo
                    var totalMoneyLocation = "共\(totalMoneyStr)HPB"
                    if HPBLanguageUtil.share.language == .english{
                        totalMoneyLocation = "\(totalMoneyStr)HPB in Total"
                    }
                    
                    //冷钱包
                    if HPBUserMannager.shared.currentWalletInfo?.isColdAddress == "1"{
                        showBriefMessage(message: "Common-ColdWallet-cannot".localizable, view: self.view)
                        ///签名太长会引起崩溃的现象
                        /*
                        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
                        HPBMainViewModel.getTradeFeeRequest(account: currentAddress.noneNull, type: .transfer, success: { (model) in
                            let number = self.numberContentField.text.noneNull.intValue
                            let dataStr = HPBMainViewModel.transactionSinature(addParam: [number,valuesArr,proxyAddr], constractAdd: HPBAPPConfig.redPacketContractAddr, type: .redPacket)
    
                            let allGasLimit =  HPBStringUtil.converDecimal(model.gasLimit, "\(number)",0, type: .multiplying)
                            var qrCodeArr: [Any] = ["1"]
                            let qrCodeDic: [String: String] = ["from": currentAddress.noneNull,
                                                               "to": proxyAddr,
                                                               "content": "发红包授权",
                                "money": allCost,
                                "gaslimt": allGasLimit,
                                "gasprice": model.gasPrice,
                                "nonce": "\(model.nonce)",
                                "data": dataStr.noneNull,
                                "contractAddress": proxyAddr]
                            qrCodeArr.append(qrCodeDic)
                            HPBColdImageCodeManager.share.showClodWalletImageCode(qrCodeArr, nav: self.navigationController){
                                //显示红包
                              self.showRedPacketView(packetNo,currentAddress.noneNull)
                            }
                            
                        }) { (errorMsg) in
                            showBriefMessage(message: errorMsg,view: self.tableView)
                        }*/
                        return
                    }
            
                    HPBAlertView.showPasswordAlert(in: self, title: "News-RedPacket-SendButton".localizable, message: "\("News-RedPacket-SendButton".localizable)，\(totalMoneyLocation)") { (password) in
                        //签名过程
                        let fromAdd = HPBUserMannager.shared.currentWalletInfo?.addressStr
                        let number = self.numberContentField.text.noneNull.intValue
                        showHudText(view: self.view)
                        HPBMainViewModel.signContractTransaction(fromAddress: fromAdd, toAddress: proxyAddr, constractAdd: HPBAPPConfig.redPacketContractAddr, money: allCost, feeModel: model, password: password.noneNull, addParam: [number,valuesArr], type: HPBMainViewModel.HPBContractSinature.redPacket, success: { (sinaguture) in
                            //正式发送签名
                            self.sendRedPacketNetwork(packetNo: packetNo, signature: sinaguture.addHexPrefix()){
                                //显示红包
                                self.showRedPacketView(packetNo,fromAdd.noneNull)
                            }
                        }, failure: { (errorMsg) in
                            showBriefMessage(message: errorMsg, view: self.view)
                        })
                    }
                    
                })
            }
        }
    }
    
    
    
}


extension HPBRedPacketController: UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.redPacketBtn.isSelected = false
        if !moneyContentField.text.noneNull.isEmpty && !numberContentField.text.noneNull.isEmpty{
            self.redPacketBtn.isSelected = true
            // 计算总金额
            if redPacketType == .normal{
                let formatMoney = HPBStringUtil.moneyFormatToString(value: moneyContentField.text.noneNull)
                totalMoneyLabel.text = HPBStringUtil.converDecimal(formatMoney, numberContentField.text.noneNull, 2, type: .multiplying,roundingMode: .up).addMicrometerLevel(digitsNumber: 2)
            }else{
                totalMoneyLabel.text = moneyContentField.text.noneNull
            }
        }
        
        
    }
    
    @objc func textFieldChange(userInfo: NSNotification){
        
        //金额大小判断
        if let textfield = userInfo.object as? UITextField{
            if textfield == numberContentField{
                if textfield.text.noneNull.intValue > numberMaxLimit{
                    showBriefMessage(message: "News-RedPacket-Number-100-Tip".localizable,view: self.view)
                    textfield.text = "\(numberMaxLimit)"
                }
            }else{
                
                var maxLimit = singleMoneyMaxLimit
                var maxLimitTip = "News-RedPacket-Money-10HPB-Tip".localizable
                if redPacketType == .random{
                  maxLimit = moneyMaxLimit
                  maxLimitTip = "News-RedPacket-Money-100HPB-Tip".localizable
                }
                let dotSeparator = HPBNumberStyleUtil.share.style.dotSeparator
                if moneyContentField.text.noneNull == dotSeparator{
                    moneyContentField.text = "0" + dotSeparator
                }
                if moneyContentField.text.noneNull.contains(dotSeparator){
                    let formatMoney =  HPBStringUtil.moneyFormatToString(value: moneyContentField.text.noneNull)
                    if formatMoney.doubleValue > Double(maxLimit){
                        showBriefMessage(message: maxLimitTip ,view: self.view)
                        textfield.text = "\(maxLimit)"
                    }
                }else{
                    if textfield.text.noneNull.intValue > maxLimit{
                        showBriefMessage(message: maxLimitTip ,view: self.view)
                        textfield.text = "\(maxLimit)"
                    }
                }
                
            }
        }
        
        //手续费计算
        if !numberContentField.text.noneNull.isEmpty && self.singleFee != "-1"{
            let number = numberContentField.text.noneNull.intValue
            let feeStr =  HPBStringUtil.converDecimal("\(number)", HPBStringUtil.moneyFormatToString(value: self.singleFee), type: .multiplying, roundingMode: .up).addMicrometerLevel()
            feeContentLabel.text = feeStr + " HPB"
        }
    }
        
        
        func  textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
            
            // 个数最低不做限制
            if textField == numberContentField{
                // 限制输入3位数
                if !string.isEmpty && numberContentField.text.noneNull.count == 3{
                        return false
                }
                return true
            }
            
            // 金额进行最低限制
            let currentText = textField.text
            let dotSeparator = HPBNumberStyleUtil.share.style.dotSeparator
            
            //判断不能输入多次符号
            if moneyContentField.text.noneNull.contains(dotSeparator) && !string.isEmpty{
                //防止选择中文显示模式，但是选择德国键盘的情况http://21f803q652.51mypc.cn:47331/zentao/file-read-1074.png
                if string == HPBNumberStyleUtil.NumberStyle.china.dotSeparator ||
                    string == HPBNumberStyleUtil.NumberStyle.germany.dotSeparator{
                    return false
                }
            }
            
            //装逼的国际化千分位分割
            if string == HPBNumberStyleUtil.share.style.thousandSeparator{
                if currentText.noneNull.isEmpty{
                    textField.text = "0" + dotSeparator
                }else{
                    textField.text = currentText?.appending(dotSeparator)
                }
                return false
            }
            //保留2位小数
            if moneyContentField.text.noneNull.contains(dotSeparator) && !string.isEmpty{
                let dotArray = moneyContentField.text.noneNull.components(separatedBy: dotSeparator)
                if dotArray.count != 2 {return false} //数组个数一定为2，防止异常bug，加此句
                if dotArray[1].count == 2{
                    return false
                }
            }
            
            //限制输入3位
            if !moneyContentField.text.noneNull.contains(dotSeparator) && !string.isEmpty{
                if moneyContentField.text.noneNull.count == 5{
                    return false
                }
            }
            return true
        }
}




extension HPBRedPacketController{
    
    func getReadySendRedPacketNetwork(success: (([String],String,String) -> Void)?){
    
        let  currentAddress = HPBStringUtil.noneNull(currentWalletInfo?.addressStr)
        let totalMoneyStr =  totalMoneyLabel.text.noneNull.replacingOccurrences(of: " HPB", with: "")
        let formatTotalMoneyStr = HPBStringUtil.moneyFormatToString(value: totalMoneyStr)
        let totalHPBAllCost = HPBStringUtil.converEthMoneyStr(formatTotalMoneyStr)
        let totalNumber = numberContentField.text.noneNull
        let tips = remarkTextView.content.noneNull.isEmpty ?  remarkTextView.placehoder.noneNull : remarkTextView.content.noneNull
        let (requestUrl,param) = HPBAppInterface.readySendRedPacket(address:currentAddress, money: totalHPBAllCost, number: totalNumber, type: self.redPacketType.rawValue, tip: tips)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBRedPacketReadyModel? else{
                    return
                }
                //赋值新的红包的合约地址
                HPBAPPConfig.redPacketContractAddr = model.contractAddr
                success?(model.valuesArr,model.packetNo,model.proxyAddr)
                
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        
        }
    }
    
    func sendRedPacketNetwork(packetNo: String,signature: String,success: (()-> Void)?){
          let (requestUrl,param) = HPBAppInterface.sendRedPacket(redPacketNo: packetNo, sinagature: signature)
         HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                hideHUD(view: self.view)
                success?()
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
    
    
    
    func showRedPacketView(_ packetNo: String,_ fromAdd: String){
        let redsendView = HPBViewUtil.instantiateViewWithBundeleName(HPBRedPacketFinishView.self, bundle: nil) as! HPBRedPacketFinishView
        AppDelegate.shared.window?.rootViewController?.view.addSubview(redsendView)
        redsendView.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        let totalMoneyStr =  totalMoneyLabel.text.noneNull.replacingOccurrences(of: " HPB", with: "")
        var totalMoneyLocation = "\(self.numberContentField.text.noneNull)个红包,共\(totalMoneyStr) HPB"
        var shareContent = "来自\(fromAdd.cutOutAddress())的HPB红包"
        if HPBLanguageUtil.share.language == .english{
            totalMoneyLocation = "\(self.numberContentField.text.noneNull)Red Packets,\(totalMoneyStr) HPB in Total"
            shareContent = "A Red Packet from \(fromAdd.cutOutAddress())"
        }
        redsendView.redPacketInfo = totalMoneyLocation
        redsendView.redPacketID = packetNo
        redsendView.sendBlock = {
            let model = HPBShareLinkModel()
            let tips = self.remarkTextView.content.noneNull.isEmpty ?  self.remarkTextView.placehoder.noneNull : self.remarkTextView.content.noneNull
            model.address = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.addressStr)
            model.webUrl = HPBAPPConfig.redPacketShareURL + "?id=\(self.recordRedPacketNo)&lang=\(HPBLanguageUtil.share.language.redPacketStr)"
            model.title  = tips
            model.content = shareContent
            model.image = "common_share_redPacket"
            HPBShareManager.shared.additionalInfo = model
            HPBShareManager.shared.show(.redpacket, currentController: self)
        }
    }
    
   
}
