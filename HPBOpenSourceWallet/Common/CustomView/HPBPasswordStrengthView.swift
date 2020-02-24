//
//  HPBPasswordStrengthView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/15.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPasswordStrengthView: UIView {

    //图片和以前的强中弱方式
    enum HPBPasswordStrengthType{
        case nomal,image
    }
    
    enum HPBPasswordStrengthGrade: String{
      case low = "低"
      case middle = "中"
      case high = "高"
    }
    
   lazy var showLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.init(withRGBValue: 0xFF4465)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var  imageArr: [UIImage] = {
       return  [#imageLiteral(resourceName: "my_creat_password_weak"),#imageLiteral(resourceName: "my_creat_password_middle"),#imageLiteral(resourceName: "my_creat_password_strong")]
    }()
    
    lazy var  normalStrengthArr: [String] = {
        return  ["Common-Password-Strength-L","Common-Password-Strength-M","Common-Password-Strength-H"]
    }()
    
    lazy var passwordImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    var type: HPBPasswordStrengthType = .nomal
    var strength: HPBPasswordStrengthUtil.PasswordStrength = .none{
        didSet{
            switch strength {
            case .none:
                self.reloadUI(range: -1)
            case .weak:
                self.reloadUI(range: 0)
            case .middle:
                self.reloadUI(range: 1)
            case .strong:
                self.reloadUI(range: 2)
            }
        }
    }
    
    init() {
       super.init(frame: CGRect.zero)
        steupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    fileprivate func steupView(){
        
        switch  type {
        case .nomal:
            nomalTypeConfigUI()
        case .image:
           imageTypeConfigUI()
        }
        
    }
    
    fileprivate func reloadUI(range: Int){
        switch  type {
        case .nomal:
            nomalTypeReload(range)
        case .image:
            imageTypeReload(range)
        }
    }

}

extension HPBPasswordStrengthView{
    
    fileprivate  func imageTypeConfigUI(){
        self.addSubview(passwordImage)
        passwordImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func imageTypeReload(_ range: Int){
        
        if range == -1{
            passwordImage.image = nil
        }else{
            passwordImage.image = imageArr[range]
        }
    }
    
}

extension HPBPasswordStrengthView{
    
    fileprivate  func nomalTypeConfigUI(){
        self.addSubview(showLabel)
        showLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
       
    }
    
    fileprivate func nomalTypeReload(_ range: Int){
        if range != -1{
             showLabel.text = normalStrengthArr[range].localizable
        }
    }
    
}
