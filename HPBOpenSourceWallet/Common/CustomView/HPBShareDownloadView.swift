//
//  HPBShareDownloadView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/16.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBShareDownloadView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var aspectConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topContraint.constant = UIScreen.tabbarSafeBottomMargin + 10
        switch HPBLanguageUtil.share.language {
        case .chinese:
            centerImage.image = UIImage(named: "common_share_download_center_cn")
            aspectConstraint.constant = CGFloat(263.0/31.0)
        default:
            centerImage.image = UIImage(named: "common_share_download_center_en")
        }
        
        titleLabel.text = "Common-Share-Download".localizable
        codeImage.image = HPBAPPConfig.appDownloadUrl.generatorQRCode(size: UIScreen.width)
    }

}
