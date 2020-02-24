//
//  HPBAppConfig.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation


struct HPBAPPConfig {

    //蒲公英打包要选择false，Appstore版本选择true
    static var isToAPPStore: Bool = true
    
    //是否是上线环境
    static let isFormatEnvironment: Bool = true


    //区分Appstore版本和蒲公英版本
    static let versionContentSeparator: String = "hpbwalletupdate"
    
    //投票的合约地址
    static var  voteContractAddress: String = ""
    
    //隐藏资产显示的文字
    static let  hiddenAssertStr: String = "******"
    
    //HPB企业版下载地址
    static let appDownloadUrl: String = "https://www.hpb.io/wallet"
    
    //分割符
    static let  separatorStr: String = "#&ZXWL&#"
    
    //HPB区块链浏览器账户信息
    static let hpbscanAccountUrl: String = "http://hpbscan.org/address/"
    
    //HPB区块链浏览器交易hash
    static let hpbscanTxHashUrl: String = "https://hpbscan.org/tx/"
    
    //ETH区块链浏览器交易hash
     static let ethscanTxHashUrl: String = "https://etherscan.io/tx/"
    
    // H5支付合约地址
    static let  webPayContractAddr: String = "0xf2afad01844d276a7fccf8e268c4a78b97da9bdd"
    
    // 发送红包的合约地址
     static var redPacketContractAddr: String = ""
    
    //红包key 和 NO的分隔符
    static let redPacketSeparator: String = "hpbrp"
    
    
    //红包分享的baseUrl
    static var redPacketShareURL: String{
        get{
            if HPBAPPConfig.isFormatEnvironment{
                return  "http://redpacket.xinlian.com/#/redPacket"
            }else{
                return  "http://redpacket.zhaoxi.co/#/redPacket"
            }
        }
    }
    //HRC token 转移20ABI
    static let HRC20ABI: String = "[{\"constant\":false,\"inputs\":[{\"internalType\":\"address\",\"name\":\"_to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
    
     static let HRC721ABI: String = "[{\"constant\":false,\"inputs\":[{\"name\":\"from\",\"type\":\"address\"},{\"name\":\"to\",\"type\":\"address\"},{\"name\":\"tokenId\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
    
    
    //设置分红比率ABI
    static let setBonusPercentageABI: String = "[{\"constant\":false,\"inputs\":[{\"name\":\"_candidateAddr\",\"type\":\"address\"},{\"name\":\"_bonusPercentage\",\"type\":\"uint8\"}],\"name\":\"setBonusPercentage\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
    static var setBonusContractAddr: String = ""
    
    //设置分红金额
    static let setBonusMoneyABI: String = "[{\"constant\":false,\"inputs\":[{\"name\":\"_candidateAddr\",\"type\":\"address\"}],\"name\":\"candidateDeposit\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"}]"
    
    
    //冷钱包签名数据开头
    static let  coldSigntureStart: String = "coldSinature:"
    
}

struct HPBUserDefaultsKey{
    static let  appLanguageKey          =  "appLanguage"
    static let  currentWalletAddressKey =  "currentWalletAddressKey"
    static let  showSafeAlertKey        =  "showSafeAlertKey"
    static let  hideAssertKey           =  "hideAssertKey"
    static let  appNumberStyleKey       =  "appNumberStyleKey"
    static let  headerColorKey           =  "headerColorKey"
    static let  walletNumberKey         =   "walletNumberKey"
    static let  secureLoginKey          =   "secureLoginKey"
    static let  redpacketBtnKey         =   "redpacketBtnKey"
    static let  iCouldBackupKey         =   "iCouldBackupKey"
    static let  lastetMsgCNNumberKey    =   "lastetMsgCNNumberKey"
    static let  lastetMsgENNumberKey    =   "lastetMsgENNumberKey"
    static let  authorizListKey         =   "authorizListKey" 
    static let  todayShowAdKey          =   "todayShowAdKey"
    static let  appMoneyStyleKey         =  "appMoneyStyleKey"
    static let  tokenManagerKey          =  "tokenManagerKey"
    
}

struct HPBWebViewURL{
    enum HPBBaseURL: String{
        case test   = "http://h5.zhaoxi.co/wallet/"
        case formal = "https://h5.xinlian.com/wallet/"
    }
    
    static let networkURL: HPBBaseURL = .formal
    static func getBaseURL() -> String{
        if HPBAPPConfig.isFormatEnvironment{
            return HPBBaseURL.formal.rawValue
        }
        return networkURL.rawValue
    }
    
    static let   baseURL  =  getBaseURL()
    static let   keystore =  baseURL  + "keystore"
    static let   mnemonic =  baseURL  + "mnemonic"
    static let   privates =  baseURL  + "privates"
    static let   services =  baseURL  + "services"
    static let   question =  baseURL  + "home"
    static let   articles =  baseURL  + "articles"
    static let   contact  = baseURL   + "contact"
    static let   backupCourse  = baseURL   + "wallets"
    static let   agreement  = baseURL   +  "agreement"
    static let   gasprice  = baseURL   +  "gasprice"
    static let   voterule  = baseURL   +  "voterule"
    static let   coldWallet = baseURL   +  "userguide"
     static let   voteRule = baseURL   +  "votingRulesDk"
     static let   votingReward = baseURL   +  "VotingReward"
    
}


struct HPBShareParamsStruct {
    //请到友盟官网申请后填写(https://passport.umeng.com/)
    static let kUMSocialKey = "5bd6ced3f1f556d9fb000194"
    static let kWXAppId = ""
    static let kWXAppSecret = ""
    static let kQQAppId = ""
    static let kQQAppKey = ""
    static let kSinaAppKey = ""
    static let kSinaAppSecret = ""
}


