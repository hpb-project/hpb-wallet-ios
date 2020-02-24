//
//  HPBTransferController+Extension.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/5.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation


extension HPBTransferController{

    enum HPBTokenType: String {
        case mainNet = "Transfer-MainNet-Coin"
        case HRC20 = "HRC-20"
        case HRC721 = "HRC-721"

        var requestStr: String{
            get{
                switch self {
                case .mainNet:
                    return "HPB"
                case .HRC20:
                    return "HRC-20"
                case .HRC721:
                    return "HRC-721"
                }
            }
        }
        init(index: String){
            if index == "0"{
                self =  .mainNet
            }else if index == "1"{
                 self = .HRC20
            }else if index == "2"{
                 self = .HRC721
            }else{
                self = .mainNet
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            if type == .transfer{  //普通转账
                return 2
            }else{
                return 0
            }
        case 2:
            if type == .transfer{   //适用于映射
                return 0
            }else{
                return 2
            }
        case 3:
            switch recordTokenType{      //代币转移
            case .mainNet:
                return 2
            case .HRC20:
                 return 2
            case .HRC721:
                return 3
            }
        case 4:
            if recordTokenType == .mainNet{ //主网币转移
               return 1
            }else if recordTokenType == .HRC20{
               return 1
            }else{
                return 0
            }
        case 5:
            return 4
        default:
            return 0
        }
    }
    
    func showSelectTypeView(_ dataSource:[(String,String)],_ pickerType: HPBPicketView.HPBPickerViewType,selectBlock: ((String)->Void)? = nil){
        guard let selectTypeView = HPBViewUtil.instantiateViewWithBundeleName(HPBPicketView.self, bundle: nil)as? HPBPicketView else{return}
        selectTypeView.pickerViewType = pickerType
        selectTypeView.selectBlock = {
            ///记录代币转账的合约地址(HRC-20和HRC-21)
            if pickerType == .topAndBottom{
              self.hrcContractAddress = self.hrcModels?[$0.intValue].contractAddress
            }
            selectBlock?($0)
        }
        AppDelegate.shared.window?.addSubview(selectTypeView)
        if pickerType == .singleLine{
             selectTypeView.selectDataSourceStr = self.recordTokenType.rawValue.localizable
            selectTypeView.topTitle = "Transfer-Select-Currency-Type".localizable
        }else if pickerType == .topAndBottom{
             selectTypeView.selectDataSourceStr = self.recordTokenName
            selectTypeView.topTitle = "Transfer-Select-Token".localizable
        }
         selectTypeView.dataSources = dataSource
         selectTypeView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //默认选中的行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            selectTypeView.initSelectRow()
        }
    }
    
    
  
}



extension HPBTransferController{
    
