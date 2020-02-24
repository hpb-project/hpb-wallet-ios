//
//  HPBQRCodeController.swift
//  LXLTest1
//
//  Created by 刘晓亮 on 2018/5/29.
//  Copyright © 2018年 朝夕网络. All rights reserved.
//

import UIKit
import LBXScan
import Photos


class HPBReceiptController: HPBBaseTableController {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var qrImgView: UIImageView!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var savebtn: UIButton!
    var myAddress: String = ""
    //是否安全提示(false显示)
    @IBOutlet weak var qrImageBackView: UIView!
    fileprivate lazy var showAlertFlag: Bool = {
        if let state =  UserDefaults.standard.object(forKey: HPBUserDefaultsKey.showSafeAlertKey) as? Bool{
            return state
        }
        return false
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Receipt-Title".localizable
        self.view.backgroundColor = UIColor.white
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowRadius = 20
        adressLabel.text = myAddress
        self.creatQRcode()
        steupLocalizable()
        configNavigationItem()
        //加载弹出框
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            if !self.showAlertFlag{
               HPBMainViewModel.showSafeAlert(vc: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    fileprivate func configNavigationItem(){
        let barButtonItem = HPBBarButton.init(image: #imageLiteral(resourceName: "main_receipt_share"))
        barButtonItem.clickBlock = {[weak self] in
            self?.rightItemClicked()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func rightItemClicked(){
        //收款需要定制界面，所以需要额外的信息
         HPBShareManager.shared.additionalInfo = myAddress
        HPBShareManager.shared.show(.receipt, currentController: self)
    }
    
    func steupLocalizable(){
        self.copyBtn.setTitle("Q7W-2P-pIx.normalTitle".MainLocalizable, for: .normal)
        savebtn.setTitle("Receipt-Save-Photo".localizable, for: .normal)
    }
}



extension HPBReceiptController{
    
    func creatQRcode(money: String? = "0"){
        qrImgView.image = myAddress.generatorQRCode(size: UIScreen.width - 120)
    }
    
    
    @IBAction func copyBtnClick(_ sender: UIButton) {

        sender.setTitle("Common-Copyed".localizable, for: .normal)
        sender.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            sender.isUserInteractionEnabled = true
            sender.setTitle("Q7W-2P-pIx.normalTitle".MainLocalizable, for: .normal)
        }
        let pasteboard = UIPasteboard.general
        pasteboard.string = myAddress
        showBriefMessage(message: "Common-Copy-Success".localizable, view: self.view)
        
    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        
         guard let receiptView = HPBViewUtil.instantiateViewWithBundeleName(HPBShareReceiptView.self, bundle: nil)as? HPBShareReceiptView else{return }
        receiptView.addressLabel.text = myAddress
        receiptView.codeImage.image = myAddress.generatorQRCode(size: UIScreen.width - 120)
        let shareImage = UIImage.getImageViewWithView(receiptView)
        if let image = shareImage{
            saveImage(image)
        }
    }
    
    
    fileprivate func saveImage(_ image: UIImage) {
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (isSuccess, error) in
            if isSuccess {
                DispatchQueue.main.async {
                    showBriefMessage(message: "Common-Save-Success".localizable,view: self.view)
                }
            } else {
                DispatchQueue.main.async {
                    //showBriefMessage(message: error?.localizedDescription,view: self.view)
                }
            }
            
        }
    }
        
}





