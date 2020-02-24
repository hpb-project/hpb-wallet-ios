//
//  HPBWaitRedPacketView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import SDWebImage


class HPBWaitRedPacketView: UIView {

    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var dateLineLabel: UILabel!
    @IBOutlet weak var receiveBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipLabel.text = "News-RedPacket-Wait-Receive".localizable
        dateLineLabel.text = "News-RedPacket-DateLine".localizable
        receiveBtn.setTitle("News-RedPacket-To-Receive".localizable, for: .normal)
        showFinishingAnimation()
    }
    
    func showFinishingAnimation(){
        var images: [UIImage] = []
        for index in 0...30{
            if let pathStr = Bundle.main.path(forResource:  "close_\(index).jpg", ofType: nil),let image =  UIImage(contentsOfFile: pathStr){
                images.append(image)
            }
        }
        imageView.animationImages = images
        imageView.animationDuration = 3
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
    
    @IBAction func closeBtnCLick(_ sender: UIButton?) {
        let pasteboard = UIPasteboard.general
        //剪切板置空
        pasteboard.string = ""
        HPBRedPacketManager.share.markCommandStr = nil
        imageView.stopAnimating()
        imageView.animationImages = nil
        self.removeFromSuperview()
    }
    
    @IBAction func receiveBtnClick(_ sender: UIButton) {
        closeBtnCLick(nil)
        let startReceiveVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBStartReceiveController.self)) as!  HPBStartReceiveController
       let nav =  HPBBaseStateBarNavigationController(rootViewController: startReceiveVC)
        AppDelegate.shared.window?.rootViewController?.present(nav, animated: true, completion: nil)
        
    }
    
}
