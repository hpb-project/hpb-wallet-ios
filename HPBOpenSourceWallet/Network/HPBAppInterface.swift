//
//  HPBAppInterface.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation


struct HPBAppInterface {
    enum HPBBaseURL: String{
        case local  = "http://192.168.0.48:9889/HpbComponent/"
        case test   = "http://app.zhaoxi.co/HpbComponent/"
        case formal = "https://app.xinlian.com/HpbComponent/"
    }
    typealias HPBDic = [String: Any]
    static let networkURL: HPBBaseURL = .test
    
    static func getBaseURL() -> String{
        if HPBAPPConfig.isFormatEnvironment{
            return HPBBaseURL.formal.rawValue
        }
        return networkURL.rawValue
    }
    
    /// 获取APPStore钱包版本号
    /// 审核的时候去隐藏更新按钮
    /// 1437503008
    static func getAPPStoreVersion() ->  (String,HPBDic){
        let url = "http://appstore.xinlian.com/HpbComponent/dictionary/test"
        let param = ["parameter": []]
        return (url,param)
    }
    
    /// 获取Nonce
    /// - Returns: 返回Nonce的URL和参数
    static func getTradeNonce(account: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "personal/getNonce"
        let param = ["parameter": [account]]
        return (url,param)
    }
    
    
    /// 创建交易
    ///
    /// - Parameter signature: 签名
    /// - Returns: 返回URL和参数
    static func getCreatTrade(signature: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "transaction/sendRawTransaction"
        let param = ["parameter": [signature]]
        return (url,param)
    }
    
    
    /// 查询账户余额
    ///
    /// - Parameter account: 账户信息
    /// - Returns: 返回URL和参数
    static func getQuaryAccountBalance(account: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "personal/getBalance"
        let param = ["parameter": [account]]
        return (url,param)
    }
    
    
    /// 批量查询账户余额
    ///
    /// - Parameter account: 账户信息
    /// - Returns: 返回URL和参数
    static func getQuaryListBalance(accounts: [String]) -> (String,HPBDic) {
        let url   = getBaseURL() + "personal/listBalance"
        let param = ["parameter": accounts]
        return (url,param)
    }
    
    
    
    /// 获取单一交易记录
    ///
    /// - Parameter tradeHash: tradeHash值
    /// - Returns: 返回URL和参数
    static func getQuarySingleTrade(tradeHash: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "transaction/getTransactionByHash"
        let param = ["parameter": [tradeHash]]
        return (url,param)
    }
    
    
    /// 获取轮播图信息
    ///
    /// - Parameter pageNum: 当前页数
    
    static func getCarouselPictures() -> (String,HPBDic) {
        let url   = getBaseURL() + "cms/carousel"
        var type: String = "0"
        if HPBLanguageUtil.share.language == .english{
           type = "1"
        }
        let param = ["parameter": [type]]
        return (url,param)
        
    }
    
    
    /// 获取最新资讯
    ///
    /// - Parameter pageNum: 当前页数
    
    static func getNewsList(pageNum: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "cms/article"
        var type: String = "0"
        if HPBLanguageUtil.share.language == .english{
            type = "1"
        }
        let param = ["parameter": [pageNum,type]]
        return (url,param)
    }
    

    
    
    /// 获取交易历史
    ///
    /// - Parameters:
    ///   - address: 地址
    ///   - contractType: 交易类型hpb,HRC-20,HRC-721
    ///   - contractAdd:  合约地址,没有传“”
    ///   - biJian:       币种简称
    ///   - pageNum: 当前页面
    
    static func getTransRecordList(address: String,contractType: String = "HPB",contractAdd: String = "",tokenSymbol: String = "",pageNum: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "transaction/list"
        let param = ["parameter": [address,contractType,contractAdd,tokenSymbol,pageNum,0]]
        return (url,param)
    }
    
    
    /// 获取交易详情
    ///
    /// - Parameter hash: 交易hash
    static func getTransDetail(hash: String)-> (String,HPBDic){
        let url   = getBaseURL() + "transaction/getTransactionDetail"
        let param = ["parameter": [hash]]
        return (url,param)
    }
    
    
    
    
    /// 意见反馈
    ///
    /// - Parameters:
    ///   - type: 意见类型 0-问题 1-意见 2-其它
    ///   - title: 意见标题
    ///   - content: 意见内容
    ///   - time: 意见时间
    ///   - contact: 联系方式
    static func getSuggestion(type: String,
                              title: String,
                              content: String,
                              time: String,
                              contact: String) -> (String,HPBDic) {
        let url   = getBaseURL() + "cms/suggestion"
        let param = ["type": type,"title": title, "content": content,"contact": contact,"create_time": time]
        return (url,param)
        
    }
    
   
}



extension HPBAppInterface{
    

    /// 根据Hash查询成功Or失败状态
    static func getTransactionReceipt(hash: String)-> (String,HPBDic){
        let url   = getBaseURL() + "transaction/getTransactionReceipt"
        let param = ["parameter": [hash]]
        return (url,param)
    }
    
    
    
    ///获取所有联系人列表
    static func getPullContractList(allWallets : [String])-> (String,HPBDic){
        let url   = getBaseURL() + "cms/book/pullall"
        let param = ["parameter": allWallets]
        return (url,param)
    }
    
