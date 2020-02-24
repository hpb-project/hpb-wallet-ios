//
//  HPBRedPacketManager.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/6.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation

class HPBRedPacketManager{
    
    static let share = HPBRedPacketManager()
    
    fileprivate lazy var  readBtn: WLButton = {
        let readBtn = WLButton(type: .custom)
        readBtn.moveEnable = true
        return readBtn
    }()
    var redPacketBlock: (()-> Void)?
    var redPacketState: Bool{ //是否开启(默认是开启)
        if let state = UserDefaults.standard.object(forKey: HPBUserDefaultsKey.redpacketBtnKey) as? Bool{
            return state
        }
        return true
    }
    
    //粘贴板内容
    var commandStr: String?
    var redPacketNo: String?
    var redPacketKey: String?
    
    var markCommandStr: String?
    
    func reloadState(){
        readBtn.isHidden = !redPacketState
    }
    
    func steupReadPacketBtn(_ superView: UIView){
        
        readBtn.frame = CGRect(x: WLWindowWidth - 69, y: WLWindowHeight - UIScreen.tabbarHeight - 90 - UIScreen.tabbarSafeBottomMargin, width: 69, height: 69)
        readBtn.setBackgroundImage(UIImage.init(named: "common_red_packet"), for: .normal)
        readBtn.setBackgroundImage(UIImage.init(named: "common_red_packet"), for: .highlighted)
        superView.addSubview(readBtn)
        superView.bringSubview(toFront: readBtn)
        readBtn.addTarget(self, action: #selector(redBtnClick), for: .touchUpInside)
        
        //判断是fou开启
        if redPacketState == false {
            readBtn.isHidden = true
        }
    }
    
    
    @objc func redBtnClick(){
        if readBtn.frame.origin.x != 0 &&  readBtn.frame.origin.x != WLWindowWidth - 69{
            return
        }
        redPacketBlock?()
    }
}



extension HPBRedPacketManager{
    
    func receiveRedPacket(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            AppDelegate.shared.isEnterMainPage = true
            if self.markCommandStr.noneNull.isEmpty{
                let pasteboard = UIPasteboard.general
                if pasteboard.string.noneNull.isEmpty{
                    return
                }
                //剪切板有内容
                self.commandStr = pasteboard.string.noneNull
                debugLog(self.commandStr)
            }else{
                self.commandStr = self.markCommandStr    //在解锁的时候就先获取下剪切板的b内容
            }
           
            let strArray =  self.commandStr.noneNull.components(separatedBy: HPBAPPConfig.redPacketSeparator)
            guard strArray.count == 2 else{return}
            self.redPacketNo =  strArray[0]
            self.redPacketKey =  strArray[1]
            
            //隐藏所有的弹框
            HPBWindowManager.share.hideAllViews()
            
            let redPacketView =
                HPBViewUtil.instantiateViewWithBundeleName(HPBWaitRedPacketView.self) as! HPBWaitRedPacketView
            redPacketView.tag = 60000
            AppDelegate.shared.window?.rootViewController?.view.addSubview(redPacketView)
            redPacketView.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
    
    
    func hideRedpacketView(){
        //隐藏红包界面
        let redPacketView = AppDelegate.shared.window?.rootViewController?.view.viewWithTag(60000) as? HPBWaitRedPacketView
        redPacketView?.closeBtnCLick(nil)
    }
    
    
    //开始领红包
    func receiveRedPacketNetwork(address: String,redPacketNo: String,key: String,tokenId: String,success: ((String)->Void)?){
        
        showHudText()
        let (requestUrl,param) = HPBAppInterface.getReceiveRedPacket(redPacketNo: redPacketNo, key: key, address: address,tokenId: tokenId)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            hideHUD()
            if errorMsg == nil{
                guard let resultDic = result as? [String : String] else {return}
                guard let state = resultDic["status"] else {return}
                if state == "1"{
                    success?("News-RedPacket-Receive-Success-Tip".localizable)
                }else if state == "0"{
                    showBriefMessage(message: "News-RedPacket-State-Faile".localizable)
                }else if state == "2"{
                    showBriefMessage(message: "News-RedPacket-Receive-End-Tip".localizable)
                }else if state == "3"{
                    showBriefMessage(message: "News-RedPacket-Receive-Had-Tip".localizable)
                }else if state == "4"{
                    // 2019.8.2 所有的key失效都要修改为 手慢了
                    showBriefMessage(message: "News-RedPacket-State-Faile".localizable)
                }else if state == "5"{
                     success?("News-RedPacket-Receive-Confirm-Tip-1".localizable)
                }
            }else{
                showBriefMessage(message: errorMsg)
            }
        }
    }

}


