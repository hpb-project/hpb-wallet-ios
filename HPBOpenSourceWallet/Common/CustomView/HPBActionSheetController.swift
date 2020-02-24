//
//  HPBActionSheetController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/2/12.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import SnapKit

class HPBActionSheetController: HPBBaseController {

    fileprivate let itemHeight: CGFloat = 50
    fileprivate let horizontalSpace: CGFloat = 0
    fileprivate var bottomConstraint: Constraint?
    fileprivate var backViewHeight: CGFloat  = 0
    fileprivate var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func creatsubViews(_ block: ((Int) -> Void)? = nil){
        
        
       
        
        
        // 18为两个间隔的距离之和
        backViewHeight = CGFloat(items.count + 1) * itemHeight + 10 + CGFloat(items.count - 1) + UIScreen.tabbarSafeBottomMargin
        let backView = UIView(frame: CGRect.zero)
        backView.backgroundColor = UIColor.init(withRGBValue: 0xF5F6F8)
        backView.layer.cornerRadius = 8
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            self.bottomConstraint = make.bottom.equalToSuperview().offset(backViewHeight).constraint
            make.height.equalTo(backViewHeight)
        }
        
        let topTapView = UIView()
        topTapView.backgroundColor = UIColor.clear
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        topTapView.addGestureRecognizer(tapgesture)
        self.view.addSubview(topTapView)
        topTapView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(backView.snp_top)
        }
        //上面的View
        let topBackView = UIView(frame: CGRect.zero)
        topBackView.backgroundColor = UIColor.clear
        topBackView.layer.masksToBounds = true
        topBackView.layer.cornerRadius = 8
        backView.addSubview(topBackView)
        topBackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horizontalSpace)
            make.centerX.equalToSuperview()
            make.height.equalTo(itemHeight * CGFloat(items.count) + CGFloat(items.count - 1))
            make.top.equalToSuperview()
        }
        
        for (index,item) in items.enumerated(){
            let itemBtn = HPBButton(type: .custom)
            itemBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            itemBtn.backgroundColor = UIColor.white
            itemBtn.setTitle(item, for: .normal)
            itemBtn.setTitleColor(UIColor.paNavigationColor, for: .normal)
            topBackView.addSubview(itemBtn)
            itemBtn.addClickEvent {[weak self] in
                self?.hideActionSheet(false)
                block?(index + 1)
            }
            itemBtn.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(CGFloat(index) * itemHeight + CGFloat(index))
                make.left.equalToSuperview()
                make.centerX.equalToSuperview()
                make.height.equalTo(itemHeight)
            }
            if index != items.count - 1{
                let spaceView = UIView(frame: CGRect.zero)
                spaceView.backgroundColor = UIColor.init(withRGBValue: 0xEAEBEF)
                topBackView.addSubview(spaceView)
                spaceView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(CGFloat(index + 1) * itemHeight + CGFloat(index))
                    make.height.equalTo(1)
                    make.left.equalToSuperview()
                    make.centerX.equalToSuperview()
                }
            }
            
            //取消按钮
            let cancelBtn = HPBButton(type: .custom)
            cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            cancelBtn.backgroundColor = UIColor.white
            cancelBtn.setTitle("Common-Cancel".localizable, for: .normal)
            cancelBtn.setTitleColor(UIColor.init(withRGBValue: 0x334364), for: .normal)
            backView.addSubview(cancelBtn)
            cancelBtn.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(horizontalSpace)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(topBackView.snp.bottom).offset(10)
            }
            cancelBtn.addClickEvent { [weak self] in
                self?.hideActionSheet()
                 block?(0)
            }
        }
    }
    
   @objc func tapDismiss(){
        
        hideActionSheet()
    }

    func showActionSheet(_ items: [String],handel: ((Int)-> Void)? = nil){
        self.items = items
        creatsubViews { (index) in
            handel?(index)
        }
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.bottomConstraint?.update(offset: 0)
                self.view.layoutIfNeeded()
            }
        }
        
        AppDelegate.shared.window?.rootViewController?.addChildViewController(self)
        AppDelegate.shared.window?.rootViewController?.view.addSubview(self.view)
        self.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func hideActionSheet(_ animation: Bool = true){
        UIView.animate(withDuration: animation ? 0.25 : 0, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint?.update(offset: self.backViewHeight)
            self.view.layoutIfNeeded()
        }) {(state) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
}
