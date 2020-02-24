//
//  HPBMainController+Shake.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/5.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import Foundation



extension HPBMainController{
    
    func openShakeRedPacket(){
        UIApplication.shared.applicationSupportsShakeToEdit = true
        becomeFirstResponder()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            HPBShakeManager.share.showRockView()
        }
    }
        
        
        
}

