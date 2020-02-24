//
//  HPBSignerManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import HPBWeb3SDK
import BigInt

class HPBSignerManager{
    
    static func signLoginMsg(_ password: String,
                             timestamp: String,
                             uuID: String,
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
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let signStr  = timestamp + currentAddress.noneNull + uuID + "HPBWallet"
        let data = Data(bytes: signStr.bytes)
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
    
    
    //验签过程
    static func verificatSignature(_ signature: String,personMsg: String,account: String) -> Bool{
        let totalItem =  RLP.decode("0xf8431ca0819e6f834b257a2dbf25b56bdd0b7d572c416ac4982866c03a38eb62205c67efa00f913b8fb387402465be37c375f962ab8875622439b9421f39d0c99e93197937")
        let rlpItem = totalItem?[0]
        let vUintValue = rlpItem![0]!.data!.bytes[0] - UInt8(27)
        let v =  Data(bytes: [vUintValue])
        let r = rlpItem![1]!.data!
        let s = rlpItem![2]!.data!
        let signData =  SECP256K1.marshalSignature(v: v, r: r, s: s)
        let personalData = Data(bytes: "15648950015150xc2a25725e92d817e3aeed4dcc5be2b03d883bf2687dcda616bHPBWallet".bytes)
        if let ethAdd =  Web3Utils.personalECRecover(personalData, signature: signData!) {
            debugLog("签名的地址为：",ethAdd.address)
        }
        return true
    }

    
    
}

