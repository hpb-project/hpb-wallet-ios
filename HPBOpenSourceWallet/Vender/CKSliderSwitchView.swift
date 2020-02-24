//
//  CKSlideSwitchView.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/6/26.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

enum CKSlideSwitchViewRunType: Int {
    case normal
    case left
    case right
}

@objc protocol CKSlideSwitchViewDelegate: NSObjectProtocol {
    /// topscrollview中tabitem的个数
    func slideSwitchView(_ view: CKSlideSwitchView, numberOfTabItemsForTopScrollView topScrollView: UIScrollView) -> Int
    /// topscrollview中tabitem所对应的title的值
    func slideSwitchView(_ view: CKSlideSwitchView, titleForTabItemForTopScrollViewAt index: Int) -> String?
    /// rootscrollview中的子view
    func slideSwitchView(_ view: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView?
    /// 设置每个tabitem的高度
    func slideSwitchView(_ view: CKSlideSwitchView, heightForTabItemForTopScrollView topScrollView: UIScrollView) -> CGFloat
    
    /// 设置顶部的栏目的宽度
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, widthForTopScrollView topScrollView: UIScrollView) -> CGFloat
    /// 设置偏移量
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, marginForTopScrollView topScrollView: UIScrollView) -> CGFloat
    /// 设置每个tabitem的宽度
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, tabItemWidthForTopScrollView topScrollView: UIScrollView) -> CGFloat
    /// 设置tabitem中按钮font的大小
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, tabItemFontSizeForTopScrollView topScrollView: UIScrollView) -> CGFloat
    /// 首次启动选择tabitem 中的第几个
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, selectedTabItemIndexWhenFirstStartForTopScrollview topScrollView: UIScrollView) -> Int
    /// topscrollview上的tabitem 分割线
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, seperatorImageShoudShowInTopScrollView topScrollView: UIScrollView) -> Bool
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, heightOfShadowImageForTopScrollView topScrollView: UIScrollView) -> CGFloat
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, tabItemImageNameForTopScrollViewAt index: Int) -> String
    @objc optional func slideSwitchView(_ view: CKSlideSwitchView, currentIndex index: Int)
}

class CKSlideSwitchView: UIView {

    //MARK: - Properties
    var  tabItemTitleNormalColor       : UIColor?
    var  tabItemTitleSelectedColor     : UIColor?
    var  tabItemNormalBackgroundImage  : UIImage?
    var  tabItemSelectedBackgroundImage: UIImage?
    var  tabItemShadowImage            : UIImage? {
        didSet {
            tabItemShadowImageView.image = tabItemShadowImage
        }
    }
    var  tabItemShadowColor            : UIColor? {
        didSet {
            tabItemShadowImageView.backgroundColor = tabItemShadowColor
        }
    }
    var  topScrollViewBackgroundImage  : UIImage? {
        didSet {
            if let image = topScrollViewBackgroundImage {
                topScrollView.backgroundColor = UIColor(patternImage: image)
            }
        }
    }
    var  topScrollViewBackgroundColor  : UIColor? {
        didSet {
            topScrollView.backgroundColor = topScrollViewBackgroundColor
        }
    }
    
    weak var slideSwitchViewDelegate: CKSlideSwitchViewDelegate?
    var tabItemClicked: ((Int) -> Swift.Void)?
    
    let  rootScrollView          : UIScrollView = {
        let rootScrollView = UIScrollView()
        rootScrollView.showsVerticalScrollIndicator   = false
        rootScrollView.showsHorizontalScrollIndicator = false
        rootScrollView.backgroundColor                = UIColor.paBackground
        rootScrollView.autoresizingMask               = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        rootScrollView.bounces                        = false
        rootScrollView.isPagingEnabled                = true
        return rootScrollView
    }()
    
    let topScrollView: UIScrollView = {
        let topSrollView = UIScrollView()
        topSrollView.backgroundColor                = UIColor.clear
        topSrollView.isPagingEnabled                = false
        topSrollView.showsHorizontalScrollIndicator = false
        topSrollView.showsVerticalScrollIndicator   = false
        topSrollView.autoresizingMask               = UIViewAutoresizing.flexibleWidth
        topSrollView.isScrollEnabled                = false
        return topSrollView
    }()
    
    fileprivate var isRootScroll  : Bool = false
    fileprivate var selectedTabTag: Int  = 0
    
    fileprivate var isBuildUI: Bool = false
    