    //选择代币
    @IBAction func selectTokenTypeClick(_ sender: UIButton) {
        showSelectTypeView([(HPBTokenType.mainNet.rawValue.localizable,""),
                            (HPBTokenType.HRC20.rawValue.localizable,""),
                            (HPBTokenType.HRC721.rawValue.localizable,"")],.singleLine){[weak self] in
                                let tokenType = HPBTokenType.init(index: $0)
                                self?.selectTokenTypeField.text = tokenType.rawValue.localizable
                                self?.recordTokenType = tokenType
                                self?.queryHRCABalance(type: tokenType)
                                
        }
    }
    
    
    ///选择具体的token
    @IBAction func selectOneTokenClick(_ sender: UIButton) {
        if self.hrcModels != nil {
            guard let hrcModels = self.hrcModels else{return}
            if hrcModels.isEmpty{
                showBriefMessage(message: "Transfer-NO-Available-Tokens".localizable, view: self.view)
                return
            }
            ///传递过去 《代币名称》 和 《余额》(HPB 是18Gwei ,HRC-20是 自定义位数,,HRC-721是 自然数字)
            var dataSource: [(String,String)] = []
            for model in self.hrcModels!{
                if self.recordTokenType == .HRC20{
                     dataSource.append((model.symbol, HPBStringUtil.converCustomDigitsFormat(model.tokenNum,decimalCount: model.formatDecimals).noneNull))
                }else if recordTokenType == .HRC721{
                    dataSource.append((model.symbol, model.tokenNum))
                }
            }
            //显示并记录选择的类型
            showSelectTypeView(dataSource,.topAndBottom){
                self.selectERC721IDField.text = nil     //选择其他的HRC721-Token后,已经选择的id要消失
                self.selectSingleTokenField.text = hrcModels[$0.intValue].symbol
                self.recordTokenName = hrcModels[$0.intValue].symbol
                self.remandToken = hrcModels[$0.intValue].tokenNum
                self.sympolLabel.text = self.recordTokenName

                ///HRC-20才会使用这个
                self.recordTokenDecimals = hrcModels[$0.intValue].formatDecimals
                self.moneyTextfield.placeholder = "Transfer-remain".localizable + HPBStringUtil.converCustomDigitsFormat(self.remandToken.noneNull, decimalCount: self.recordTokenDecimals).noneNull

            }
        }else{
            //重新去请求
            self.queryHRCABalance(type: self.recordTokenType)
        }
    }
    
    
    ///选择HRC721代币ID
    @IBAction func selectHRC721Click(_ sender: UIButton) {
        if self.recordTokenName.isEmpty{
            showBriefMessage(message: "Transfer-First-Select-Tip".localizable, view: self.view)
            return
        }
        let selectVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBHRC721SelectIDController") as! HPBHRC721SelectIDController
        selectVC.contractAddress = self.hrcContractAddress
        selectVC.selectBlock = {
            self.selectERC721IDField.text = $0
            self.judgeTransferBtnState()
        }
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    

}


extension HPBTransferController{

    func queryHRCABalance(type: HPBTokenType,_ isInitRequest: Bool = false){
        if !isInitRequest{
            self.moneyTextfield.placeholder = nil
            self.sympolLabel.text = nil
            self.selectERC721IDField.text = nil
            self.moneyTextfield.text = nil
        }
        switch type{
        case .mainNet:
            self.recordTokenDecimals = 18
            self.recordTokenName = "HPB"
            self.selectSingleTokenField.text = "HPB"
            self.selectTokenBtn.isHidden = true
            self.sympolLabel.text = "HPB"
        case .HRC20:
            self.selectSingleTokenField.text = nil
            self.selectTokenBtn.isHidden = false
        case .HRC721:
            self.recordTokenDecimals = 0
            self.selectSingleTokenField.text = nil
            self.selectTokenBtn.isHidden = false
        }
        showHudText(view: self.view)
        let selectTypeStr = type.requestStr
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let (requestUrl,param) = HPBAppInterface.getCurrentAddressHRCAssert(address: currentAddress.noneNull,type: selectTypeStr)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                hideHUD(view: self.view)
                guard let models =  HPBBaseModel.mp_effectiveModels(result: result,key: "list") as [HPBHRCModel]? else{return}
                self.hrcModels = models
                /// 选择后界面配置处理
                if type == .mainNet{
                     self.inputMoneyLabel.text = "dXL-t1-9Vq.text".MainLocalizable
                     self.selectTokenTitleLabel.text = "Common-MainNet-Coin".localizable
                    if !models.isEmpty{
                        self.remandToken = models[0].balance
                        self.moneyTextfield.placeholder = "Transfer-remain".localizable + HPBStringUtil.converHpbMoneyFormat(self.remandToken.noneNull).noneNull
                    }
                }else{
                    self.inputMoneyLabel.text = "Transfer-Out-Title-Quantity".localizable
                    self.selectTokenTitleLabel.text = "Common-HRC-Token".localizable
                    if !isInitRequest{
                        self.recordTokenName = ""
                        self.remandToken = "0"
                    }
                }
                self.tableView.reloadData()
            }else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
    


}
