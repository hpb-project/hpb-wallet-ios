//
//  String+Extension.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/23.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

extension String{
    
    func addHexPrefix() -> String {
        if !self.hasPrefix("0x") {
            return "0x" + self
        }
        return self
    }
    
    func removeHexPrefix() -> String {
        if self.hasPrefix("0x") {
          return (self as NSString).replacingOccurrences(of: "0x", with: "")
        }
        return self
    }
    
    //  国际化配置
    var localizable: String {
       return HPBLanguageUtil.share.getStringForKey(self)
    }
    
    var MainLocalizable: String {
        return HPBLanguageUtil.share.getStringForKey(self,"Main")
    }
    
    func localizableXIB(_ name: String)-> String{
       return HPBLanguageUtil.share.getStringForKey(self,name)
    }
    
    
    //URL链接国际化
    var webViewUrllocalizable: String{
        if HPBLanguageUtil.share.language == .chinese{
            return self
        }else{
            return self + "en"
        }
    }
    
    func cutOutAddress(_ left: Int = 5,right: Int = 5)-> String{
        if self.count < left + right{
            return self
        }
       let leftStr = (self as NSString).substring(to: left)
       let rightStr  = (self as NSString).substring(from: self.count - right)
        return leftStr + "..." + rightStr

    }
    
    
}

public extension String {
    
    var intValue: Int {
        if let value = Int(self) {
            return value
        }
        return 0
    }
    
    var doubleValue: Double {
        if let value = Double(self) {
            return value
        }
        return 0
    }
    
}


extension String{
    
    //将十六进制字符串转化为 Data
    func hexStrConvertData() -> Data? {
        let bytes = self.bytes(from: self)
        if bytes == nil{
            return nil
        }
        return Data(bytes: bytes!)
    }
    
    // 将16进制字符串转化为 [UInt8]
    // 使用的时候直接初始化出 Data
    // Data(bytes: Array<UInt8>)
    private func bytes(from hexStr: String) -> [UInt8]? {
        if hexStr.count % 2 != 0{  //"输入字符串格式不对，8位代表一个字符"
           return nil
        }
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                return nil    //"输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内"
            }
            sum = sum * 16 + intC
            // 每两个十六进制字母代表8位，即一个字节
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }
}

extension String{
    
    
    /// 生成黑白普通二维码(默认大小为300)
    public func generatorQRCode(size: CGFloat = 300) -> UIImage {
        let ciImage = generateCIImage(size: size, color: UIColor.black, bgColor: UIColor.white)
        return UIImage(ciImage: ciImage)
    }
    
    public func generatorQRCode(size: CGFloat = 300, logo: UIImage, logoSize: CGFloat?) -> UIImage {
        let ciImage = generateCIImage(size: size, color: UIColor.black, bgColor: UIColor.white)
        let image = UIImage(ciImage: ciImage)
        let logoWidth:CGFloat = logoSize ?? logo.size.width
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        image.draw(in: rect)
        
        let avatarSize = CGSize(width: logoWidth, height: logoWidth)
        logo.draw(in: CGRect(origin: CGPoint(x: (rect.width-logoWidth) * 0.5, y: (rect.height - logoWidth) * 0.5), size: avatarSize))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
    
    public func generateCIImage(size: CGFloat, color: UIColor, bgColor: UIColor) -> CIImage {
        //二维码滤镜
        let contentData = self.data(using: String.Encoding.utf8)
        let fileter = CIFilter(name: "CIQRCodeGenerator")
        
        fileter?.setValue(contentData, forKey: "inputMessage")
        fileter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let ciImage = fileter?.outputImage
        
        //颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(cgColor: color.cgColor), forKey: "inputColor0")// 二维码颜色
        colorFilter?.setValue(CIColor(cgColor: bgColor.cgColor), forKey: "inputColor1")// 背景色
        
        //生成处理
        let outImage = colorFilter!.outputImage
        let scale = size / outImage!.extent.size.width
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = colorFilter!.outputImage!.transformed(by: transform)
        
        return transformImage
    }
}

extension String{
    func underline(_ color: UIColor = UIColor.hpbYellowColor) -> NSAttributedString{
        let attributedString = NSMutableAttributedString.init(string: self)
        attributedString.addAttributes(
            [NSAttributedStringKey.underlineStyle : NSNumber.init(value: 1),
             NSAttributedStringKey.underlineColor: color,
             NSAttributedStringKey.foregroundColor : color],
            range: NSRange(location: 0, length: self.count))
        return attributedString
    }
    
