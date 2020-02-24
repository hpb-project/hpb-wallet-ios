//
//  UIImage+Extension.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/23.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

extension UIImage {
    /// 用颜色创建一张图片
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    

    
    /// 返回一张可拉伸的图片, 参数分别是图片宽度的一半和图片高度的一半
    var stretchable: UIImage {
        return self.stretchableImage(withLeftCapWidth: Int(self.size.width/2.0), topCapHeight: Int(self.size.height/2.0))
    }
    
    
    static func getImageViewWithView(_ view: UIView) -> UIImage?{
          //https://www.jianshu.com/p/843613545e1e
         //先指定图像的大小,在指定的区域绘制图像,获取图像上下文
        UIGraphicsBeginImageContextWithOptions(view.frame.size,false,UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext(){
           view.layer.render(in: context)
        }
        //view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
     func reSizeImage(toSize: CGSize) -> UIImage?{
    
        UIGraphicsBeginImageContext(CGSize(width: toSize.width, height: toSize.height))
       self.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return    reSizeImage?.withRenderingMode(.alwaysOriginal)
    }
}


