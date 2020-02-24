//
//  HPBSelectImageView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/16.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBSelectImageView: UIView {
    
    
    var itemViews: [HPBSelectImageItemView] = []
    let imageCount = 3
    var selectImageBlock: (()->Void)?
    var clearBlock: ((Int)->Void)?
    
    func reloadImages(datas: [Data]){
        
        for itemView in itemViews{
            itemView.imageview.image = nil
        }
        
        if datas.isEmpty{
            let itemView = self.itemViews[0]
            itemView.imageview.image = #imageLiteral(resourceName: "my_feedback_picture")
            itemView.clearBtn.isHidden = true
            itemView.imageview.isUserInteractionEnabled = true
           return
        }
        
        for (index,data) in datas.enumerated(){
            if index < imageCount{
                let itemView = self.itemViews[index]
                itemView.imageview.isUserInteractionEnabled = false
                itemView.imageview.image = UIImage(data: data)
                itemView.clearBtn.isHidden = false
            }else {
                //越界
            }
        }
        if datas.count < imageCount{
           let itemView = self.itemViews[datas.count]
            itemView.imageview.isUserInteractionEnabled = true
            itemView.contentMode = .scaleAspectFill
            itemView.layer.masksToBounds = true
            itemView.imageview.image = #imageLiteral(resourceName: "my_feedback_picture")
            itemView.clearBtn.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steupView()
    }
    
    func steupView(){
        self.backgroundColor = UIColor.white
        for index in 0..<imageCount{
          creatItemView(index)
        }
    }
    
    func creatItemView(_ index: Int){
        let itemView = HPBSelectImageItemView(frame: CGRect.zero)
        self.addSubview(itemView)
        itemView.selectImageBlock = { [weak self] in
            self?.selectImageBlock?()
        }
        itemView.clearBlock = { [weak self] in
            self?.clearBlock?(index)
        }
        itemViews.append(itemView)
        itemView.backgroundColor = UIColor.white
        itemView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(index * (65 + 20))
            make.height.width.equalTo(65)
            make.centerY.equalToSuperview()
        }
    }
}


class HPBSelectImageItemView: UIView {
    
    
    var selectImageBlock: (()->Void)?
    var clearBlock: (()->Void)?
    
    var imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    
    var clearBtn: HPBButton = {
        let clearBtn = HPBButton(type: .custom)
        clearBtn.isHidden = true
        clearBtn.setImage(#imageLiteral(resourceName: "DelButton2"), for: .normal)
        return clearBtn
    }()
    

    func steupView(){
        self.backgroundColor = UIColor.white
        self.addSubview(imageview)
        let tapgestuer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageview.addGestureRecognizer(tapgestuer)
        imageview.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.width.equalTo(55)
        }
        
        self.addSubview(clearBtn)
        clearBtn.addClickEvent { [weak self] in
            self?.clearBlock?()
        }
        clearBtn.snp.makeConstraints { (make) in
            make.left.equalTo(imageview.snp.right).offset(-10)
            make.bottom.equalTo(imageview.snp.top).offset(10)
            make.height.width.equalTo(20)
        }
    }
    
    
   @objc func selectImage(){
    self.selectImageBlock?()
  }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        steupView()
        
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        steupView()
    }
    
}
