//
//  HPBAppInterface+1.5.0.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/12.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation

extension HPBAppInterface{
    
    /// 摇一摇红包
    ///无参数
    static func getShakePacket()-> (String,HPBDic){
        let url   = getBaseURL() + "packet/shakePacket"
        let param = ["parameter": []]
        return (url,param)
    }
    
    ///题案列表
    //起始页码
    static func getProposalList(page: String)-> (String,HPBDic){
        let url   = getBaseURL() + "proposal/list"
        let param = ["parameter": [page]]
        return (url,param)
    }
    
    //3、题案详情
    //[参数1:题案编号，参数2:投票人地址]
    
    static func getProposalDetail(address: String,issueNo: String)-> (String,HPBDic){
        let url   = getBaseURL() + "proposal/detail"
        let param = ["parameter": [issueNo,address]]
        return (url,param)
    }
    
    //4、题案个人投票记录
    // [参数1:投票人地址]
    static func getProposalRecords(address: String)-> (String,HPBDic){
        let url   = getBaseURL() + "proposal/personalRecords"
        let param = ["parameter": [address]]
        return (url,param)
    }
    
    //4、发送投票签名
    //
    static func getProposalVote(issuse: String,address: String,state: String,vote: String,sinature: String)-> (String,HPBDic){
        let url   = getBaseURL() + "proposal/vote"
        let param = ["parameter": [issuse,address,state,vote,sinature]]
        return (url,param)
    }
    
}
