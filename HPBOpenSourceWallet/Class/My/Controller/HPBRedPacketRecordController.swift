//
//  HPBRedPacketRecordController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/14.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRedPacketRecordController: HPBBaseController {

    
    enum HPBMyRedPacketType: String {
        case send        = "News-RedPacket-Record-Sent"
        case receive     = "News-RedPacket-Record-Received"
    }
    
    lazy var switchViews: [UIView] = {
        return getSwitchViews()
    }()
    
    var types: [HPBMyRedPacketType] = [.send,.receive]
    
    fileprivate var slideSwitchView: CKSlideSwitchView = {
        var slideView = CKSlideSwitchView(frame: CGRect(x:0, y:0, width:UIScreen.width, height:UIScreen.height-UIScreen.navigationHeight))
        slideView.tabItemTitleNormalColor = UIColor.hpbPurpleColor
        slideView.tabItemTitleSelectedColor = UIColor.hpbBtnSelectColor
        slideView.topScrollViewBackgroundColor = UIColor.white
        slideView.tabItemShadowColor = UIColor.hpbBtnSelectColor
        slideView.backgroundColor = UIColor.white
        return slideView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News-RedPacket-Record".localizable
        steupSwitchView()
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
    
        let sendBackView = UIView()
        let sendVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBRedPacketListController.self)) as!  HPBRedPacketListController
        addChildViewController(sendVC)
        sendBackView.addSubview(sendVC.view)
        sendVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        sendVC.type = .send
        sendVC.sendSelectBlock = { [weak self] in
            debugLog($0)
            let sendDetileVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBRPSendDetailController.self)) as!  HPBRPSendDetailController
            sendDetileVC.sendModel = $0
            self?.navigationController?.pushViewController(sendDetileVC, animated: true)
            
        }
        
         let receiveBackView = UIView()
        let receiveVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBRedPacketListController.self)) as!  HPBRedPacketListController
        addChildViewController(receiveVC)
        receiveBackView.addSubview(receiveVC.view)
        receiveVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
         receiveVC.type = .receive
        receiveVC.receiveSelectBlock = { [weak self] in
            let receiveDetileVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBRPReceiveDetailController.self)) as!  HPBRPReceiveDetailController
             receiveDetileVC.model = $0
            self?.navigationController?.pushViewController(receiveDetileVC, animated: true)
        }
        return [sendBackView,receiveBackView]
        
    }

}


extension HPBRedPacketRecordController: CKSlideSwitchViewDelegate{
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightForTabItemForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 48
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, numberOfTabItemsForTopScrollView topScrollView: UIScrollView) -> Int {
        return types.count
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, titleForTabItemForTopScrollViewAt index: Int) -> String? {
        
        return types[index].rawValue.localizable
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView? {
        let contentView = switchViews[index]
        contentView.tag  = index
        return contentView
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemWidthForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return self.view.frame.width / CGFloat(types.count)
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightOfShadowImageForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 3
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemFontSizeForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 15.0
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, currentIndex index: Int){
        let type =  types[index]
        switch type {
        case .send:
            break
        case .receive:
            break
        }
        
    }
    
}

