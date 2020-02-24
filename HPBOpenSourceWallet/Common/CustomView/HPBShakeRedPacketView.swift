//
//  HPBShakeRedPacketView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/8/6.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import AVFoundation

class HPBShakeRedPacketView: UIView,CAAnimationDelegate{
    
    @IBOutlet weak var rockImage: UIImageView!
    var player: AVAudioPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        showAnimation()
    }
    
    func showAnimation(){
        
        
        /// 设置音效
        let path = Bundle.main.path(forResource: "rock", ofType: "mp3")
        let url = URL(fileURLWithPath: path.noneNull)
        self.player = try?  AVAudioPlayer(contentsOf: url)
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
        
        
        let keyframeAnimation = CAKeyframeAnimation()
        keyframeAnimation.keyPath = "transform.rotation.z"
        keyframeAnimation.duration = 0.5
        keyframeAnimation.values = [NSNumber(value: 0),NSNumber(value: Double.pi/8),
                                    NSNumber(value: 0),NSNumber(value: -Double.pi/8),
                                    NSNumber(value: 0)]
        keyframeAnimation.delegate = self
        keyframeAnimation.keyTimes = [0,0.25,0.5,0.75,1]
        keyframeAnimation.autoreverses = false
        keyframeAnimation.repeatCount = 2
        keyframeAnimation.isRemovedOnCompletion = false
        rockImage.layer.add(keyframeAnimation, forKey: "keyframeAnimation")
        
    }
    

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if rockImage.layer.animation(forKey: "keyframeAnimation") != nil{
            HPBShakeManager.share.requestShakeNetwork(success: { (state,model) in
                let path2 = Bundle.main.path(forResource: "rock_end", ofType: "mp3")
                let url = URL(fileURLWithPath: path2.noneNull)
                self.player = try?  AVAudioPlayer(contentsOf: url)
                self.player?.updateMeters()//更新数据
                self.player?.prepareToPlay()//准备数据
                self.player?.play()
                self.removeFromSuperview()
                switch state{
                case .success,.faile:
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    if let shakeAlertView =  HPBViewUtil.instantiateViewWithBundeleName(HPBShakeAlertView.self, bundle: nil) as? HPBShakeAlertView{
                        if state == .success{
                             shakeAlertView.state = .success
                        }else{
                            shakeAlertView.state = .faile
                        }
                        AppDelegate.shared.window?.rootViewController?.view.addSubview(shakeAlertView)
                        shakeAlertView.snp.makeConstraints { (make) in
                            make.edges.equalTo(UIEdgeInsets.zero)
                        }
                        shakeAlertView.successBlock = {
                            guard let `model` = model else {return}
                            let startReceiveVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBStartReceiveController.self)) as!  HPBStartReceiveController
                            startReceiveVC.sourceType = .shake
                            startReceiveVC.shakeRedPacketNo = model.redPacketNo
                            startReceiveVC.shakeRedPacketKey = model.key
                            startReceiveVC.shakeCommandStr = model.redPacketNo + HPBAPPConfig.redPacketSeparator + model.key
                            let nav =  HPBBaseNavigationController(rootViewController: startReceiveVC)
                            AppDelegate.shared.window?.rootViewController?.present(nav, animated: true, completion: nil)
                        }
                    }
                case .overTime:
                   HPBShakeManager.share.shakeState = true
                   showBriefMessage(message: "News-RedPacke-Shaking-Packet-over".localizable)
                }
            }) {
                showBriefMessage(message: $0)
                self.removeFromSuperview()
            }
        }
    }


}
