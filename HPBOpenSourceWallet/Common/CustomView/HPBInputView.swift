//
//  HPBInputView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBInputView: UIView {

    enum HPBTitleType{
        case had,no
    }
    struct HPBInputModel {
        var title: String?
        var placehoder: String?
        var type: HPBTitleType = .no
        var leftValue: CGFloat = 0
        
        init(_ title: String? = nil,_ placehoder: String? = nil,
             type: HPBTitleType = .no,_ leftValue: CGFloat = 0){
            
            self.title = title
            self.placehoder = placehoder
            self.type = type
            self.leftValue = 0
        }
    }

    @IBOutlet weak var textField: HPBTextField!
    fileprivate var type: HPBTitleType = .no

    var textFieldContent: String{
        return textField.text.noneNull
    }
    
    var inputModel: HPBInputModel?{
        willSet{
            guard let `newValue` = newValue else {
                return
            }
            textField.placeholder = newValue.placehoder
            textField.setPlaceHoder()
            textField.textAlignment = .left

        }
    }
    
    init(type: HPBTitleType){
        super.init(frame: CGRect.zero)
        steupView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    func steupView(){
        
        let nib = UINib(nibName: "HPBInputView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
