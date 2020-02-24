//
//  HPBFeedbackSelectView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBFeedbackSelectView: UIView {
    
    var btnTitles: [String] = []{
        didSet{
            steupViews()
        }
    }
    var index: Int = 0
    fileprivate var buttonArr: [UIButton] = []
    fileprivate var titleSelectColor: UIColor =  UIColor.hpbBtnSelectColor
    fileprivate var titleNormalColor: UIColor =  UIColor.hpbPurpleColor
    fileprivate var  btnSpace: CGFloat = 10
    init(btnTitles: [String]) {
        super.init(frame: CGRect.zero)
        self.btnTitles = btnTitles
        steupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func steupViews(){
        self.backgroundColor = UIColor.clear
        for subView in self.subviews{
            subView.removeFromSuperview()
        }
        var recordBtn: UIButton?
        for index in 0..<self.btnTitles.count{
            let btn = creatBtn()
            btn.setTitle(self.btnTitles[index].localizable, for: .normal)
            self.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            if recordBtn == nil{
                setBtnColor(btn, color: titleSelectColor)
                btn.snp.makeConstraints { (make) in
                    make.left.equalToSuperview()
                }
            }else if index == self.btnTitles.count - 1{
                btn.snp.makeConstraints { (make) in
                    make.left.equalTo(recordBtn!.snp.right).offset(btnSpace)
                    make.right.equalToSuperview()
                    make.width.equalTo(recordBtn!.snp.width)
                }
            }else{
                btn.snp.makeConstraints { (make) in
                    make.left.equalTo(recordBtn!.snp.right).offset(btnSpace)
                    make.width.equalTo(recordBtn!.snp.width)
                }
            }
            buttonArr.append(btn)
            recordBtn = btn
        }
    }
    
    fileprivate func creatBtn() -> UIButton{
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        btn.layer.borderWidth = UIScreen.separatorSize
        setBtnColor(btn)
        return btn
    }
    
    @objc fileprivate  func selectBtnClick(btn: UIButton){
        for button in buttonArr{
            setBtnColor(button)
        }
        setBtnColor(btn,color: titleSelectColor)
    }
    
    fileprivate func setBtnColor(_ btn: UIButton,color: UIColor = UIColor.hpbPurpleColor){
        btn.setTitleColor(color, for: .normal)
        btn.layer.borderColor = color.cgColor
    }
    
}
