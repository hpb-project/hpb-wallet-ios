//
//  HPBAppInterface+2.0.0.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/10.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation


extension HPBAppInterface{

    
    ///代币管理
    static func getTokenManage(address: String)-> (String,HPBDic){
        let url   = getBaseURL() + "token/manage"
        let param = ["parameter": [address]]
        return (url,param)
    }
    
    
    //721库存代币
    static func getToken721StockList(address: String,contractAddress: String,page: String)-> (String,HPBDic){
        let url   = getBaseURL() + "token721/stock"
        let param = ["parameter": [page,contractAddress,address]]
        return (url,param)
    }
    
    ///721库存详情
    static func getToken721StockDetail(id: String,page: String,contractAdd: String)-> (String,HPBDic){
        let url   = getBaseURL() + "token721/idDetail"
        let param = ["parameter": [page,id,contractAdd]]
        return (url,param)
    }
    
    
    ///该账户下所有的代币ID
    static func get721IdsByTxHash(hash: String,contractAddress: String,page: String)-> (String,HPBDic){
        let url   = getBaseURL() + "token721/idsByTxHash"
        let param = ["parameter": [page,hash,contractAddress]]
        return (url,param)
    }
    
    
    ///721交易详情
    static func get721TxDetail(address: String,hash: String)-> (String,HPBDic){
        let url   = getBaseURL() + "token721/txDetail"
        let param = ["parameter": ["1",address,hash]]
        return (url,param)
    }

    
    /// 查询单个账户法币余额
    ///
    /// - Parameter account: 账户信息
    /// - Returns: 返回URL和参数
    static func getLegalTenderBalance(account: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "personal/getLegalTenderBalance"
        let param = ["parameter": [account]]
        return (url,param)
    }
    
    
    ///查询多个账户的法币余额
    static func getMoreLegalTenderBalances(accounts: [String])-> (String,HPBDic){
        let url   = getBaseURL() + "personal/listLegalBalances"
        let param = ["parameter": accounts]
        return (url,param)
        
    }
    
    
    //查询HRC下所有资产的情况
    //@ApiOperation(value="钱包转账",notes = "参数1：address,参数二：币种类型")
    //@PostMapping("/personal/walletTransfer")
    static func getCurrentAddressHRCAssert(address: String,type: String)-> (String,HPBDic){
        let url   = getBaseURL() + "personal/walletTransfer"
        let param = ["parameter": [address,type]]
        return (url,param)
    }
    
    ///交易记录代币筛选
    static func getTransferTypeList(addrerss: String,type: String)-> (String,HPBDic){
        let url   = getBaseURL() + "transaction/typeList"
        let param = ["parameter": [addrerss,type]]
        return (url,param)
    }
    
    
    
    
}
