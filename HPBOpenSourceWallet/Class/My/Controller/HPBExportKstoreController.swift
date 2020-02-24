//
//  HPBExportKstoreController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBExportKstoreController: HPBBaseController {

    enum HPBExportKstoreType: String{
        case file  = "ExportKstore-File"
        case qrcode = "Scan-QR"
        init(index: Int) {
            switch index {
            case 0:
                self = .file
            default:
                self = .qrcode
            }
        }
    }
    var kstoreStr: String? = ""
    lazy var switchViews: [UIView] = {
        return getSwitchViews()
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    fileprivate var slideSwitchView: CKSlideSwitchView = {
        var slideView = CKSlideSwitchView(frame: CGRect(x:0, y:0, width:UIScreen.width, height:UIScreen.height-UIScreen.navigationHeight))
        slideView.tabItemTitleNormalColor = UIColor.hpbPurpleColor
        slideView.tabItemTitleSelectedColor = UIColor.hpbBtnSelectColor
        slideView.topScrollViewBackgroundColor = UIColor.paBackground
        slideView.tabItemShadowColor = UIColor.hpbBtnSelectColor
        slideView.backgroundColor = UIColor.paBackground

        //添加阴影
        slideView.topScrollView.layer.shadowColor = UIColor.black.cgColor
        slideView.topScrollView.layer.shadowOffset = CGSize(width: 0, height: 2)
        slideView.topScrollView.layer.shadowOpacity = 0.15
        slideView.topScrollView.layer.shadowRadius = 20
        slideView.topScrollView.layer.masksToBounds = false
        return slideView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WalletHandel-Export-KS".localizable
        steupSwitchView()
        HPBExportViewModel.showAlert(vc: self, content: "CommonAlert-Export-Keystore".localizable)
        if let gesutres = navigationController?.view.gestureRecognizers{
            for gesture in gesutres{
                if gesture is UIScreenEdgePanGestureRecognizer{
                    slideSwitchView.rootScrollView.panGestureRecognizer.require(toFail: gesture)
                }
            }
        }
    }
    
    fileprivate func steupSwitchView(){
        view.addSubview(slideSwitchView)
        slideSwitchView.slideSwitchViewDelegate = self
        slideSwitchView.reloadData()
        slideSwitchView.bringSubview(toFront: slideSwitchView.topScrollView)
    }
    
    fileprivate func getSwitchViews() -> [UIView]{
        let kstoreFileView = Bundle.main.loadNibNamed(String(describing: HPBShowKstoreFileView.self), owner: nil, options: nil)?.first as! HPBShowKstoreFileView
        kstoreFileView.kstoreStr = kstoreStr
        let kstoreCodeView = Bundle.main.loadNibNamed(String(describing: HPBShowKstoreCodeView.self), owner: nil, options: nil)?.first as! HPBShowKstoreCodeView
        kstoreCodeView.kstoreStr = kstoreStr
        
        let subViewHeight = max(670, UIScreen.height) -  UIScreen.navigationHeight
        let fileScrollow = UIScrollView()
        fileScrollow.addSubview(kstoreFileView)
        kstoreFileView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo( subViewHeight)
            make.centerX.equalToSuperview()
        }
        let codeScrollow = UIScrollView()
        codeScrollow.contentSize = CGSize(width: 0, height: subViewHeight)
        codeScrollow.addSubview(kstoreCodeView)
        kstoreCodeView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(subViewHeight)
            make.centerX.equalToSuperview()
        }
        return [fileScrollow,codeScrollow]
    }
}


extension HPBExportKstoreController: CKSlideSwitchViewDelegate{
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightForTabItemForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 50
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, numberOfTabItemsForTopScrollView topScrollView: UIScrollView) -> Int {
        return 2
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, titleForTabItemForTopScrollViewAt index: Int) -> String? {
        return HPBExportKstoreType(index: index).rawValue.localizable
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView? {

        return switchViews[index]
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemWidthForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return self.view.frame.width/2.0
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightOfShadowImageForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 3
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemFontSizeForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 16
    }
}

