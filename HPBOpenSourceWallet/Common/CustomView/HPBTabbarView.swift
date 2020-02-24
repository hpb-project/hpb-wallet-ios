//
//  HPBTabbarView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/21.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTabbarView: UIView {
    
    var selectBlock: ((Int) -> Void)?
    
    var currentIndex: Int = 0{
        willSet{
            for btn in btnArr{
                btn.isSelected = false
            }
            let selectBtn =  btnArr[newValue]
            selectBtn.isSelected = true
        }
    }
    fileprivate var btnArr: [UIButton] = []
    fileprivate var titleArray: [UILabel] = []
    
    init(nomalImages: [UIImage],selectImages: [UIImage]){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.paBackground
        let count = nomalImages.count
        for index in 0..<count{
            let tabbarBtn  = HPBTabbar(nomarl: nomalImages[index], select: selectImages[index])
            tabbarBtn.tag = index + 100
            tabbarBtn.addTarget(self, action: #selector(tabbarBtnClick), for: .touchUpInside)
            self.addSubview(tabbarBtn)
            tabbarBtn.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(CGFloat(index) * UIScreen.width / CGFloat(nomalImages.count))
                make.width.equalTo(UIScreen.width / CGFloat(nomalImages.count))
            }
            btnArr.append(tabbarBtn)
        }
    }
    
    @objc func tabbarBtnClick(sender: UIButton){
        let index = sender.tag - 100
        selectBlock?(index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class HPBTabbar: UIButton{
    
    init(nomarl: UIImage,select: UIImage){
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.setImage(nomarl, for: .normal)
        self.setImage(select, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
