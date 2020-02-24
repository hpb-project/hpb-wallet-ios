//
//  HPBBaseNavigationController.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/29.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

typealias CustomLeftBackButtonAction  = (() -> Void)

class HPBBaseNavigationController: UINavigationController {
    
    var isWhiteBar: Bool = false{
        willSet{
            if newValue{
                leftButton.setImage(#imageLiteral(resourceName: "back_leftBtn_gray"), for: .normal)
            }else{
                leftButton.setImage(#imageLiteral(resourceName: "back_leftBtn_white"), for: .normal)
            }
        }
    }
    
    var isPushing: Bool = false
    
    var leftButton: HPBButton = HPBButton(type: .custom)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(rootViewController: UIViewController, tabBarItem: UITabBarItem? = nil) {
        super.init(rootViewController: rootViewController)
        rootViewController.tabBarItem = tabBarItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
        self.navigationBar.isTranslucent = false

        //去除黑线
        //self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapNavigationBar))
        self.navigationBar.addGestureRecognizer(tapgesture)
    }
    
    @objc func tapNavigationBar(){
        self.view.endEditing(true)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if isPushing {
            return
        } else {
            isPushing = true
        }
        if viewController.navigationItem.leftBarButtonItem == nil, viewControllers.count > 0{
            viewController.navigationItem.setLeftBarButton(customLeftBackButton(clickAction: nil), animated: true)
        }
        super.pushViewController(viewController, animated: animated)
        if let frame = tabBarController?.tabBar.frame {
            tabBarController?.tabBar.frame.origin.y = UIScreen.height - frame.size.height
        }
    }
    
    func getScreenEdgePanGestureRecognizer() -> UIScreenEdgePanGestureRecognizer? {
        if let gestureRecognizers = view.gestureRecognizers {
            for ges in gestureRecognizers {
                if ges is UIScreenEdgePanGestureRecognizer {
                    return ges as? UIScreenEdgePanGestureRecognizer
                }
            }
        }
        return nil
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if isWhiteBar{
            if #available(iOS 13, *){
                return .darkContent
            }
            return .default
        }else{
            return .lightContent
        }
    }
    
    deinit {
        debugLog(String(describing: self.classForCoder) + "析构方法执行")
    }
    
}

extension HPBBaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count == 1 ||
                topViewController?.presentedViewController != nil {
                return false
            }
        }
        return true
    }
}

//MARK: - UINavigationControllerDelegate
extension HPBBaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isPushing = false
    }
    
    func customLeftBackButton(clickAction: CustomLeftBackButtonAction?) -> UIBarButtonItem {

        leftButton.frame = CGRect(x: 0, y: 0, width: 32.0, height: UIScreen.navigationBarHeight)
        leftButton.addClickEvent { [weak self] in
            guard let `self` = self else { return }
            if let clickAction = clickAction {
                clickAction()
            } else {
                let topVC = self.topViewController
                if topVC is HPBBaseNavigationController {
                    _ = topVC as! HPBBaseNavigationController
                }
                _ = self.popViewController(animated: true)
            }
        }
        if self.isWhiteBar{
            leftButton.setImage(#imageLiteral(resourceName: "back_leftBtn_gray"), for: .normal)
        }else{
            leftButton.setImage(#imageLiteral(resourceName: "back_leftBtn_white"), for: .normal)
        }
        
        // 让按钮内部的所有内容左对齐
        leftButton.contentHorizontalAlignment = .left
        return UIBarButtonItem(customView: leftButton)
    }
    
}



//改变状态栏颜色导航
class HPBBaseStateBarNavigationController: HPBBaseNavigationController{

    //https://www.jianshu.com/p/4196d7cf95f4
    override var childViewControllerForStatusBarStyle: UIViewController?{
        return self.visibleViewController
    }
    
    override var childViewControllerForStatusBarHidden: UIViewController?{
        return self.visibleViewController
    }
    
}
