//
//  HPBShareManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/16.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation
import Photos
import LBXPermission

class HPBShareManager{

    //下载，收款，快讯,新闻，发红包
    enum HPBShareType {
        case download,receipt,express,news,redpacket
    }
    
    //链接，图片
    enum HPBContentType {
        case link,image
    }
    
    static let shared: HPBShareManager = HPBShareManager()
    var additionalInfo: Any?    //定制分享需要额外的信息
    
    
    func show(_ type: HPBShareType,currentController: UIViewController,screenshotView: UIView? = nil){
        //要截图的View
        var cutView: UIView?
        guard let shareView = HPBViewUtil.instantiateViewWithBundeleName(HPBShareView.self, bundle: nil)as? HPBShareView else{return}
        shareView.tag = 60001
        AppDelegate.shared.window?.addSubview(shareView)
        shareView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        //收款界面定制化
        if type == .receipt{
          cutView = receiptCustomView(shareView)
        }
        //新闻界面定制化
       else if type == .express{
            cutView = newsCustomView(shareView)
        }
        //发红包界面分享按钮定制化
       else if type == .redpacket{
           shareView.shareChannels = [.weibo,.wechat,.weFavout,.qq,.saveImage,.more]
        }
        //下载界面定制化
        else if type ==  .download{
             cutView = screenshotView
        }
        
        shareView.configInitLayout()
        
        //点击生成画图片
        shareView.clickedShareButton = { [weak self] in
         
            // 下载，（快报X），收款
            if type != .news && type != .redpacket{
                self?.shareTo(type: $0,currentController: currentController, cutView: cutView)
            }else{
                // 红包分情况讨论了，添加保存图片，保存图片为图片类型，其他为link类型
                if type == .redpacket && $0.rawValue == 1002{
                     cutView = self?.redPacketCustomView()
                    self?.shareTo(type: $0,currentController: currentController, cutView: cutView)
                }else {
                    self?.shareTo(.link,type: $0,currentController: currentController)
                }
            }
        }
    }
    
    func hideShareView(){
        let shareView =  AppDelegate.shared.window?.viewWithTag(60001) as? HPBShareView
        shareView?.tapDismiss()
    }
 
    fileprivate func shareTo(_ contentType: HPBContentType = .image, type: UMSocialPlatformType,currentController: UIViewController,cutView: UIView? = nil){
        
         //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        switch contentType{
        case .image:
            guard let picture = cutView else{return}
            guard let shareImage = UIImage.getImageViewWithView(picture) else{return}
            if type == .unKnown{
                self.primordialShare(shareImage,currentController)
                return
            }else if type.rawValue == 1001{ //自定义复制
                let pasteboard = UIPasteboard.general
                pasteboard.image = shareImage
                showBriefMessage(message: "Common-Copy-Success".localizable)
                   return
            }else if type.rawValue == 1002{ //自定义保存图片到本地
                 //红包界面显示保存按钮,此处不作处理了
                return
            }
            //分享图片
            let shareObject = UMShareImageObject()
            shareObject.shareImage = shareImage
            messageObject.shareObject = shareObject
        case .link:
            guard let model = additionalInfo as? HPBShareLinkModel else{return}
            let webUrl = model.webUrl
            if type == .unKnown{
                self.primordialShare(webUrl,currentController)
                return
            }else if type.rawValue == 1001{ //自定义粘贴的
                let pasteboard = UIPasteboard.general
                pasteboard.string = webUrl
                showBriefMessage(message: "Common-Copy-Success".localizable)
                return
            }
            //创建网页内容对象
            let shareObject = UMShareWebpageObject.shareObject(withTitle: model.title, descr: model.content, thumImage: UIImage(named: model.image))
            //设置网页地址
            shareObject?.webpageUrl = webUrl
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject
            
        }
        UMSocialManager.default()?.share(to: type, messageObject: messageObject, currentViewController: currentController, completion: { (data, error) in
            if error != nil {
                //复制，保存图片等不做判断
                if type.rawValue < 1000{
                 showBriefMessage(message: "Common-Share-Success".localizable)
                }
            }else{
                showBriefMessage(message: "Common-Share-Faile".localizable)
            }
        })
    }
   
}



//分享图片自定义
extension HPBShareManager{

    func receiptCustomView(_ shareView: HPBShareView) -> UIView?{
        shareView.isShowBlackBackground = true
        shareView.coverColor = UIColor.paNavigationColor
        //收款的时候定制化
        guard let receiptView = HPBViewUtil.instantiateViewWithBundeleName(HPBShareReceiptView.self, bundle: nil)as? HPBShareReceiptView else{return nil}
        receiptView.isUserInteractionEnabled = false
        let scrollow = UIScrollView()
        scrollow.backgroundColor = UIColor.black
        scrollow.addSubview(receiptView)
        shareView.addSubview(scrollow)
        scrollow.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-HPBShareView.bottomViewHeight)
        }
        receiptView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(UIScreen.statusHeight)
            make.height.equalTo(floor((550) / 375.0 * (UIScreen.width - 60))) //设计图是375.550
        }
        if let extralInfo = additionalInfo as? String{
           receiptView.addressLabel.text = extralInfo
           receiptView.codeImage.image = extralInfo.generatorQRCode(size: UIScreen.width - 120)
        }
        return receiptView
    }
    
    
    func newsCustomView(_ shareView: HPBShareView) -> UIView?{
        shareView.isShowBlackBackground = false
        shareView.coverColor = UIColor.paBackground
      
        //新闻资讯的时候定制化
        guard let neswShareView = HPBViewUtil.instantiateViewWithBundeleName(HPBShareNewsView.self, bundle: nil)as? HPBShareNewsView else{return nil}
        neswShareView.isUserInteractionEnabled = false
        let scrollow = UIScrollView()
        scrollow.backgroundColor = UIColor.white
        scrollow.addSubview(neswShareView)
        shareView.addSubview(scrollow)
        scrollow.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-HPBShareView.bottomViewHeight - 10)
        }
        neswShareView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        if let model = additionalInfo as? HPBShareNewsView.HPBShareNewsModel{
           neswShareView.model = model
        }
        return neswShareView
    }
    
     func redPacketCustomView() -> UIView?{
        //红包生成的时候定制化
        guard let shareRedPacketView = HPBViewUtil.instantiateViewWithBundeleName(HPBShareRedPacketView.self, bundle: nil)as? HPBShareRedPacketView else{return nil}
        guard let model = additionalInfo as? HPBShareLinkModel else{return nil}
        shareRedPacketView.addressStr = model.address
        shareRedPacketView.webUrl = model.webUrl
        AppDelegate.shared.window?.addSubview(shareRedPacketView)
        shareRedPacketView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        return shareRedPacketView
        
     }
    
}

extension HPBShareManager{
    
    //系统自带的分享
    func primordialShare(_ object: Any?,_ currentController: UIViewController){

        guard let content = object else{return}
        
        let items = [content]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil)
        activityVC.completionWithItemsHandler =  { activity, success, items, error in

        }
        currentController.present(activityVC, animated: true, completion: { () -> Void in
            
        })
        
    }
}


extension HPBShareManager{
    
    func saveImage(_ image: UIImage) {
        LBXPermission.authorize(with: .photos) { (granted, first) in
            if granted{
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { (isSuccess, error) in
                    if isSuccess {
                        DispatchQueue.main.async {
                            showBriefMessage(message: "Common-Save-Success".localizable)
                        }
                    }
                }
            }else{
                if !first{
                   showBriefMessage(message: "Common-Photo-Auth-Tip".localizable)
                }
            }
        }
    }
}
