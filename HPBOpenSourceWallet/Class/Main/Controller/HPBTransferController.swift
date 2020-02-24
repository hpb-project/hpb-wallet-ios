//
//  HPBTransferController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/13.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//  1.5.0版本优化后,只有映射和转账共用,删除冷钱包的界面,再扫码界面直接发送了(之前是在转账界面)

import UIKit
import HPBWeb3SDK


class HPBTransferController: HPBBaseTableController,UITextFieldDelegate {
    
    @IBOutlet weak var remandMoneyLabel: UILabel!
    @IBOutlet weak var moneyTextfield: HPBTextField!
    @IBOutlet weak var addressfield: HPBTextField!
    @IBOutlet weak var transferBtn: HPBBackImgeButton!
    @IBOutlet weak var transferFeeContentLabel: UILabel!
    @IBOutlet weak var transferinContentLabel: UILabel!
    @IBOutlet weak var transferOutContentLabel: UILabel!
    @IBOutlet weak var addressContentShowLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var inputMoneyLabel: UILabel!
    @IBOutlet weak var allTransferOutBtn: UIButton!
    @IBOutlet weak var transferFeeTitleLabel: UILabel!
    @IBOutlet weak var transferIntitleLabel: UILabel!
    @IBOutlet weak var transferOutTitleLabel: UILabel!
    @IBOutlet weak var transOutTLabel: UILabel!
    @IBOutlet weak var transferOutAddressLabel: UILabel!
    //2.0.0添加阴影
    @IBOutlet var allBackViews: [UIView]!
    @IBOutlet weak var selectTokenBtn: UIButton!
    @IBOutlet weak var selectTokenTypeField: HPBTextField!
    @IBOutlet weak var selectSingleTokenField: HPBTextField!
    @IBOutlet weak var selectERC721IDField: HPBTextField!
    @IBOutlet weak var remaindIDLabel: UILabel!
    @IBOutlet weak var selectHRC721IDBtn: UIButton!
    @IBOutlet weak var selectTokenTypeBtn: UIButton!
    @IBOutlet weak var sympolLabel: UILabel!
    @IBOutlet weak var currenyTypeLabel: UILabel!
    @IBOutlet weak var selectTokenTitleLabel: UILabel!
    @IBOutlet weak var transfer721TokenIDLabel: UILabel!
    @IBOutlet weak var select721TokenIDBtn: UIButton!
    
    var scanResult: String?            //扫码出来的地址
    var remandToken: String? = "0"     // HPB 及 HRC-20.HRC-721使用的剩余Token数量
    var hrcModels: [HPBHRCModel]?   //所有代币的余额
    var type: HPBMainViewModel.HPBTransferType = .transfer     //映射-转账-冷钱包签名
    var initTokenType: HPBTokenType = .mainNet   //初始化设置的代币类型(HRC20-HRC721)
    var recordTokenType: HPBTokenType = .mainNet //记录选择的代币类型
    var recordTokenName: String = "HPB"          //记录选择的代币名称
    var recordTokenDecimals: Int = 18            //记录选择的代币精度(主网币18,HRC-20是自定义.HRC-721是0)
    var hrcContractAddress: String?              //记录选择的合约地址
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }

    //普通转账，要转出的地址，为当前地址
    lazy var currentWalletInfo: HPBWalletRealmModel? = {
        return  HPBWalletManager.getCurrentWalletInfo()
    }()
    //交易费用 + Noncee
    var transferGas: String = "0"
    var transferFeeModel: HPBTransferFeeModel?
    
    //映射独有的
    var mappingFromAddress: String?
    var mappingRemandHPBToken: String? = "0"
}

