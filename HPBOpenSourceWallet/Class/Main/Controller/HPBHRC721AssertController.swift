//
//  HPBHRC721AssertController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBHRC721AssertController: UIViewController {

    enum HPBHRC721Assert: String {
        case inventory        = "Transfer-Token-Inventory"
        case record     = "Transfer-Token-Transfer"
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    
    lazy var switchViews: [UIView] = {
        return getSwitchViews()
    }()
    
    var selectTypes: [HPBHRC721Assert] = [.inventory,.record]
    @IBOutlet weak var transferBtn: UIButton!
    @IBOutlet weak var receiptBtn: UIButton!
    @IBOutlet weak var tokenNumberLabel: UILabel!
    @IBOutlet weak var tokenMoneylabel: UILabel!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var rightTopImage: UIImageView!
    var model: HPBTokenManagerModel?
    
    fileprivate var slideSwitchView: CKSlideSwitchView = {
        var slideView = CKSlideSwitchView(frame: CGRect(x:0, y:182, width:UIScreen.width, height:UIScreen.height-UIScreen.navigationHeight - 182))
        slideView.tabItemTitleNormalColor = UIColor.hpbSwitchTabNormalColor
        slideView.tabItemTitleSelectedColor = UIColor.hpbSwitchTabSelectColor
        slideView.topScrollViewBackgroundColor = UIColor.white
        slideView.tabItemShadowColor = UIColor.hpbBtnSelectColor
        slideView.backgroundColor = UIColor.white
        return slideView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocation()
        steupViews()
        steupSwitchView()
        if let gesutres = navigationController?.view.gestureRecognizers{
            for gesture in gesutres{
                if gesture is UIScreenEdgePanGestureRecognizer{
                    slideSwitchView.rootScrollView.panGestureRecognizer.require(toFail: gesture)
                }
            }
        }
    }
    
    
    func steupViews(){
        guard let newValue = model else {
            return
        }
        tokenMoneylabel.isHidden = newValue.cnyPrice.isEmpty
        let showBalance = HPBMoneyStyleUtil.share.showFormatMoney(newValue.cnyTotalValue, newValue.usdTotalValue)
        tokenMoneylabel.text = showBalance
        tokenNumberLabel.text = newValue.balanceOfToken + " " + newValue.tokenSymbol
       
        switch newValue.type {
        case .hrc20:
            rightTopImage.image = UIImage(named: "main_assert_HRC_20")
        case .hrc721:
            rightTopImage.image = UIImage(named: "main_assert_HRC_721")
        case .mainNet:
            rightTopImage.image = nil
        }
        if let imageURL = URL(string: newValue.tokenSymbolImageUrl){
            tokenImage.sd_setImage(with:imageURL, placeholderImage: UIImage.init(named: "common_head_placehoder"))
        }else{
            tokenImage.image = UIImage.init(named: "common_head_placehoder")
        }
    }
    
    func steupLocation(){
        self.title = HPBStringUtil.noneNull(self.model?.tokenSymbol) + " " + "TabBar-Main.title".localizable
        receiptBtn.setTitle("  " + "Main-Receipt".localizable, for: .normal)
        transferBtn.setTitle("  " + "Main-Transfer".localizable, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupWhiteStyleByNavigation(self.navigationController)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    @IBAction func transferClick(_ sender: UIButton) {
        let isBackup = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.mnemonics).isEmpty
        if isBackup{
            let transferVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBTransferController")
            (transferVC as? HPBTransferController)?.initTokenType = .HRC721
            (transferVC as? HPBTransferController)?.remandToken = model?.balanceOfToken
            (transferVC as? HPBTransferController)?.recordTokenName = HPBStringUtil.noneNull(model?.tokenSymbol)
            (transferVC as? HPBTransferController)?.hrcContractAddress = model?.contractAddress
            (transferVC as? HPBTransferController)?.recordTokenDecimals = 0
            self.navigationController?.pushViewController(transferVC, animated: true)
        }else{
            self.showTipBackUpView()
        }
    }
    @IBAction func receiptBtnClick(_ sender: UIButton) {
        
        let isBackup = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.mnemonics).isEmpty
        if isBackup{
            let receiptVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBReceiptController") as! HPBReceiptController
            receiptVC.myAddress = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.addressStr)
            self.navigationController?.pushViewController(receiptVC, animated: true)
        }else{
            self.showTipBackUpView()
        }
        
    }
    
    /// 显示备份弹框
    private func showTipBackUpView(){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        HPBMainViewModel.showTipBackUpView(controller: self) {[weak self] in
            
            let destinationVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBWalletHandelController.self))
            (destinationVC as! HPBWalletHandelController).from = .other
            (destinationVC as! HPBWalletHandelController).addressStr = HPBStringUtil.noneNull(HPBUserMannager.shared.currentWalletInfo?.addressStr)
            
            self?.navigationController?.pushViewController(destinationVC, animated: true)
            self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    
    fileprivate func steupSwitchView(){
        view.addSubview(slideSwitchView)
        slideSwitchView.slideSwitchViewDelegate = self
        slideSwitchView.reloadData()
    }
    

    
     fileprivate func getSwitchViews() -> [UIView]{
        let inventoryView = UIView()
        let inventoryVC = HPBHRC721InventoryController()
        inventoryVC.contractAddress = HPBStringUtil.noneNull(model?.contractAddress)
        inventoryVC.selectBlock = {[weak self] in
            let iDetailVC = HPBControllerUtil.instantiateControllerWithIdentifier("HPBHRC721IDDetailController") as! HPBHRC721IDDetailController
            iDetailVC.transferTimes = "\($0)"
            iDetailVC.tokenSymbol = HPBStringUtil.noneNull(self?.model?.tokenSymbol)
            iDetailVC.balanceOfToken = HPBStringUtil.noneNull(self?.model?.balanceOfToken)
            iDetailVC.tokenID = $1
            iDetailVC.contractAdd = self?.model?.contractAddress
            self?.navigationController?.pushViewController(iDetailVC, animated: true)
        }
        addChildViewController(inventoryVC)
        inventoryView.addSubview(inventoryVC.view)
        inventoryVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }

       
        let recordView = UIView()
        let recordVC = HPBHRC721RecordController()
        recordVC.model = self.model
        addChildViewController(recordVC)
        recordView.addSubview(recordVC.view)
        recordVC.selectBlock = { [weak self] in
            let detailVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBTransferDetailController.self)) as!  HPBTransferDetailController
            detailVC.assertType = .hrc721
            detailVC.recordModel = $0
           self?.navigationController?.pushViewController(detailVC, animated: true)
            
        }
        recordVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        return [inventoryView,recordView]
    }

}



extension HPBHRC721AssertController: CKSlideSwitchViewDelegate{
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightForTabItemForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 48
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, numberOfTabItemsForTopScrollView topScrollView: UIScrollView) -> Int {
        return selectTypes.count
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, titleForTabItemForTopScrollViewAt index: Int) -> String? {
        
        return selectTypes[index].rawValue.localizable
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView? {
        let contentView = switchViews[index]
        contentView.tag  = index
        return contentView
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemWidthForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return self.view.frame.width / CGFloat(selectTypes.count)
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, heightOfShadowImageForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 2
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemFontSizeForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 15.0
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, currentIndex index: Int){
        let type =  selectTypes[index]
        switch type {
        case .inventory:
            break
        case .record:
            break
        }
        
    }
    
}

