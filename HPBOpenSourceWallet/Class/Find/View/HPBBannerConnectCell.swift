//
//  HPBBannerConnectCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/15.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBBannerConnectCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.image.layer.cornerRadius = 5
        self.image.layer.masksToBounds = true
        //添加阴影
        //gradientLayer()
    }
    
    
    /*
    func gradientLayer(){
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 35)
        gradientLayer.colors = [UIColor.black,UIColor.clear]
        gradientLayer.locations = [0.0,0.8]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        backView.layer.addSublayer(gradientLayer)
    }
    */

}
