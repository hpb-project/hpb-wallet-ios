//
//  HPBAnimationLogoController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/7/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit


class HPBAnimationLogoController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var animationFinishBlock: (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
       
    }

    func showAnimation(){
        var images: [UIImage] = []
            for index in 60...130{
                if let pathStr = Bundle.main.path(forResource:  "anmiation_logo_\(index).png", ofType: nil),let image =  UIImage(contentsOfFile: pathStr){
                    images.append(image)
                }
            }
            imageView.animationImages = images
            imageView.animationDuration = 2
            imageView.animationRepeatCount = 1
            imageView.image = UIImage(named: "anmiation_logo_130.png")
            imageView.startAnimating()
           self.perform(#selector(dismissAnimation), with: nil, afterDelay: 3.5)
    }
    
    
    
    
    @objc func dismissAnimation(){
        imageView.animationImages = nil
        animationFinishBlock?()
    }

    
    deinit {
        print("HPBAnimationLogoController释放了")
    }
}


