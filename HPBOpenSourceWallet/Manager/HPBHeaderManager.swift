//
//  HPBHeaderManager.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/11/21.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import Foundation


class HPBHeaderManager{
    //获取不同的头像
    @discardableResult
    static func randomGeneratHeadimageName(_ walletName: String?,address: String?)-> String?{
        var showText = "未"
        if !walletName.noneNull.isEmpty{
            showText = (walletName.noneNull as NSString).substring(to: 1)
            showText = showText.uppercased()
        }
        
        guard let headView = HPBViewUtil.instantiateViewWithBundeleName(HPBGenerateHeadView.self, bundle: nil)as? HPBGenerateHeadView else{return nil}
        headView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        headView.textlabel.text = showText
        headView.layer.masksToBounds = true
         headView.layer.cornerRadius = 40
        headView.backgroundColor = UIColor.clear
        guard let generateImage = UIImage.getImageViewWithView(headView) else { return nil }
        let imageData = UIImagePNGRepresentation(generateImage)
        let imageName = address.noneNull.md5() + showText
        let imagePath = HPBFileManager.getHeadImageDirectory().appending("\(imageName).png")
        try? imageData?.write(to: URL(fileURLWithPath: imagePath))
       return imageName
    }
    
}
