//
//  HPBShareDownloadController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/19.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShareDownloadController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let downloadView = HPBViewUtil.instantiateViewWithBundeleName(HPBShareDownloadView.self, bundle: nil){
            
            if UIDevice.isRETIAN_4_0 || UIDevice.isRETIAN_3_5{
                let scrollow = UIScrollView()
                scrollow.backgroundColor = UIColor.white
                scrollow.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
                scrollow.contentSize = CGSize(width: 0, height: 667)
                self.view.addSubview(scrollow)
                downloadView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 667)
                scrollow.addSubview(downloadView)
            }else{
                self.view.addSubview(downloadView)
                downloadView.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
            }
            //添加分享按钮
            let shareBtn = HPBButton()
            shareBtn.isHighlighted = false
            shareBtn.setImage(UIImage(named: "my_download_share"), for: .normal)
            shareBtn.addClickEvent {[weak self] in
                guard let `self` = self else{return}
                HPBShareManager.shared.show(.download,currentController: self, screenshotView: downloadView)
                
            }
            self.view.addSubview(shareBtn)
            shareBtn.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(UIScreen.statusHeight + 15)
                make.right.equalToSuperview().offset(-15)
                make.width.height.equalTo(30)
            }
            
            //添加返回按钮
            let backBtn = HPBButton()
            backBtn.isHighlighted = false
            backBtn.setImage(UIImage(named: "my_download_back"), for: .normal)
            backBtn.addClickEvent { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            self.view.addSubview(backBtn)
            backBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(UIScreen.statusHeight + 15)
                make.width.height.equalTo(30)
            }
            
        }
        
       
    }
}
