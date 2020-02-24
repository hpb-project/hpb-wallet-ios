//
//  HPBTabBarController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupViews()
       NotificationCenter.default.addObserver(self, selector: #selector(hiddenRedPoint), name: Notification.Name.HPBHiddenRedPoint, object: nil)
    }
    
    @objc private func hiddenRedPoint(){
        self.tabBar.changeMessageBadge()
    }
    
    func steupViews(){
        guard let viewControllers = self.viewControllers else{return}
        if viewControllers.count == 3{
            let homeNav = viewControllers[0] as? HPBBaseNavigationController
            homeNav?.tabBarItem = HPBTabBarItem(with: "TabBar-Main.title".localizable, normalImage: #imageLiteral(resourceName: "icon_gzt1"), selectImage: #imageLiteral(resourceName: "icon_gzt2"))
            let newsNav = viewControllers[1] as? HPBBaseNavigationController
            newsNav?.tabBarItem = HPBTabBarItem(with: "TabBar-News.title".localizable, normalImage: #imageLiteral(resourceName: "icon_xx1"), selectImage: #imageLiteral(resourceName: "icon_xx2"))
            
            let myNav = viewControllers[2] as? HPBBaseNavigationController
            myNav?.tabBarItem = HPBTabBarItem(with: "TabBar-My.title".localizable, normalImage: #imageLiteral(resourceName: "icon_wd1"), selectImage: #imageLiteral(resourceName: "icon_wd2"))
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}


extension HPBTabBarController{
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if #available(iOS 11.0, *)
        {
            let feedBackGenertor = UIImpactFeedbackGenerator(style: .heavy)
            feedBackGenertor.impactOccurred()
            
            
        }
    }
    
    
}