    fileprivate var tabItemShadowImageView: UIImageView = UIImageView()
    fileprivate var rootScrollViewCurrentPage: Int = 0
    
    fileprivate var tabItems     : [UIButton] = []
    fileprivate var tabItemCount : Int        = 0
    fileprivate var tabItemHeight: CGFloat    = 0
    fileprivate var tabItemMargin: CGFloat    = 0
    fileprivate var tabItemWidth : CGFloat    = 0
    fileprivate var rootContentViews: [UIView] = []
    
    /// 是否自定义tabitem的宽度
    fileprivate var isCustomSetTabItemWidth: Bool = false
    /// 首次加载选择tabitem的index
    fileprivate var firstSelectedTabItemIndex: Int = 0
    
    fileprivate var tabItemFontSize: CGFloat = 0
    fileprivate var seperatorLineImageFlag: Bool = false
    
    fileprivate var shadowImageHeight: CGFloat = 0
    
    //MARK: - View Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //tintColor = .clear
        addSubview(rootScrollView)
        rootScrollView.delegate = self
        addSubview(topScrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    fileprivate func receiveDataFromDelegate() {
        if let count = slideSwitchViewDelegate?.slideSwitchView(self, numberOfTabItemsForTopScrollView: topScrollView) {
            tabItemCount = count
        }
    
        if let imageHeight = slideSwitchViewDelegate?.slideSwitchView?(self, heightOfShadowImageForTopScrollView: topScrollView) {
            shadowImageHeight = imageHeight
        }
    
        if let height = slideSwitchViewDelegate?.slideSwitchView(self, heightForTabItemForTopScrollView: topScrollView) {
            tabItemHeight = height
        }
        
        if let width = slideSwitchViewDelegate?.slideSwitchView?(self, tabItemWidthForTopScrollView: topScrollView) {
            tabItemWidth = width
            isCustomSetTabItemWidth = true
        }
        
        if let fontSize = slideSwitchViewDelegate?.slideSwitchView?(self, tabItemFontSizeForTopScrollView: topScrollView) {
            tabItemFontSize = fontSize
        }
        
        if let index = slideSwitchViewDelegate?.slideSwitchView?(self, selectedTabItemIndexWhenFirstStartForTopScrollview: topScrollView) {
            firstSelectedTabItemIndex = index
        }
        
        if let bool = slideSwitchViewDelegate?.slideSwitchView?(self, seperatorImageShoudShowInTopScrollView: topScrollView) {
            seperatorLineImageFlag = bool
        }
        
        if tabItemFontSize <= 0 {
            tabItemFontSize = 17
        }
        
        if let margin = slideSwitchViewDelegate?.slideSwitchView?(self, marginForTopScrollView: topScrollView) {
            tabItemMargin = margin
        }
    }
    
    fileprivate func createTabItemButtons() {
        topScrollView.addSubview(tabItemShadowImageView)
        
        // 顶部tabbar的总长度
        var topScrollViewContentWidth = tabItemMargin
        // tabitem的偏移量
        var xOffset = tabItemMargin
        var width: CGFloat = 0
        
        for index in 0..<tabItemCount {
            let tabItem: UIButton = UIButton(type: .custom)
            tabItems.append(tabItem)
            topScrollView.addSubview(tabItem)
            
            let text = slideSwitchViewDelegate?.slideSwitchView(self, titleForTabItemForTopScrollViewAt: index)
            let iconName = slideSwitchViewDelegate?.slideSwitchView?(self, tabItemImageNameForTopScrollViewAt: index)
            if tabItemWidth > 0 {
                tabItem.frame = CGRect(x: xOffset, y: 0, width: tabItemWidth, height: tabItemHeight)
                width = tabItemWidth
            }
            topScrollViewContentWidth += tabItemMargin + width
            xOffset += width + tabItemMargin
            tabItem.titleLabel?.font = UIFont.systemFont(ofSize: tabItemFontSize)
            tabItem.tag = index + 100
            if index == firstSelectedTabItemIndex {
                changeShadowViewFrame(with: tabItem)
                tabItem.isSelected = true
                selectedTabTag = index + 100
                 tabItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: tabItemFontSize)
            }
            if let icon = iconName {
                tabItem.setImage(UIImage(named: icon)?.withRenderingMode(.alwaysOriginal), for: .normal)
                tabItem.setImage(UIImage(named: icon + "_selected")?.withRenderingMode(.alwaysOriginal), for: .selected)
                tabItem.setImage(UIImage(named: icon + "_selected")?.withRenderingMode(.alwaysOriginal), for: [.selected, .highlighted])
            }
            tabItem.setTitle(text, for: .normal)
            if let normalColor = tabItemTitleNormalColor {
                tabItem.setTitleColor(normalColor, for: .normal)
            }
            if let selectedColor = tabItemTitleSelectedColor {
                tabItem.setTitleColor(selectedColor, for: .selected)
                tabItem.setTitleColor(selectedColor, for: [.selected, .highlighted])
            }
            if let normalBg = tabItemNormalBackgroundImage {
                tabItem.setBackgroundImage(normalBg, for: .normal)
            }
            if let selectedBg = tabItemSelectedBackgroundImage {
                tabItem.setBackgroundImage(selectedBg, for: .selected)
                tabItem.setBackgroundImage(selectedBg, for: [.selected, .highlighted])
            }
            tabItem.addTarget(self, action: #selector(tabItemAction), for: .touchUpInside)
            if seperatorLineImageFlag && index != tabItemCount - 1 {
                let separator = UIImageView()
                separator.frame = CGRect(x: tabItem.frame.maxX + tabItemMargin/2, y: (tabItemHeight - 14)/2, width: 1/UIScreen.main.scale, height: 14)
                separator.backgroundColor = UIColor.paDividing
                topScrollView.addSubview(separator)
                if tabItemMargin <= 0 {
                    topScrollViewContentWidth += separator.frame.width
                    xOffset += separator.frame.width
                }
            }
        }
        if selectedTabTag == 0 {
            selectedTabTag = 100
        }
        topScrollView.contentSize = CGSize(width: topScrollViewContentWidth, height: 0)
        addSepLine()
    }
    
    fileprivate func addSepLine() {
        guard topScrollView.viewWithTag(300005) == nil else { return }
        let separator = UIView()
        let height = 1/UIScreen.main.scale
        separator.frame = CGRect(x: 0, y: topScrollView.frame.height - height, width: topScrollView.frame.width, height: height)
        separator.backgroundColor = UIColor.paDividing
        separator.tag = 300005
        topScrollView.addSubview(separator)
    }
    
    fileprivate func changeShadowViewFrame(with view: UIView) {
        guard tabItemShadowImage != nil || tabItemShadowColor != nil else { return }
        let shadowHeight: CGFloat = shadowImageHeight > 0 ? shadowImageHeight : view.frame.height
        tabItemShadowImageView.frame = CGRect(x: view.frame.origin.x, y: view.frame.maxY - shadowHeight, width: view.frame.width, height: shadowHeight)
    }
    
    fileprivate func configRootScrollView(_ runType: CKSlideSwitchViewRunType) {
        rootScrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        setRootScrollViewDataSource(runType)
        
        var counter: Int = 0
        for contentView in rootContentViews {
            var rect = rootScrollView.frame
            rect.origin = CGPoint(x: rootScrollView.frame.width * CGFloat(counter), y: 0)
            contentView.frame = rect
            counter += 1
            rootScrollView.addSubview(contentView)
        }
        
        // 当总数为3个时, 特殊处理
        if tabItemCount == 3 || tabItemCount == 4 {
            rootScrollView.contentSize = CGSize(width: CGFloat(tabItemCount) * rootScrollView.frame.width, height: 0)
            rootScrollView.contentOffset = CGPoint(x: CGFloat(firstSelectedTabItemIndex) * rootScrollView.frame.width, y: 0)
        } else {
            // 总页数大于小于3时
            if rootScrollViewCurrentPage != 0 && rootScrollViewCurrentPage != tabItemCount - 1 {
                rootScrollView.contentSize = CGSize(width: 3 * rootScrollView.frame.width, height: 0)
            } else {
                rootScrollView.contentSize = CGSize(width: 2 * rootScrollView.frame.width, height: 0)
            }
            
            if rootScrollViewCurrentPage != 0 {
                rootScrollView.contentOffset = CGPoint(x: rootScrollView.frame.width, y: 0)
            } else {
                rootScrollView.contentOffset = CGPoint.zero
                if tabItemCount <= 1 {
                    rootScrollView.contentSize = CGSize(width: rootScrollView.frame.width, height: 0)
                }
            }
        }
    }
    
    fileprivate func setRootScrollViewDataSource(_ runType: CKSlideSwitchViewRunType) {
        /// 总数为3 的情况
        if tabItemCount == 3 || tabItemCount == 4 {
            rootContentViews.removeAll()
            for index in 0..<tabItemCount {
                if let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: index) {
                    rootContentViews.append(view)
                }
            }
        }
        else { // 总数不为3的情况
            let previousPageIndex: Int = getValidNextPageIndex(with: rootScrollViewCurrentPage - 1)
            let nextPageIndex    : Int = getValidNextPageIndex(with: rootScrollViewCurrentPage + 1)
            switch runType {
            case .normal:
                rootContentViews.removeAll()
                if rootScrollViewCurrentPage != 0, let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: previousPageIndex)  {
                    rootContentViews.append(view)
                }
                if let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: rootScrollViewCurrentPage) {
                    rootContentViews.append(view)
                }
                if rootScrollViewCurrentPage != tabItemCount - 1, tabItemCount > 1, let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: nextPageIndex) {
                    rootContentViews.append(view)
                }
            case .left:
                guard tabItemCount >= 3 else { return }
                if rootContentViews.count == 3 {
                    rootContentViews.remove(at: 0)
                    if rootScrollViewCurrentPage != tabItemCount - 1, let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: nextPageIndex) {
                        rootContentViews.append(view)
                    }
                } else if rootScrollViewCurrentPage == 1, let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: nextPageIndex){
                    rootContentViews.append(view)
                }
            case .right:
                guard tabItemCount >= 3 else { return }
                if rootContentViews.count == 3 {
                    rootContentViews.remove(at: 2)
                    if rootScrollViewCurrentPage != 0, let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: previousPageIndex) {
                        rootContentViews.insert(view, at: 0)
                    }
                } else if rootScrollViewCurrentPage == tabItemCount - 2, let view = slideSwitchViewDelegate?.slideSwitchView(self, viewForRootScrollViewAt: previousPageIndex) {
                    rootContentViews.insert(view, at: 0)
                }
            }
        }
    }
    
    fileprivate func getValidNextPageIndex(with currentPageIndex: Int) -> Int {
        if currentPageIndex == -1 {
            return tabItemCount - 1
        } else if currentPageIndex == tabItemCount {
            return 0
        } else {
            return currentPageIndex
        }
    }
    
    /// 调整顶部topscrollView的偏移量
    fileprivate func adjustScrollViewContentX(with button: UIButton) {
        if CGFloat(tabItemCount) * tabItemWidth <= frame.width { return }
        if topScrollView.contentOffset.x > button.frame.origin.x {
            let point = CGPoint(x: button.frame.origin.x - tabItemMargin, y: 0)
            topScrollView.setContentOffset(point, animated: false)
        } else if topScrollView.contentOffset.x + topScrollView.frame.width < button.frame.maxX {
            let point = CGPoint(x: button.frame.maxX - topScrollView.frame.width, y: 0)
            topScrollView.setContentOffset(point, animated: false)
        }
    }
    
    // scrollview改变对应的btn颜色也改变
    fileprivate func changeButtonWhenScrollViewChanges() {
        guard rootScrollViewCurrentPage + 100 != selectedTabTag else { return }
        isRootScroll = true
        if let tabItem = topScrollView.viewWithTag(rootScrollViewCurrentPage + 100) as? UIButton {
            tabItemAction(sender: tabItem)
        }
    }
 
    func reloadData() {
        topScrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        rootScrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
        rootContentViews.removeAll()
        
        receiveDataFromDelegate()
        
        if tabItemCount <= 0 {
            return
        }
        
        rootScrollViewCurrentPage = firstSelectedTabItemIndex
        var topScrollViewWidth = frame.size.width
        if let width = slideSwitchViewDelegate?.slideSwitchView?(self, widthForTopScrollView: topScrollView) {
            topScrollViewWidth = width
        }
        topScrollView.frame = CGRect(x: 0, y: 0, width: topScrollViewWidth, height: tabItemHeight)
        rootScrollView.frame = CGRect(x: 0, y: tabItemHeight, width: frame.width, height: frame.height - tabItemHeight)
        configRootScrollView(.normal)
        createTabItemButtons()
    }
    
    func switchTo(index: Int) {
        tabItemAction(sender: tabItems[index])
    }
    
    var selectedTabItemIndex: Int {
        return selectedTabTag - 100
    }
    
    var selectedViewInRootScrollView: UIView? {
        for view in rootContentViews {
            if view.tag == selectedTabItemIndex {
                return view
            }
        }
        return nil
    }
    
    func contentView(ofIndex index: Int) -> UIView? {
        for view in rootContentViews {
            if view.tag == index {
                return view
            }
        }
        return nil
    }
    
    func hideTopScrollview() {
        topScrollView.isHidden = true
        rootScrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        for view in rootScrollView.subviews {
            view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
    }
    
    func set(title:String?,at index:NSInteger){
        guard tabItems.count > index else {
            return
        }
        let button = tabItems[index]
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .highlighted)
    }
    
    func reload(titles:[String?]){
        guard tabItems.count > 0,tabItems.count <= titles.count else {
            return
        }
        
        for index in 0...tabItems.count - 1{
            let title = titles[index]
            set(title: title, at: index)
        }
    }
 
    @objc fileprivate func tabItemAction(sender: UIButton) {
        tabItemClicked?(sender.tag - 100)
        if sender.isSelected { return }
        //方法有问题
        self.adjustScrollViewContentX(with: sender)
        
        for view in topScrollView.subviews {
            if let button = view as? UIButton, button.isSelected {
                button.isSelected = false
                button.titleLabel?.font = UIFont.systemFont(ofSize: tabItemFontSize)
                break
            }
        }
        
        selectedTabTag = sender.tag
        sender.isSelected = true
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: tabItemFontSize)

        
        slideSwitchViewDelegate?.slideSwitchView?(self, currentIndex: sender.tag - 100)
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.changeShadowViewFrame(with: sender)
        }) { (finished) in
            guard finished else { return }
            if !self.isRootScroll {
                let selectedIndex = sender.tag - 100
                if self.tabItemCount == 3 || self.tabItemCount == 4 {
                    self.rootScrollViewCurrentPage = selectedIndex
                    let point = CGPoint(x: self.rootScrollView.frame.width * CGFloat(self.rootScrollViewCurrentPage), y: 0)
                    self.rootScrollView.setContentOffset(point, animated: true)
                }
                else {
                    if selectedIndex == self.rootScrollViewCurrentPage + 1 {
                        self.rootScrollViewCurrentPage = selectedIndex
                        self.configRootScrollView(.left)
                    } else if selectedIndex == self.rootScrollViewCurrentPage - 1 {
                        self.rootScrollViewCurrentPage = selectedIndex
                        self.configRootScrollView(.right)
                    } else {
                        self.rootScrollViewCurrentPage = selectedIndex
                        self.configRootScrollView(.normal)
                    }
                }
            }
            self.isRootScroll = false
        }
    }
}