extension HPBTransferController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
        steupLocalizable()
        steupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController,barColor: UIColor.paBackground)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension HPBTransferController{
    
    fileprivate func steupLocalizable(){
        self.title = self.type.descrip.localizable
        transferBtn.setTitle("Transfer-Btn-Send".localizable, for: .normal)
        moneyTextfield.placeholder = "YQj-J3-V3b.placeholder".MainLocalizable
        addressfield.placeholder = "8S4-nd-LlO.placeholder".MainLocalizable
        moneyTextfield.setPlaceHoder()
        addressfield.setPlaceHoder()
        addressLabel.text = "byX-mD-TXe.text".MainLocalizable
        promptLabel.text = "g8z-bV-uUd.text".MainLocalizable
        inputMoneyLabel.text = "dXL-t1-9Vq.text".MainLocalizable
        allTransferOutBtn.setTitle("swJ-zW-3gf.normalTitle".MainLocalizable, for: .normal)
        transferFeeTitleLabel.text = "TransferDetail-Fees".localizable
        transferIntitleLabel.text = "Pbl-cX-BaO.text".MainLocalizable
        transferOutTitleLabel.text = "xdS-Dx-FPf.text".MainLocalizable
        transferFeeContentLabel.text = "kBI-lc-vb7.text".MainLocalizable
        transOutTLabel.text = "xdS-Dx-FPf.text".MainLocalizable
        currenyTypeLabel.text = "Transfer-Currency-Type".localizable
        select721TokenIDBtn.setTitle("Transfer-Select-ID-Button".localizable, for: .normal)
        transfer721TokenIDLabel.text = "Transfer-721-Transfer-ID".localizable
        selectTokenTitleLabel.text = "Common-MainNet-Coin".localizable
        
    }
    fileprivate func steupViews(){
        //2.0.0需求适配
        steupHRCViews()
        
        moneyTextfield.keyboardType = .decimalPad
        addressfield.keyboardType = .asciiCapable
        moneyTextfield.delegate = self
        addressfield.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange), name: NSNotification.Name.UITextFieldTextDidChange, object: moneyTextfield)
        
        switch self.recordTokenType {
        case .HRC20:
            self.selectSingleTokenField.text = self.recordTokenName
            self.sympolLabel.text = self.recordTokenName
            self.moneyTextfield.placeholder = "Transfer-remain".localizable + HPBStringUtil.converHpbMoneyFormat(remandToken.noneNull).noneNull
        case .HRC721:
             self.selectSingleTokenField.text = self.recordTokenName
             self.sympolLabel.text = self.recordTokenName
        case .mainNet:
            self.selectSingleTokenField.text = "HPB"
            self.sympolLabel.text = "HPB"
            self.moneyTextfield.placeholder = "Transfer-remain".localizable + HPBStringUtil.converHpbMoneyFormat(remandToken.noneNull).noneNull
        }
       
        self.view.backgroundColor = UIColor.paBackground
        //差异化配置
        switch type {
        case .transfer:
            reloadScanData()
            configHPBChainTradeFee()
            transferOutAddressLabel.text = currentWalletInfo?.addressStr
        case .signTransfer:
            //冷钱包转账不会进入此界面了
            break
        }
    }
    
    func steupHRCViews(){
        //2.0.0需求适配
        for backView in allBackViews{
            backView.layer.shadowColor = UIColor.black.cgColor
            backView.layer.shadowOffset = CGSize.zero
            backView.layer.shadowOpacity = 0.15
            backView.layer.shadowRadius = 10
        }
        //HRC20 和 HRC721资产进行转账,先选中改币种类型
        self.selectTokenTypeField.text = initTokenType.rawValue.localizable
        self.recordTokenType = initTokenType
        ///初始化配置后去请求(映射不需要)
        switch type {
        case .transfer:
            queryHRCABalance(type: initTokenType,true)
        default:
            break
        }
        
       
    }
    
    
    
}

extension HPBTransferController{
    