    ///推送所有联系人列表
    static func getPushContractList(allDatas: [Any])-> (String,HPBDic){
        let url   = getBaseURL() + "cms/book/pushall"
        let param = ["parameter": allDatas]
        return (url,param)
    }
    
    
    //查询所有DApp
    static func getAllDAppList()-> (String,HPBDic){
        let url   = getBaseURL() + "cms/app/page"
        let testAddress = ""
        let param = ["parameter": [testAddress]]
        return (url,param)
    }

    
    
    //校验白名单
    static func getCheckWhiteList(to: String)-> (String,HPBDic){
        let url   = getBaseURL() + "merchant/vitertify"
        let param = ["parameter": [to]]
        return (url,param)
    }
    
    //回传给HPB Sever订单信息
    static func callBackOrderInfo(hash: String,backUrl: String,orderId: String) -> (String,HPBDic){
    let url   = getBaseURL() + "merchant/callback"
    let param = ["parameter": [hash,backUrl,orderId]]
    return (url,param)
    }
}


extension HPBAppInterface{
    
    
    //准备发红包
    //参数1    string    是    发红包地址
    //参数1    string    是    红包金额（不含旷工费）18GWEI
    //如值： 100000000000000000（0.01HPB）
    //参数1    string    是    红包总数
    //参数1    string    是    红包入口：1-红包（钱包1.4），2-官方
    //参数1    string    是    红包类型：1-普通红包，2-拼手气红包
    //参数1    string    是    红包祝福语
    
    static func readySendRedPacket(address: String,
                              money: String,number: String,
                              source: String = "1",
                              type: String,tip: String)-> (String,HPBDic){
        let url   = getBaseURL() + "packet/rawReady"
        let param = ["parameter": [address,money,number,source,type,tip]]
        return (url,param)
    }
    
    //发红包
    //参数1    string    是    红包编号
    //参数1    string    是    签名信息
    
    static func sendRedPacket(redPacketNo: String,sinagature: String)-> (String,HPBDic){
        let url   = getBaseURL() + "packet/sendRaw"
        let param = ["parameter": [redPacketNo,sinagature]]
        return (url,param)
    }
    
    //刷新查看红包状态
    //参数1    string    是    红包编号
    static func refreshRedPacketState(redPacketNo: String)-> (String,HPBDic){
        let url   = getBaseURL() + "packet/refresh"
        let param = ["parameter": [redPacketNo]]
        return (url,param)
    }
    
    
    //查看红包钥匙是否有效(废弃接口)
    //参数1    string    是    红包编号
    //参数2    string    是    钥匙key
    
    static func getIsValidRedPacketKey(redPacketNo: String,key: String)-> (String,HPBDic){
        let url   = getBaseURL() + "packet/keyCheck"
        let param = ["parameter": [redPacketNo,key]]
        return (url,param)
    }
    
    
    //领红包
    //参数1    string    是    红包编号
    //参数2    string    是    钥匙key
    //参数3    string    是    领红包地址
    
    static func getReceiveRedPacket(redPacketNo: String,key: String, address: String,tokenId: String)-> (String,HPBDic){
        let url   = getBaseURL() + "packet/draw"
        let param = ["parameter": [redPacketNo,key,address,tokenId]]
        return (url,param)
    }
    
    
    //红包记录
    //参数1    string    是    类型：1-发红包，0-领取红包
    //参数2    string    是    发(领)红包地址与参数1匹配
    //参数3    string    是    起始页数
    
    static func getRedPacketRecord(type: String,page: String, address: String)-> (String,HPBDic){
        let url   = getBaseURL() + "packet/records"
        let param = ["parameter": [type,address,page]]
        return (url,param)
    }
    
    
    //红包详情
    //参数1    string    是    类型：1-发红包，0-领取红包
    //参数2    string    是    红包编号
    //参数3    string    是    领红包详情时传领红包地址，其他传空字符串“”,准备领取时填入红包key
    //参数4    string    是    起始页数
    
    static func getRedPacketDetail(redPacketNo: String, address: String,page: String,type: String = "1")-> (String,HPBDic){
        let url   = getBaseURL() + "packet/detail"
        let param = ["parameter": [type,redPacketNo,address,page]]
        return (url,param)
    }
    
    //查询开屏广告
    //参数1    string    是    手机类型：1-IOS，2-安卓
    //参数2    string    是    尺寸：
    //1-1125 * 2436(苹果X),
    //2-1920 * 1080(苹果6),
    //2-1920 * 1080(安卓)
    
    static func getAdvertise()-> (String,HPBDic){
        let url   = getBaseURL() + "cms/advertise"
        let deviceType = UIDevice.isIPHONE_X ? "1" : "2"
        let languageType = HPBLanguageUtil.share.language == .english ? "2" : "1"
        let param = ["parameter": ["1",deviceType,languageType]]
        return (url,param)
    }
    
    //参数1    string    是    红包编号
    //参数2    string    是    钥匙
    //参数3    string    是    起始页数
    static func getRedPacketBeforeDrawCheck(redPacketNo: String, key: String,page: String,address: String?)-> (String,HPBDic){
        let url   = getBaseURL() + "packet/beforeDrawCheck"
        let param = ["parameter": [redPacketNo,key,page,address.noneNull]]
        return (url,param)
    }
    
}