//MARK: - UIScrollViewDelegate
extension CKSlideSwitchView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == rootScrollView, tabItemCount != 3, tabItemCount != 4 else { return }
        
        let rootScrollViewOffsetX = scrollView.contentOffset.x
        if rootScrollViewCurrentPage != 0 && rootScrollViewCurrentPage != tabItemCount - 1 {
            if rootScrollViewOffsetX >= 2 * scrollView.frame.width {
                rootScrollViewCurrentPage = getValidNextPageIndex(with: rootScrollViewCurrentPage + 1)
                configRootScrollView(.left)
                changeButtonWhenScrollViewChanges()
            } else if rootScrollViewOffsetX <= 0 {
                rootScrollViewCurrentPage = getValidNextPageIndex(with: rootScrollViewCurrentPage - 1)
                configRootScrollView(.right)
                changeButtonWhenScrollViewChanges()
            }
        } else if rootScrollViewCurrentPage == tabItemCount - 1, rootScrollViewOffsetX <= 0 {
            rootScrollViewCurrentPage = getValidNextPageIndex(with: rootScrollViewCurrentPage - 1)
            configRootScrollView(.right)
            changeButtonWhenScrollViewChanges()
        } else if rootScrollViewCurrentPage == 0, rootScrollViewOffsetX >= scrollView.frame.width {
            rootScrollViewCurrentPage = getValidNextPageIndex(with: rootScrollViewCurrentPage + 1)
            configRootScrollView(.left)
            changeButtonWhenScrollViewChanges()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == rootScrollView else { return }
        if tabItemCount == 3 || tabItemCount == 4 {
            let pageWidth = scrollView.frame.width
            let page: Int = Int(floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1)
            rootScrollViewCurrentPage = page
            changeButtonWhenScrollViewChanges()
        } else if rootScrollViewCurrentPage != 0 {
            let point = CGPoint(x: rootScrollView.frame.width, y: 0)
            scrollView.setContentOffset(point, animated: true)
        }
    }
    
}