    @IBAction func selectAddressListClick(_ sender: UIButton) {
        let addresslistVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBAddressBookController.self))
        (addresslistVC as? HPBAddressBookController)?.sourceType = .transfer
        (addresslistVC as? HPBAddressBookController)?.selectBlock = {
            let separatStr = "##HPB##"
            let array =  $0.components(separatedBy: separatStr)
            guard array.count == 3 else{return}
            self.scanResult = array[1]
            self.reloadScanData()
            self.judgeTransferBtnState()
        }
         navigationController?.pushViewController(addresslistVC, animated: true)
        
    }
    
    @IBAction func scanClick(_ sender: UIButton) {
        let  scanVC =  HPBScanController()
        scanVC.scanType = .transfer
        scanVC.successBlock = {
            self.scanResult = $0
            self.reloadScanData()
        }
        self.navigationController?.pushViewController(scanVC, animated: true)
        
    }
    
    func judgeTransferBtnState(){
        self.transferBtn.isSelected = false
        ///如果是HRC721的话,判断tokenID
        if self.recordTokenType == .HRC721{
            if !self.selectERC721IDField.text.noneNull.isEmpty && !addressfield.text.noneNull.isEmpty{
                self.transferBtn.isSelected = true
            }
        }
        
        //其他情况的判断
        if !moneyTextfield.text.noneNull.isEmpty{
            switch type {
            case .transfer:
                if !addressfield.text.noneNull.isEmpty{
                    self.transferBtn.isSelected = true
                }
            default:
                break
            }
        }
    }
    
    fileprivate func reloadScanData(){
        self.addressfield.text = scanResult.noneNull
        showReceivePlacehoderLabel(text: scanResult.noneNull) //显示收款地址，中间加省略号
        judgeTransferBtnState()
    }
}

extension HPBTransferController{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if addressfield == textField{
            showReceivePlacehoderLabel(false)  //显示收款地址，中间加省略号
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //显示收款地址，中间加省略号
        if addressfield == textField{
            showReceivePlacehoderLabel(text: textField.text)
        }
        //判断按钮颜色
        judgeTransferBtnState()
    }
    
    //显示收款地址，中间加省略号
    func showReceivePlacehoderLabel(_ state: Bool = true,text: String? = nil){
        if state{
            self.addressfield.textColor = UIColor.clear
            self.addressContentShowLabel.text = text
            self.addressContentShowLabel.isHidden = false
        }else{
            //显示收款地址，中间加省略号(隐藏label)
            self.addressfield.textColor = UIColor.hpbNewInputColor
            self.addressContentShowLabel.isHidden = true
        }
        
    }
    
    
    @objc func textFieldChange(userInfo: NSNotification){
        if let textfield = userInfo.object as? UITextField{
             let dotSeparator = HPBNumberStyleUtil.share.style.dotSeparator
            if moneyTextfield.text.noneNull == dotSeparator && textfield == moneyTextfield{
                moneyTextfield.text = "0" + dotSeparator
            }
        }
    }
    
    
    func  textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        //地址不做判断
        if addressfield == textField{
            return true
        }
        let currentText = textField.text
        let dotSeparator = HPBNumberStyleUtil.share.style.dotSeparator
        
        //判断不能输入多次符号
        if moneyTextfield.text.noneNull.contains(dotSeparator) && !string.isEmpty{
            //防止选择中文显示模式，但是选择德国键盘的情况
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
        
        //保留8位小数
        if moneyTextfield.text.noneNull.contains(dotSeparator) && !string.isEmpty{
            let dotArray = moneyTextfield.text.noneNull.components(separatedBy: dotSeparator)
            if dotArray.count != 2 {return false} //数组个数一定为2，防止异常bug，加此句
            if dotArray[1].count == 8{
                return false
            }
        }
        return true
    }
    
}

extension HPBTransferController{
    
    @IBAction func transferClick(_ sender: UIButton) {
        
        //HRC20转账
        if recordTokenType == .HRC20{
            hrc20TokenTransferClick()
            return
        }
        // HRC 721转账
        if recordTokenType == .HRC721{
            hrc721TokenTransferClick()
            return
        }
        
        // HPB转账
        if  type == .transfer{
            nomalHPBTokenTransferClick()
            return
        }
    }
    
