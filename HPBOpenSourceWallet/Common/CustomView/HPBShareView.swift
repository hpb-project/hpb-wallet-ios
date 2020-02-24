//
//  HPBShareView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/16.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShareView: UIView {
    
    enum HPBShareCancel: String {
        case weibo = "common_share_weibo"
        case wechat = "common_share_wechat"
        case weFavout = "common-share-pyq"
        case qq = "common_share_qq"
        case saveImage = "common_share_saveImage"
        case more = "common_share_more"
    }
    
    
    static let bottomViewHeight: CGFloat = (172 + UIScreen.tabbarSafeBottomMargin)
    
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var shareToLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    
    //分享渠道
    var shareChannels: [HPBShareCancel] = [.weibo,.wechat,.weFavout,.qq,.more]{
        willSet{
            for (index,channel) in newValue.enumerated(){
                guard let shareBtn =  self.viewWithTag(2000 + index)  as? UIButton else{return}
                shareBtn.setImage(UIImage(named: channel.rawValue), for: .normal)
                 shareBtn.isHidden = false
            }
            if shareChannels.count > 5{
                self.layoutIfNeeded()
            }
        }
    }
    
    var isShowBlackBackground: Bool = true   //是否显示黑色背景遮罩层
    var coverColor: UIColor = UIColor.black
    var clickedShareButton: ((UMSocialPlatformType) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnBottomConstraint.constant = UIScreen.tabbarSafeBottomMargin
        shareToLabel.text = "Common-Share-To".localizable
        cancelBtn.setTitle("Common-Cancel".localizable, for: .normal)
        for (index, channel) in shareChannels.enumerated(){
            
            guard let shareBtn =  self.viewWithTag(2000 + index)  as? UIButton else{return}
            shareBtn.setImage(UIImage(named: channel.rawValue), for: .normal)
        }
        self.layoutIfNeeded()
    }
    
    
    func configInitLayout(){
        
        self.backgroundColor = coverColor.withAlphaComponent(self.isShowBlackBackground ? 0 : 1)
        bottomContraint.constant = -HPBShareView.bottomViewHeight
        self.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25) {
                if self.isShowBlackBackground{
                    self.backgroundColor = self.coverColor.withAlphaComponent(0.5)
                }
                self.bottomContraint.constant = 0
                self.layoutIfNeeded()
            }
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        topView.addGestureRecognizer(gesture)
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
         tapDismiss()
    }
    
    @objc func tapDismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = self.coverColor.withAlphaComponent(self.isShowBlackBackground ? 0 : 1)
            self.bottomContraint.constant = -HPBShareView.bottomViewHeight
            self.layoutIfNeeded()
        }) {(state) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func shareButtonClick(_ sender: UIButton) {
        var shareType:UMSocialPlatformType = .unKnown
        if sender.tag - 2000 > shareChannels.count{
           return
        }
        switch shareChannels[sender.tag - 2000] {
        case .weibo:
            shareType = .sina
        case .qq:
            shareType = .QQ
        case .wechat:
            shareType = .wechatSession
        case .weFavout:
            shareType = .wechatTimeLine
        case .more:
            shareType = .unKnown
        case .saveImage:
            shareType = UMSocialPlatformType(rawValue: 1002) ?? .unKnown   //自定义
        }
        tapDismiss()
        
        //先判断是否安装
        if judgeInstall(shareType) == true{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.clickedShareButton?(shareType)
            }
        }
    }
    
    
    func judgeInstall(_ shareType :UMSocialPlatformType) -> Bool{
        //判断是否安装
        if let socialManager = UMSocialManager.default(){
            if !socialManager.isInstall(shareType){
                if shareType == .sina{
                    showBriefMessage(message: "Common-Share-Not-Install-weibo".localizable)
                    return false
                }else if shareType == .wechatSession || shareType == .wechatTimeLine{
                    showBriefMessage(message: "Common-Share-Not-Install-weChat".localizable)
                    return false
                }else if shareType == .QQ{
                    showBriefMessage(message: "Common-Share-Not-Install-qq".localizable)
                    return false
                }
            }
        }
        return true
        
    }
}
