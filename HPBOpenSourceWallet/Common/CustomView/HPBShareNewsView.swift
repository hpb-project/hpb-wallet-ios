//
//  HPBShareNewsView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/16.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShareNewsView: UIView {

    
    struct HPBShareNewsModel{
        var time: String = ""
        var content: String = ""
    }
    
    var model: HPBShareNewsModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            timeLabel.text = newValue.time
            contentLabel.text = newValue.content
            self.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var topImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        topImage.image = HPBLanguageUtil.share.language == .chinese ? UIImage(named: "common_share_news_title_cn") : UIImage(named: "common_share_news_title_en")
        bottomLabel.text = "Common-Share-From".localizable
        downloadImage.image = HPBAPPConfig.appDownloadUrl.generatorQRCode(size: UIScreen.width)
    }
    
    

}
