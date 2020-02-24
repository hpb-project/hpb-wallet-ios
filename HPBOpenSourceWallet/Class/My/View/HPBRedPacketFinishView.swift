//
//  HPBRedPacketFinishView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/13.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import SDWebImage
class HPBRedPacketFinishView: UIView {

    enum HPBRedPacketState{
        case packing, finish
    }
    
    @IBOutlet weak var refreshBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var datelineLabel: UILabel!
    @IBOutlet weak var redPacketImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bottomTipLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var closeBtnTop: NSLayoutConstraint!

    var freshState: Bool = false
    var redPacketID: String?
    var redPacketState: HPBRedPacketState = .packing
    var sendBlock: (()-> Void)?
    var closeBlock: (()-> Void)?
    var redPacketInfo: String = ""{
        willSet{
          numberLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        steupLocation()
        refreshBtnBottom.constant  = UIScreen.tabbarSafeBottomMargin + 50
        closeBtnTop.constant = UIScreen.statusHeight + 10
        self.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        self.showPacketingAnimation()
        self.showAnimation()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6, execute: {
            self.refreshRedPacketState()
        })
    }
    
    
    
   
    
    func steupLocation(){
        self.stateLabel.text = "News-RedPacket-Packeting".localizable
        self.bottomTipLabel.text = "News-RedPacket-Confirm-Wait".localizable
        self.datelineLabel.text = "News-RedPacket-DateLine".localizable
        self.sendBtn.setTitle("News-RedPacket-Refresh".localizable, for: .normal)
        
    }
    
    private func showAnimation(){
        backViewCenterY.constant = -(UIScreen.height/2 + (UIScreen.width - 22 * 2)  * 422 / 331 / 2)
        self.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.5) {
                self.backViewCenterY.constant = 0
                self.layoutIfNeeded()
            }
        }
    }
    
    
    @IBAction func closeClick(_ sender: UIButton) {
        self.removeFromSuperview()
        redPacketImage.stopAnimating()
        redPacketImage.animationImages = nil
        closeBlock?()
    }
    
    @IBAction func sendBtnClick(_ sender: UIButton) {

        switch redPacketState {
        case .packing:
            refreshRedPacketState()
        case .finish:
            sendBlock?()
            
        }
        
    }
    
    //获取成功状态
    fileprivate func getStateBy(hash: String,success: (() -> Void)? = nil,faile: (() -> Void)? = nil ,progress: (() -> Void)? = nil){
        let (requestUrl,param) = HPBAppInterface.getTransactionReceipt(hash: hash)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as  HPBTransferStateModel? else{
                    progress?()
                    return
                }
                if model.isSuccess{
                    success?()
                } else if model.isFaile{
                    faile?()
                }else{
                    progress?()
                }
            }else{
                progress?()
            }
        }
    }
    
    
}


extension HPBRedPacketFinishView{
    
    func refreshRedPacketState(){

        showHudText(view: self.backView)
        let (requestUrl,param) = HPBAppInterface.refreshRedPacketState(redPacketNo: redPacketID.noneNull)
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                hideHUD(view: self.backView)
                if errorMsg == nil{
                    let  state = HPBStringUtil.transformFromJSON(result)
                    if state == "1"{
                        //刷新
                        self.showFinishingAnimation()
                        self.stateLabel.text = "News-RedPacket-Finish".localizable
                        self.bottomTipLabel.isHidden = true
                        self.numberLabel.isHidden = true
                        self.datelineLabel.isHidden = false
                        self.sendBtn.setTitle("News-Send-RedPacket".localizable, for: .normal)
                        self.redPacketState = .finish
                    }else if state == "2"{
                        if self.freshState == false{
                            self.freshState = true
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6, execute: {
                                self.freshState = false
                                self.refreshRedPacketState()
                            })
                        }
                        
                    }else if state == "0"{
                        showBriefMessage(message: "News-RedPacket-Send-Faile".localizable)
                    }
                }
            })
           
        }
        
    }
    
}


extension HPBRedPacketFinishView{
    
    func showPacketingAnimation(){
        var images: [UIImage] = []
        for index in 0...100{
            if let pathStr = Bundle.main.path(forResource:  "packing_\(index).jpg", ofType: nil),let image =  UIImage(contentsOfFile: pathStr){
                images.append(image)
            }
        }
        redPacketImage.animationImages = images
        redPacketImage.animationDuration = 6
        redPacketImage.animationRepeatCount = 0
        redPacketImage.startAnimating()
    }
    
    func showFinishingAnimation(){
         redPacketImage.stopAnimating()
        var images: [UIImage] = []
        for index in 0...30{
            if let pathStr = Bundle.main.path(forResource:  "close_\(index).jpg", ofType: nil),let image =  UIImage(contentsOfFile: pathStr){
                images.append(image)
            }
        }
        redPacketImage.animationImages = images
        redPacketImage.animationDuration = 3
        redPacketImage.animationRepeatCount = 0
        redPacketImage.startAnimating()
    }
}
