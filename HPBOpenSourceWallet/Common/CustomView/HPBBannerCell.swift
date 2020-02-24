//
//  PABannerCell.swift
//  wanjia
//
//  Created by 刘晓亮 on 2018/6/7.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import SDCycleScrollView

class HPBBannerCell: UITableViewCell {
    
    static let height = (UIScreen.width - 32)/340 * 100
    static let cellModel = HPBCellModel(identifier: "HPBBannerCell", height: height, classType: HPBBannerCell.self)
    let animationTime: Double = 3
    let cycleTimes: Int = 30     //循环次数
    var clickBannerBlock: ((Int) -> Void)?
    private var cycleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize  = CGSize(width: UIScreen.width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0.001
        layout.minimumLineSpacing = 0.001
        let collection =  UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = UIColor.white
        return collection
    }()
    
     private lazy var pageControl: KTPageControl = {
        let pageControl = KTPageControl(frame: CGRect.zero, currentImage: UIImage(named: "banner_pagecontrol_select"), andDefaultImage: UIImage(named: "banner_pagecontrol_normal"))
        return pageControl ?? KTPageControl()
    }()
    
    var timer: Timer?
    
    /// 网络图片
    var imageUrlStrs: [String] = []{
        didSet{
            timer?.invalidate()
            timer = Timer(timeInterval: animationTime, target: self, selector: #selector(autoScrollow), userInfo: nil, repeats: true)
            if let timerNull = timer{
                RunLoop.current.add(timerNull, forMode: .commonModes)
            }
            pageControl.isHidden = imageUrlStrs.count == 1
            pageControl.numberOfPages = imageUrlStrs.count
            self.cycleCollectionView.reloadData()
        }
    }
    ///对应的文字的数组
    var titleStrs: [String] = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cycleCollectionView.delegate = self
        cycleCollectionView.dataSource = self
        cycleCollectionView.register(UINib(nibName: "HPBBannerConnectCell", bundle: nil), forCellWithReuseIdentifier: "HPBBannerConnectCell")
        self.contentView.addSubview(cycleCollectionView)
        cycleCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.bottom.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc  func autoScrollow(){
        if imageUrlStrs.count == 1{
            timer?.invalidate()
        }else{
            let page: Int = Int(cycleCollectionView.contentOffset.x)/Int(UIScreen.width)
            var offsizex = CGFloat(page) * UIScreen.width + UIScreen.width
            if offsizex >= cycleCollectionView.contentSize.width - UIScreen.width{
               offsizex = 0
            }
            cycleCollectionView.setContentOffset(CGPoint(x: offsizex, y: 0), animated: offsizex == 0 ? false : true)
            pageControl.currentPage = (page + 1) % imageUrlStrs.count
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
}

extension HPBBannerCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageUrlStrs.count == 1{
            return 1
        }
        return imageUrlStrs.count * cycleTimes
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.cycleCollectionView.dequeueReusableCell(withReuseIdentifier: "HPBBannerConnectCell", for: indexPath) as!  HPBBannerConnectCell
        let index = indexPath.row % imageUrlStrs.count
        let imageName = imageUrlStrs[index]
        let titleName = titleStrs[index]
        cell.titleLabel.text = titleName
        cell.image.backgroundColor = UIColor.white
        cell.image.sd_setImage(with: URL(string: imageName), placeholderImage: #imageLiteral(resourceName: "bannerPlaceholder"))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let index = indexPath.row % imageUrlStrs.count
        self.clickBannerBlock?(index)
    }

}

extension HPBBannerCell: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/UIScreen.width
        pageControl.currentPage = Int(page) % imageUrlStrs.count
    }

}
