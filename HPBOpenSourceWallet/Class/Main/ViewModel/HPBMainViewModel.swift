//
//  HPBMainViewModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/20.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import BigInt
import HPBWeb3SDK


class HPBMainViewModel {
    
    enum HPBTransferType{
        case transfer
        case signTransfer
        var descrip: String{
            switch self {
            case .transfer:
                return "Transfer-Title-Transfer"
            case .signTransfer:
                return "Transfer-Title-Transfer"
            }
        }
    }
    
    enum HPBContractSinature{
        case  mapping
        case  vote
        case  cancelVote
        case  webPay
        case  redPacket
        case  governanceVote
        case  setHolderAddr
        case  setApproval
        case  hrc20Transfer
        case  hrc721Transfer
        case  setBonusPercentage
        case  setBonusMoney
    }
    
    //查询HPB账户余额
    static func getHPBAccountBalance(address: String, success: @escaping ((String?) -> Void), failure: @escaping ((String?) -> Void)){
        let (requestUrl,param) = HPBAppInterface.getQuaryAccountBalance(account: address)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                success(HPBStringUtil.transformFromJSON(result))
            }else{
                failure(errorMsg)
            }
        }
    }
    
    //查询单个账户所有账户资产
    static func getLegalTenderBalance(address: String, success: @escaping ((HPBMainTokenLists) -> Void), failure: @escaping ((String?) -> Void)){
        let (requestUrl,param) = HPBAppInterface.getLegalTenderBalance(account: address)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBMainTokenLists? else{
                    return
                }
                success(model)
            }else{
                failure(errorMsg)
            }
        }
    }
    
    
    
    
    //批量查询账户余额(人民币,美元)
    static func getListBalance(accounts: [String], success: @escaping ((String,String,[HPBBalanceModel]) -> Void), failure: @escaping ((String?) -> Void)){
        let (requestUrl,param) = HPBAppInterface.getMoreLegalTenderBalances(accounts: accounts)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBBalanceListModels? else{
                    return
                }
                success(model.cnyTotalValue,model.usdTotalValue,model.list)
            }else{
                failure(errorMsg)
            }
        }
    }
    

    //获取交易的GasPrice、GasLimit和Nonce(映射和普通转账共用)
    static func getTradeFeeRequest(account: String?,type: HPBMainViewModel.HPBTransferType, success: ((HPBTransferFeeModel)->Void)?, failure: @escaping ((String?) -> Void)){
        
        var (requestUrl,param) = ("",[String: Any]())
        switch type {
        case .transfer:
        (requestUrl,param) = HPBAppInterface.getTradeNonce(account: account.noneNull)
        default:
            return
        }
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg != nil{
                failure(errorMsg)
            }else{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBTransferFeeModel? else{return}
                success?(model)
            }
        }
    }
    
    
    //普通签名
    static func signNomorlTransaction(nonce: BigUInt,
                                fromAddress: String?,
                                toAddress: String,
                                money: String,
                                data: Data = Data(),
                                feeModel: HPBTransferFeeModel?,
                                password: String,
                                success: @escaping ((String) -> Void),
                                failure: @escaping ((String?) -> Void)){
        
        guard let account = HPBAddress(fromAddress.noneNull) else{
            failure("invalid Address")
            return
        }
        guard let toAdress = HPBAddress(toAddress) else{
            failure("Transfer-Address-inValid".localizable)
            return
        }
        guard let `feeModel` = feeModel else {return}
        guard let keystoreManager = KeystoreManager.managerForPath(HPBFileManager.getKstoreDirectory()) else{
            failure("Signature failed")
            return
        }
        
        var options = Web3Options.defaultOptions()
        options.gasPrice = Web3Utils.parseToBigUInt(feeModel.gasPrice, units: .wei)
        options.gasLimit = Web3Utils.parseToBigUInt(feeModel.gasLimit, units: .wei)
        options.from = account
        options.value = Web3Utils.parseToBigUInt(money, units: .hpb)
        options.to = toAdress
        var transaction  = HPBTransaction(to: toAdress, data: data, options: options)
        transaction.UNSAFE_setChainID(BigUInt(269))
        transaction.nonce = nonce
        
        //验证账号密码是否正确
        let result = verificatPassword(account: fromAddress, password: password)
        if result.state{
            do {
                try Web3Signer.signTX(transaction: &transaction, keystore: keystoreManager, account: account, password: password,useExtraEntropy: false)
                debugLog(transaction.signature.noneNull)
                success(transaction.signature.noneNull)
            }catch{
                failure("Signature failed")
            }
        }else{
            failure(result.errorMsg)
        }
    }
    

    /// 智能合约的签名
    ///
    /// - Parameters:
    ///   - nonce: Nonce
    ///   - fromAddress: 发送人的地址
    ///   - toAddress: 收款人的地址
    ///   - constractAdd: 合约地址
    ///   - money: money
    ///   - feeModel: 手续费（包含Gasprice 和 GasLimit）
    ///   - password: 当前账户密码
    ///   - success: 成功的回调
    ///   - failure: 失败的回掉
    
    static func signContractTransaction(fromAddress: String?,
                                        toAddress: String,
                                        constractAdd: String,
                                        money: String,
                                        moneyUnit: Web3.Utils.Units = .hpb,
                                        feeModel: HPBTransferFeeModel?,
                                        password: String,
                                        otherParam: [String] = [],
                                        addParam:[Any] = [],
                                        type: HPBContractSinature = .mapping,
                                        success: @escaping ((String) -> Void),
                                        failure: @escaping ((String?) -> Void)){
        
        
        let web3Rinkeby = Web3.InfuraRinkebyWeb3()
        guard let account = HPBAddress(fromAddress.noneNull) else{
            failure("invalid Address")
            return
        }
        guard let toAdress = HPBAddress(toAddress) else{
            failure("Transfer-Address-inValid".localizable)
            return
        }
        guard let `feeModel` = feeModel else {return}
        guard let nonce = Web3Utils.parseToBigUInt("\(feeModel.nonce)", units: .wei)else{
            failure("invalid Nonce")
            return
        }
        guard let keystoreManager = KeystoreManager.managerForPath(HPBFileManager.getKstoreDirectory()) else{
            failure("Signature failed")
            return
        }
        if constractAdd.isEmpty{
            failure("ContractAddress inValid")
            return
        }
        let constractAddress = HPBAddress(constractAdd)
        web3Rinkeby.addKeystoreManager(keystoreManager)
        var options = Web3Options.defaultOptions()
        options.gasPrice = Web3Utils.parseToBigUInt(feeModel.gasPrice, units: .wei)
        options.gasLimit = Web3Utils.parseToBigUInt(feeModel.gasLimit, units: .wei)
        guard let testToken = web3Rinkeby.contract(Web3.Utils.erc20ABI, at: constractAddress, abiVersion: 2) else {
            failure("Signature failed")
            return
        }
        guard let ethMoney = Web3Utils.parseToBigUInt(money, units: moneyUnit) else{
            failure("Illegal input amount")
            return
        }
        
        //投票和映射的区别
        var tokenTransfer: TransactionIntermediate?
        switch type {
        case .mapping:
           tokenTransfer = testToken.method("transfer", parameters: [toAdress, ethMoney] as [AnyObject], options: options)
           tokenTransfer?.transaction.UNSAFE_setChainID(nil)
        case .vote:
            options.gasLimit = Web3Utils.parseToBigUInt("2500000", units: .wei)
           tokenTransfer = testToken.method("vote", parameters: [account,toAdress, ethMoney] as [AnyObject], options: options)
           tokenTransfer?.transaction.UNSAFE_setChainID(269)
            
        case .cancelVote:
            options.gasLimit = Web3Utils.parseToBigUInt("2500000", units: .wei)
            tokenTransfer = testToken.method("cancelVoteForCandidate", parameters: [account,toAdress, ethMoney] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
        case .webPay:
            guard otherParam.count >= 3 else{
                failure("Signature failed")
                return
            }
            let orderId = otherParam[0]
            let notifyUrl = otherParam[1]
            let decStr = otherParam[2]
            
            options.value = ethMoney
            tokenTransfer = testToken.method("generateOrderAndPay", parameters: [toAdress, ethMoney,orderId,notifyUrl,decStr] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
        case .redPacket:
            guard addParam.count >= 2  else{
                failure("Signature failed")
                return
            }
            let number = addParam[0] as! Int
            let allGasLimit =  HPBStringUtil.converDecimal(feeModel.gasLimit, "\(number)",0, type: .multiplying)
            options.gasLimit = Web3Utils.parseToBigUInt(allGasLimit, units: .wei)
            let valuesArr = addParam[1] as! NSArray
            var valueConventArr: [BigUInt] = []
            for value in valuesArr{
                guard let conventMoney = Web3Utils.parseToBigUInt("\(value)", units: .wei) else{
                   failure("Signature failed")
                    return
                }
                valueConventArr.append(conventMoney)
            }
            if valueConventArr.count != number{
                 failure("Signature failed")
                return
            }
            let accountArr = [HPBAddress](repeatElement(toAdress, count: number))
            options.value = ethMoney
            tokenTransfer = testToken.method("mintDedaultBatch", parameters: [accountArr, "","",valueConventArr] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
        case .governanceVote:
    
            guard addParam.count >= 3 else{
                failure("Signature failed")
                return
            }

            let issuseNO = addParam[0] as? String
            let flag = addParam[1]
            let voteNum = addParam[2] as? String
            
            guard let conventVoteNum = Web3Utils.parseToBigUInt("\(voteNum.noneNull)", units: .hpb) else{
                failure("Signature failed")
                return
            }
            tokenTransfer = testToken.method("voteProposal", parameters: [issuseNO.noneNull, flag,conventVoteNum] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
        case .setHolderAddr:
            guard otherParam.count >= 2 else{
                failure("Signature failed")
                return
            }
            let coinbaseAdd = otherParam[0]
            let holderAdd = otherParam[1]

            tokenTransfer = testToken.method("setHolderAddr", parameters: [coinbaseAdd, holderAdd] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
        case .setApproval:
            guard addParam.count >= 2 else{
                failure("Signature failed")
                return
            }
            
            guard let type = addParam[1] as? Bool,let toAdd = addParam[0] as? String else{
                failure("Signature failed")
                return
            }
            tokenTransfer = testToken.method("setApproval", parameters: [toAdd, type] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
        case .hrc20Transfer:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.HRC20ABI, at: constractAddress, abiVersion: 2) else {
                failure("Signature failed")
                return
            }
            guard otherParam.count >= 2 else{
                failure("Signature failed")
                return
            }
            let decimalsCount = otherParam[0]
            let transferToken = otherParam[1]
            guard let customTokenNumber = Web3Utils.parseToBigUInt(transferToken, decimals: decimalsCount.intValue) else{
                failure("Illegal input amount")
                return
            }
            tokenTransfer = customContract.method("transfer", parameters: [toAdress, customTokenNumber] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
            
         case .hrc721Transfer:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.HRC721ABI, at: constractAddress, abiVersion: 2) else {
                failure("Signature failed")
                return
            }
            guard otherParam.count >= 1 else{
                failure("Signature failed")
                return
            }
            let tokenID = otherParam[0]
            guard let conventTokenID = Web3Utils.parseToBigUInt("\(tokenID)", units: .wei) else{
                failure("Signature failed")
                return
            }
            tokenTransfer = customContract.method("transferFrom", parameters: [fromAddress.noneNull, toAdress,conventTokenID] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
            
            
            
        case .setBonusPercentage:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.setBonusPercentageABI, at: constractAddress, abiVersion: 2) else {
                failure("Signature failed")
                return
            }
            
            guard otherParam.count >= 2 else{
                failure("Signature failed")
                return
            }
            let candidateAddrs = otherParam[0]
            let percentage   = otherParam[1]
            
            
            guard let percentageUint8 = UInt8(percentage) else{
                failure("Signature failed")
                return
            }
            tokenTransfer = customContract.method("setBonusPercentage", parameters: [candidateAddrs, percentageUint8] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
            
            
            
        case .setBonusMoney:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.setBonusMoneyABI, at: constractAddress, abiVersion: 2) else {
                failure("Signature failed")
                return
            }
            guard otherParam.count >= 1 else{
                failure("Signature failed")
                return
            }
            let candidateAddrs = otherParam[0]
            options.value = ethMoney
            tokenTransfer = customContract.method("candidateDeposit", parameters: [candidateAddrs] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
            
        }
        
        guard let intermediateForTokenTransfer = tokenTransfer else {
            failure("Signature failed")
            return
        }
        //设置nonce
        intermediateForTokenTransfer.transaction.nonce = nonce
       
        //验证账号密码是否正确
        let result = verificatPassword(account: fromAddress, password: password)
        if result.state{
            do{
                try Web3Signer.signTX(transaction: &intermediateForTokenTransfer.transaction, keystore: keystoreManager, account: account, password: password,useExtraEntropy: false)
                debugLog(intermediateForTokenTransfer.transaction.signature.noneNull)
                success(intermediateForTokenTransfer.transaction.signature.noneNull)
            }catch{
               failure("Signature failed")
            }
            
        }else{
            failure(result.errorMsg)
        }
    }
    
    
    
    static func signNormalMsg(_ password: String,
                              sinatureStr: String,
                             currentAddress: String?,
                             success: @escaping ((String) -> Void),
                             failure: @escaping ((String?) -> Void)){
        
        guard let keystoreManager = KeystoreManager.managerForPath(HPBFileManager.getKstoreDirectory()) else{
            return
        }
        guard let account = HPBAddress(currentAddress.noneNull) else{
            return
        }
        //签名数据
        let data = Data(bytes: sinatureStr.bytes)
        //验证账号密码是否正确
        let result = HPBMainViewModel.verificatPassword(account: currentAddress, password: password)
        if !result.state{
            failure(result.errorMsg)
            return
        }
        guard let signMsg = try? Web3Signer.signPersonalMessage(data, keystore: keystoreManager, account: account, password: password,useExtraEntropy: false),
            let signData = signMsg else{
                failure("Signature failed")
                return
        }
        guard let unmarshalledSignature =  SECP256K1.unmarshalSignature(signatureData: signData) else{
            return
        }
        let v = BigUInt(unmarshalledSignature.v) + BigUInt(27)
        let r = BigUInt(Data(unmarshalledSignature.r))
        let s = BigUInt(Data(unmarshalledSignature.s))
        let fields = [v,r,s] as [AnyObject]
        guard let encode = RLP.encode(fields)else{
            failure("Signature failed")
            return
        }
        let signagure = encode.toHexString().addHexPrefix()
       success(signagure)
    }
    
    
    //发送HPB钱包签名（包括冷钱包的）
    static func sendHPBSignatureRequest(_ controller: UIViewController, signature: String,type: HPBMainViewModel.HPBTransferType = .transfer,success: ((String)->Void)?,faile: (()->Void)?){
        if type == .signTransfer{
            showHudText( view: controller.view)
        }
        let (requestUrl,param) = HPBAppInterface.getCreatTrade(signature: signature)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD()
            if errorMsg != nil{
                 faile?()
                showBriefMessage(message: errorMsg, view: controller.view)
            }else{
                guard let _ = result as? String else{return}
                hideHUD(view: controller.view)
                showBriefMessage(message: "Transfer-Submit".localizable, after: 1.5)
                if type == .transfer{   //普通的转账会回到首页刷新数据
                    success?(HPBStringUtil.transformFromJSON(result).noneNull)
                }
                controller.navigationController?.popViewController(animated: true)
            }
        }
    }

    /// 验证账户密码是否正确
    ///
    /// - Parameters:
    ///   - account: 账户地址
    ///   - password: 账户密码
    /// - Returns: 返回结果
    static func verificatPassword(account: String?,password: String) -> HPBWalletManager.WalletDataResult{
        let walletModel =  HPBWalletManager.getWalletInfoBy(address: account.noneNull)
        let result = HPBWalletManager.exportPrivateKey(HPBStringUtil.noneNull(walletModel?.kstoreName), password: password)
        return result
    }
    
    
    //弹出‘安全转账’的界面
    static func showSafeAlert( vc: UIViewController,gestureEnble: Bool = true){
        let tipViewVC =   HPBSafeTipController()
        vc.navigationController?.addChildViewController(tipViewVC)
        vc.navigationController?.view.addSubview(tipViewVC.view)
        tipViewVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        vc.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tipViewVC.finishBlock = {[weak vc] in
            if gestureEnble{
                vc?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    
    /// 获取显示资产状态
    static func getShowAssertFlag() -> Bool{
        if let state =  UserDefaults.standard.object(forKey: HPBUserDefaultsKey.hideAssertKey) as? Bool{
            return state
        }
        return true
    }
    
    
    // 处理本地隐藏状态
    static func setHiddenOrShowHandel(_ hidden: Bool){
        UserDefaults.standard.set(!hidden, forKey: HPBUserDefaultsKey.hideAssertKey)
        UserDefaults.standard.synchronize()
        //隐藏资产状态，发送通知
        NotificationCenter.default.post(name: Notification.Name.HPBHiddenAssert, object: nil)
    }
    
    
    static func showTipBackUpView(controller: UIViewController,backupBlock: (()->Void)?){
        let tipBackUpView =  HPBTipBackUpView()
        tipBackUpView.backupBlock = {
          backupBlock?()
        }
        controller.navigationController?.addChildViewController(tipBackUpView)
        controller.navigationController?.view.addSubview(tipBackUpView.view)
        tipBackUpView.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    
    
}


extension HPBMainViewModel{
    
    static func transactionSinature(otherParam: [String] = [],
                                         addParam:[Any] = [],
                                        constractAdd: String,
                                        type: HPBContractSinature = .hrc20Transfer) -> String?{
        let web3Rinkeby = Web3.InfuraRinkebyWeb3()
        let constractAddress = HPBAddress(constractAdd)
        guard let testToken = web3Rinkeby.contract(Web3.Utils.erc20ABI, at: constractAddress, abiVersion: 2) else {
            return nil
        }
        let options = Web3Options.defaultOptions()
        var tokenTransfer: TransactionIntermediate?
        switch type{
            
        case .vote:
            guard otherParam.count >= 2 else{
                return nil
            }
            let account = otherParam[0]
            let toAdress = otherParam[1]
            let money = otherParam[2]
            guard let ethMoney = Web3Utils.parseToBigUInt(money, units: .hpb) else{
                return nil
            }
            tokenTransfer = testToken.method("vote", parameters: [account,toAdress, ethMoney] as [AnyObject], options: options)
        case .cancelVote:
            guard otherParam.count >= 2 else{
                return nil
            }
            let account = otherParam[0]
            let toAdress = otherParam[1]
            let money = otherParam[2]
            guard let ethMoney = Web3Utils.parseToBigUInt(money, units: .hpb) else{
                return nil
            }
            tokenTransfer = testToken.method("cancelVoteForCandidate", parameters: [account,toAdress, ethMoney] as [AnyObject], options: options)
            tokenTransfer?.transaction.UNSAFE_setChainID(269)
        case .governanceVote:
            
            guard addParam.count >= 3 else{
                return nil
            }
            
            let issuseNO = addParam[0] as? String
            let flag = addParam[1]
            let voteNum = addParam[2] as? String
            
            guard let conventVoteNum = Web3Utils.parseToBigUInt("\(voteNum.noneNull)", units: .hpb) else{
             return nil
            }
            tokenTransfer = testToken.method("voteProposal", parameters: [issuseNO.noneNull, flag,conventVoteNum] as [AnyObject], options: options)

        case .hrc20Transfer:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.HRC20ABI, at: constractAddress, abiVersion: 2) else {
                return nil
            }
            guard otherParam.count >= 2 else{
                return nil
            }
            let decimalsCount = otherParam[0]
            let transferToken = otherParam[1]
            let toAdress = otherParam[2]
            guard let customTokenNumber = Web3Utils.parseToBigUInt(transferToken, decimals: decimalsCount.intValue) else{
                return nil
            }
            tokenTransfer = customContract.method("transfer", parameters: [toAdress, customTokenNumber] as [AnyObject], options: options)
        case .hrc721Transfer:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.HRC721ABI, at: constractAddress, abiVersion: 2) else {
                return nil
            }
            guard otherParam.count >= 3 else{
                return nil
            }
            let tokenID = otherParam[0]
            let fromAddress = otherParam[1]
            let toAdress = otherParam[2]
            guard let conventTokenID = Web3Utils.parseToBigUInt("\(tokenID)", units: .wei) else{
                return nil
            }
            tokenTransfer = customContract.method("transferFrom", parameters: [fromAddress, toAdress,conventTokenID] as [AnyObject], options: options)
            
        case .setHolderAddr:
            guard otherParam.count >= 2 else{
                return nil
            }
            let coinbaseAdd = otherParam[0]
            let holderAdd = otherParam[1]
            tokenTransfer = testToken.method("setHolderAddr", parameters: [coinbaseAdd, holderAdd] as [AnyObject], options: options)
        case .setApproval:
            guard addParam.count >= 2 else{
                return nil
            }
            
            guard let type = addParam[1] as? Bool,let toAdd = addParam[0] as? String else{
                return nil
            }
            tokenTransfer = testToken.method("setApproval", parameters: [toAdd, type] as [AnyObject], options: options)
        case .setBonusPercentage:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.setBonusPercentageABI, at: constractAddress, abiVersion: 2) else {
               return nil
            }
            
            guard otherParam.count >= 2 else{
               return nil
            }
            let candidateAddrs = otherParam[0]
            let percentage   = otherParam[1]
            
            
            guard let percentageUint8 = UInt8(percentage) else{
               return nil
            }
            tokenTransfer = customContract.method("setBonusPercentage", parameters: [candidateAddrs, percentageUint8] as [AnyObject], options: options)
            
            
            
        case .setBonusMoney:
            guard let customContract = web3Rinkeby.contract(HPBAPPConfig.setBonusMoneyABI, at: constractAddress, abiVersion: 2) else {
               return nil
            }
            guard otherParam.count >= 1 else{
               return nil
            }
            let candidateAddrs = otherParam[0]
            tokenTransfer = customContract.method("candidateDeposit", parameters: [candidateAddrs] as [AnyObject], options: options)
        case .redPacket:
            guard addParam.count >= 3  else{
                return nil
            }
            let number = addParam[0] as! Int
            let valuesArr = addParam[1] as! NSArray
            let toAddress = addParam[2] as? String
            var valueConventArr: [BigUInt] = []
            for value in valuesArr{
                guard let conventMoney = Web3Utils.parseToBigUInt("\(value)", units: .wei) else{
                    return nil
                }
                valueConventArr.append(conventMoney)
            }
            if valueConventArr.count != number{
                return nil
            }
            guard let toAdress = HPBAddress(toAddress.noneNull) else{
                return  nil
            }
            let accountArr = [HPBAddress](repeatElement(toAdress, count: number))
            tokenTransfer = testToken.method("mintDedaultBatch", parameters: [accountArr, "","",valueConventArr] as [AnyObject], options: options)
        default:
            break
        }
        guard let tansferData = tokenTransfer?.transaction.data  else {
            return nil
        }
        return tansferData.toHexString()
    }
}
