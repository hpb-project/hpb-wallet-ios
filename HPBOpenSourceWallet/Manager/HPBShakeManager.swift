//
//  HPBShakeManager.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/5.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation
import ObjectMapper

class HPBShakeManager {
    
    enum HPBShakeState {
        case success
        case overTime
        case faile
    }
    
    static let share = HPBShakeManager()
    var shakeState: Bool = true
    var receiveBlock: (()-> Void)?
    
    func showRockView(){
        if HPBShakeManager.share.shakeState{
            HPBShakeManager.share.shakeState = false
            if let shakeView = HPBViewUtil.instantiateViewWithBundeleName(HPBShakeRedPacketView.self, bundle: nil){
                AppDelegate.shared.window?.rootViewController?.view.addSubview(shakeView)
                shakeView.snp.makeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsets.zero)
                }
            }
        }
    }
    
    
    func requestShakeNetwork(success: ((HPBShakeState,HPBShakePacketModel?)-> Void)?,faile:((String)-> Void)?){
        
        
        let (requestUrl,_) = HPBAppInterface.getShakePacket()
        HPBNetwork.default.request(requestUrl,method: .get) { (result, errorMsg) in
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPBShakePacketModel? else{
                    return
                }
                debugLog(model)
                if model.state == .ongoing && !model.key.isEmpty{   //摇到红包
                    success?(.success, model)
                }else if model.state == .ongoing && model.key.isEmpty{
                    success?(.faile,nil)
                }else if model.state == .ovetime{
                     success?(.overTime,model)
                }
            }else{
                HPBShakeManager.share.shakeState = true
                faile?(errorMsg.noneNull)
            }
        }
        
        
    }
    
}




//摇一摇红包
struct HPBShakePacketModel: Mappable{
    
    enum HPBShakePacketState{
        case ongoing
        case ovetime
    }
    
    
    init?(map: Map) {
        
    }
    var state: HPBShakePacketState = .ovetime
    var isOver: String = "2"{ //1进行中,2结束
        willSet{
            if newValue == "1"{
                state = .ongoing
            }else{
                state = .ovetime
            }
        }
        
    }
    var redPacketNo: String =  ""
    var key: String = ""
    // Mappable
    mutating func mapping(map: Map) {
        isOver  <- map["isOver"]
        redPacketNo    <- map["redPacketNo"]
        key     <- map["key"]
       
    }
}