     @IBAction func allTransferClick(_ sender: UIButton) {
        //映射可全部转出，普通转账要减去手续费,签名交易不处理
        var maxTransfer = "0"
        switch type{
        case .transfer:
            if transferFeeModel == nil{
                showBriefMessage(message: "Transfer-Get-Fee-Faile".localizable, view: self.view)
                return
            }
            let formatRemandToken = HPBStringUtil.moneyFormatToString(value: self.remandToken.noneNull)
            switch self.recordTokenType{
            case .HRC20:
                maxTransfer = HPBStringUtil.converCustomDigitsFormat(formatRemandToken,decimalCount: self.recordTokenDecimals).noneNull
            case .mainNet:
               let maxTransfer18GWei = HPBStringUtil.converDecimal(formatRemandToken, transferGas, 0, type: .subtracting)
                maxTransfer = HPBStringUtil.converHpbMoneyFormat(maxTransfer18GWei).noneNull
            default:
                break
            }
            case .signTransfer:
            break
        }
        if maxTransfer.doubleValue < 0{
            maxTransfer = "0"
        }
        self.moneyTextfield.text = maxTransfer
        judgeTransferBtnState()
    }
    
    @IBAction func transferFeeIntroduceClick(_ sender: UIButton) {
        let webView =   HPBWebViewController()
        webView.webTitle = "TransferDetail-Fees".localizable
        webView.url = HPBWebViewURL.gasprice.webViewUrllocalizable
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    
    func showConfirmView(fromAddress: String?,toAddress: String){
        let confirmVC =  HPBTransferConfirmView()
        confirmVC.type = self.type
        navigationController?.addChildViewController(confirmVC)
        navigationController?.view.addSubview(confirmVC.view)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        confirmVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        confirmVC.closeBlock = {[weak self] in
            guard let `self` = self else{return}
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        confirmVC.confirmBlock = { [weak self] in
            guard let `self` = self else{return}
             //HRC和普通交易 + 映射交易
            HPBAlertView.showPasswordAlert(in: self) {
                guard let password = $0 else {return}
                confirmVC.view.removeFromSuperview()
                confirmVC.removeFromParentViewController()
                switch self.type{
                case .transfer:
                     self.creatTradeRequest(toAddress, money: HPBStringUtil.moneyFormatToString(value: self.moneyTextfield.text.noneNull), password: password)
                default:
                    break
                }
            }
        }
        if self.recordTokenType == .HRC721{
            confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,toAddress,"\("Transfer-Token-ID".localizable): " + selectERC721IDField.text.noneNull, self.transferFeeContentLabel.text.noneNull,sympol: self.recordTokenName,sympolType: "HRC-721")
        }else{
           confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,toAddress,moneyTextfield.text.noneNull, self.transferFeeContentLabel.text.noneNull,sympol: self.recordTokenName)
        }
        
        
    }
    
    
    func showColdCTransferConfirmView(_ coldSignStr: String){
        let fromAddress = self.currentWalletInfo?.addressStr
        let toAddress = self.addressfield.text.noneNull
          let confirmVC =  HPBTransferConfirmView()
        confirmVC.type = .transfer
          navigationController?.addChildViewController(confirmVC)
          navigationController?.view.addSubview(confirmVC.view)
          navigationController?.interactivePopGestureRecognizer?.isEnabled = false
          confirmVC.view.snp.makeConstraints { (make) in
              make.edges.equalToSuperview()
          }
          confirmVC.closeBlock = {[weak self] in
              guard let `self` = self else{return}
              self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
          }
          confirmVC.confirmBlock = { [weak self] in
            confirmVC.view.removeFromSuperview()
            confirmVC.removeFromParentViewController()
           self?.sendSignatureRequest(coldSignStr)
          }
          if self.recordTokenType == .HRC721{
              confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,toAddress,"\("Transfer-Token-ID".localizable): " + selectERC721IDField.text.noneNull, self.transferFeeContentLabel.text.noneNull,sympol: self.recordTokenName,sympolType: "HRC-721")
          }else{
             confirmVC.model = HPBTransferConfirmView.HPBConfirmModel(fromAddress.noneNull,toAddress,moneyTextfield.text.noneNull, self.transferFeeContentLabel.text.noneNull,sympol: self.recordTokenName)
          }
          
          
      }
}


