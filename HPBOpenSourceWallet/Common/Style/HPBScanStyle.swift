//
//  HPBScanStyle.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import LBXScan

class HPBScanStyle {
    
    /// 扫描二维码样式
    /// - Returns: 样式类型
    static func qrCodeScanStyle() -> LBXScanViewStyle{
        let style = LBXScanViewStyle()
        //默认取景框居中，centerUpOffset控制上下移动
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = .inner;
        style.photoframeLineW = 2;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = true;
        
        //  调用pod中的资源文件
        let podBundle =  Bundle(for: LBXScanView.self)
        let bundlePath = podBundle.path(forResource: "CodeScan", ofType: "bundle")
        let imgLine = UIImage(named: "\(bundlePath.noneNull)/qrcode_Scan_weixin_Line")
        style.animationImage = imgLine;
        style.notRecoginitonArea = UIColor(R: 0, G: 0, B: 0, A: 0.6)
        return style
    }
    
}
