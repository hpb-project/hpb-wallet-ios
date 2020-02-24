//
//  HPBTextView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTextView: UIView {

   fileprivate lazy var textView: UITextView = {
       let textView = UITextView()
        textView.tintColor = UIColor.hpbInputColor
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.hpbInputColor
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    var textBeginEditBlock: (()-> Void)?
    var textEndEditBlock: (()-> Void)?
    
    var textViewLayout: UIEdgeInsets = UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 16.5){
        willSet{
            textView.snp.updateConstraints { (make) in
                 make.edges.equalToSuperview().inset(newValue)
            }
        }
    }
    
   var placehoderLabel: UILabel = {
        let label = HPBLabel(titleColor: UIColor.hpbPlacehoderColor, fontValue: 13, alignment: .left)
        return label
    }()
    
    ///border 宽度
    var borderWidth: CGFloat = 0{
        willSet{
            self.layer.borderWidth = newValue
        }
    }
    
    ///设置最大的输入字数(-1的话，默认是不限制字数)
    var limitMax: Int = -1
    
    /// 输入的block
    var inputNumberBlock:((Int)->Void)?
    
    ///placehoderLabel字体大小
    var placehoderLabelFont: CGFloat = 13{
        willSet{
          placehoderLabel.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    /// border颜色
    var borderColor: CGColor = UIColor.paDividing.cgColor{
        willSet{
            self.layer.borderColor = borderColor
        }
    }
    
    /// textView字体颜色
    var textViewTextColor: UIColor = UIColor.hpbInputColor {
        willSet{
            textView.tintColor = newValue
            textView.textColor = newValue
        }
    }
    
    /// textView的内容
    var content: String? {
        set{
         self.textView.text = newValue
          self.placehoderLabel.isHidden = !textView.text.isEmpty
          self.textViewDidChange(textView)
        }
        get{
          return textView.text
        }
        
    }
    
    /// placehoder文本
    var placehoder: String?{
        willSet{
            self.placehoderLabel.text = newValue
        }
    }
    
    var placehoderTopConstraint: CGFloat = 18{
        willSet{
            placehoderLabel.snp.updateConstraints { (make) in
              make.top.equalTo(newValue)
            }
        }
    }
    
    init(_ placeholder: String?) {
        super.init(frame: CGRect.zero)
        steupView(placeholder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    fileprivate func steupView(_ placeholder: String? = nil){
        
        self.addSubview(textView)
        self.addSubview(placehoderLabel)
        self.backgroundColor = UIColor.clear
        self.placehoderLabel.text = placeholder
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = borderColor
        textView.delegate = self
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 13, bottom: 10, right: 16.5))
        }
        placehoderLabel.numberOfLines = 5
        placehoderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16.5)
            make.top.equalTo(18)
            make.right.equalToSuperview().offset(-10)
        }
        
    }

}

extension HPBTextView: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textBeginEditBlock?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textEndEditBlock?()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placehoderLabel.isHidden = !textView.text.isEmpty
        if limitMax >= 0{
                if textView.text.noneNull.count > limitMax{
                    textView.text = (textView.text.noneNull as NSString).substring(to: limitMax)
                }
            inputNumberBlock?(textView.text.noneNull.count > limitMax ? limitMax: textView.text.noneNull.count)
            }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            self.resignFirstResponder()
            return false
        }
        return true
    }
    
    func isText(textView: UITextView,beyondLimit maxLimit: Int) -> Bool{
        
        if HPBLanguageUtil.share.language == .chinese{
            guard let range = textView.markedTextRange else{return false}
            let position = textView.position(from: range.start, offset: 0)
            if position == nil{
                if textView.text.noneNull.count > maxLimit{
                    return true
                }
            }
        }else{
            if textView.text.noneNull.count > maxLimit{
                return true
            }
            
        }
        return false
    }
    
}