    func attributeStrColor(_ color: UIColor = UIColor.init(withRGBValue: 0xFF7817)) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString.init(string: self)
         attributedString.addAttributes([NSAttributedStringKey.foregroundColor : color], range: NSRange(location: 0, length: self.count))
        return attributedString
    }
    
    func getTextHeigh(fontSize: CGFloat = 15,width:CGFloat = UIScreen.width) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.height)
    }
    
    
    func attributeStrColorAndFont(_ color: UIColor = UIColor.white) -> NSAttributedString{
        let attributedString = NSMutableAttributedString.init(string: self)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : color], range: NSRange(location: 0, length: self.count))
        return attributedString
    }
}


extension String{
    
    ///1.5.0版本,产品确定修改为 结尾的0不显示
    /// 0.900 显示 0.9 ,1.0显示1
    
    ///
    func addMicrometerLevel(digitsNumber: Int = 8) -> String {
        let numberStyle = HPBNumberStyleUtil.share.style
        if self.doubleValue == 0{
            return "0"
        }else{
            var integerPart: String?  = self
            var decimalPart: String? = nil
            var formatInter: String = ""
            //包含小数点
            if self.contains("."){
                let array = self.components(separatedBy: ".")
                integerPart = array.first
                decimalPart = array.last
            }
            
            //先将整数部分倒序
            let reverseStr = integerPart.noneNull.convertReverse()
            
            for (index,character) in reverseStr.enumerated(){
                if index % 3 == 0 && index != 0{
                    formatInter.append(numberStyle.thousandSeparator)
                }
                formatInter.append(character)
            }
            //再将整数部分倒序过来
            let formatReverse = formatInter.convertReverse()
            if digitsNumber == 0{
                return formatReverse
            }
            if decimalPart != nil{
                //补齐0
                return formatReverse + numberStyle.dotSeparator + decimalPart.noneNull
            }else{
                return formatReverse
            }
        }
    }
    
    
    func addMoneyDecimalNumber(_ digitsNumber: Int = 2) -> String {
        let numberStyle = HPBNumberStyleUtil.share.style
        if self.doubleValue == 0{
            return "0" + numberStyle.dotSeparator  +  String(repeating: "0", count: digitsNumber)
        }else{
            var integerPart: String?  = self
            var decimalPart: String? = nil
            var formatInter: String = ""
            //包含小数点
            if self.contains("."){
                let array = self.components(separatedBy: ".")
                integerPart = array.first
                decimalPart = array.last
            }
            
            //先将整数部分倒序
            let reverseStr = integerPart.noneNull.convertReverse()
            
            for (index,character) in reverseStr.enumerated(){
                if index % 3 == 0 && index != 0{
                    formatInter.append(numberStyle.thousandSeparator)
                }
                formatInter.append(character)
            }
            //再将整数部分倒序过来
            let formatReverse = formatInter.convertReverse()
            if digitsNumber == 0{
                return formatReverse
            }
            if decimalPart != nil{
                //补齐0
                return formatReverse + numberStyle.dotSeparator + decimalPart.noneNull + String(repeating: "0", count: digitsNumber - decimalPart.noneNull.count)
            }else{
                return formatReverse + numberStyle.dotSeparator + String(repeating: "0", count: digitsNumber)
            }
        }
    }
    
    
    func convertReverse()-> String{
        var reverseStr = ""
        for character in self.reversed(){
            reverseStr.append(character)
        }
        return reverseStr
    }
}



extension String {
    
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
}
