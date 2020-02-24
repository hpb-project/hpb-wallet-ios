//
//  HPBGuideView.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/8/8.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBGuideView: UIView {
    
    lazy var imageArr: [UIImage] = {
        return [#imageLiteral(resourceName: "guide-1"),#imageLiteral(resourceName: "guide-2"),#imageLiteral(resourceName: "guide-3")]
    }()
    fileprivate let topContents = ["Guide-Page-Top-1","Guide-Page-Top-2","Guide-Page-Top-3"]
    fileprivate let bottomContents = ["Guide-Page-1","Guide-Page-2","Guide-Page-3"]
    fileprivate let pageControl = UIPageControl()
    fileprivate let scrollView  = UIScrollView()
    fileprivate let skipBtn     = UIButton(type: .custom)
    fileprivate let clickInBtn  = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         steupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func steupViews() {
        scrollView.frame = self.bounds
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        let contentSizeW = scrollView.bounds.size.width * CGFloat(imageArr.count)
        scrollView.contentSize.width = contentSizeW
        self.addSubview(scrollView)
        addScrollSubView(scrollView: scrollView)
        
       self.addSubview(pageControl)
        pageControl.numberOfPages = imageArr.count
        pageControl.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().offset(UIDevice.isIPHONE_X ? -64 : -40)
            make.centerX.equalToSuperview()
        }
        pageControl.currentPageIndicatorTintColor = UIColor.init(withRGBValue: 0x54658B)
        pageControl.pageIndicatorTintColor = UIColor.init(withRGBValue: 0xEAECEE)
        self.addSubview(skipBtn)
        skipBtn.backgroundColor = UIColor.init(withRGBValue: 0xd9d9d9)
        skipBtn.setTitle("Guide-skip".localizable + ">", for: .normal)
        skipBtn.addTarget(self, action: #selector(skipClick), for: .touchUpInside)
        skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        skipBtn.setTitleColor(UIColor.white, for: .normal)
        skipBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIScreen.statusHeight + 15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        skipBtn.layer.cornerRadius = 15
        
        
    }
    
    @objc func skipClick(){
        var animationTime: TimeInterval = 0.5
        var pageAlpha: CGFloat = 0
        if HPBLockManager.shared.secureLoginState{    //防止先出现内容页,再出现锁屏页面
            animationTime = 0
            pageAlpha = 1
        }
        UIView.animate(withDuration: animationTime, animations: {
            self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1);
            self.alpha = pageAlpha
        }) { (flag) in
              AppDelegate.shared.unlockAccount{               //解锁界面,成功后显示广告页
                self.removeFromSuperview()
                HPBRedPacketManager.share.receiveRedPacket()  //防止重叠,首次打开的时候就在所有加载完毕后再去检测
            }
            
        }
        
    }
    
    fileprivate func addScrollSubView(scrollView: UIScrollView){
        
        for (index,image) in self.imageArr.enumerated(){
            let backView = UIView()
            backView.backgroundColor = UIColor.clear
            let topContentLabel = UILabel()
            topContentLabel.textAlignment = .center
            topContentLabel.numberOfLines = 0
            topContentLabel.textColor = UIColor.init(withRGBValue: 0x191E25)
            topContentLabel.adjustsFontSizeToFitWidth = true
            topContentLabel.minimumScaleFactor = 0.5
            topContentLabel.font = UIFont.boldSystemFont(ofSize: 28)
            topContentLabel.text = self.topContents[index].localizable
            backView.addSubview(topContentLabel)
            topContentLabel.snp.makeConstraints { (make) in
                make.left.equalTo(32)
                make.top.equalToSuperview().offset(77 + UIScreen.statusHeight)
                make.centerX.equalToSuperview()
            }
            
            
            let bottomContentLabel = UILabel()
            bottomContentLabel.textAlignment = .center
            bottomContentLabel.numberOfLines = 0
            bottomContentLabel.textColor = UIColor.init(withRGBValue: 0x989898)
            bottomContentLabel.font = UIFont.systemFont(ofSize: 14)
            bottomContentLabel.text = self.bottomContents[index].localizable
            backView.addSubview(bottomContentLabel)
            bottomContentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(topContentLabel.snp_bottom).offset(10)
                make.left.equalToSuperview().offset(65)
                make.centerX.equalToSuperview()
            }
            
            let imageView = UIImageView()
            imageView.image = image
            backView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(bottomContentLabel.snp_bottom).offset(60 + UIScreen.statusHeight)
                make.left.equalToSuperview().offset(55)
                 make.centerX.equalToSuperview()
                make.height.equalTo(imageView.snp_width).multipliedBy(1.07954)
            }
            self.scrollView.addSubview(backView)
            backView.frame = CGRect(x: CGFloat(index) * UIScreen.width, y: 0, width: UIScreen.width, height: UIScreen.height)
            if index == self.imageArr.count - 1{
                imageView.isUserInteractionEnabled = true
                backView.addSubview(clickInBtn)
                addClickInBtn()
            }
        }
    }
    
    
    fileprivate func addClickInBtn(){
        clickInBtn.setTitle("Guide-clickIn".localizable, for: .normal)
        clickInBtn.backgroundColor = UIColor.init(withRGBValue: 0x334364)
        clickInBtn.layer.cornerRadius = 22
        clickInBtn.addTarget(self, action: #selector(skipClick), for: .touchUpInside)
        clickInBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        clickInBtn.setTitleColor(UIColor.white, for: .normal)
        clickInBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset( -UIScreen.tabbarSafeBottomMargin - 40)
            make.height.equalTo(44)
            make.width.equalTo(150)
        }
    }
    
}

extension HPBGuideView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if offset.x < 0 {//禁止左滑
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: false)
        }else if offset.x > UIScreen.width * CGFloat(self.imageArr.count - 1){
            scrollView.setContentOffset(CGPoint(x: UIScreen.width * CGFloat(self.imageArr.count - 1), y: scrollView.contentOffset.y), animated: false)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         let offset = scrollView.contentOffset
        let currentPage = Int(offset.x / UIScreen.width)
        if currentPage == self.imageArr.count - 1{
            skipBtn.isHidden = true
            pageControl.isHidden  = true
        }else{
            skipBtn.isHidden = false
            pageControl.isHidden  = false
        }
        self.pageControl.currentPage = currentPage
    }
    
}
