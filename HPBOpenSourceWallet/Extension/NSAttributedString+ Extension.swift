//
//  AttributedString+ Extension.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/22.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

extension NSAttributedString{
    
    static func placeHoderAttributedString(_ content: String,color: UIColor = UIColor.hpbPurpleColor,fontScale: CGFloat = 15) -> NSAttributedString{
        let attrString = NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: fontScale), .foregroundColor: color])
        return attrString
    }

    
}
