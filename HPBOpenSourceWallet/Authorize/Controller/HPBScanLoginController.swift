//
//  HPBScanLogoController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import SDWebImage

class HPBScanLoginController: UIViewController {

    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var scanResult: String?
    var model: HPBLoginReqModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "授权登录"
        configUI()
        configNavigationItem()
    }
    
    fileprivate func configNavigationItem(){
        let imageName = UIImage(named: "back_leftBtn_white")
        let barButtonItem = HPBBarButton.init(image: imageName)
        barButtonItem.clickBlock = {[weak self] in
             self?.navigationController?.popToRootViewController(animated: true)
        }
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupStyleByNavigation(self.navigationController)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
   fileprivate func configUI(){
        let jsonStr = scanResult.noneNull.replacingOccurrences(of: "https://www.hpb.io/client?login=", with: "")
        guard let model = HPBLoginReqModel(JSONString: jsonStr) else{return}
        self.model = model
        logoImage.sd_setImage(with: URL(string: model.dappIcon), placeholderImage: #imageLiteral(resourceName: "bannerPlaceholder"))
        decLabel.text = model.loginMemo
        titleLabel.text = model.dappName
        centerLabel.text = "即将登录\(model.dappName)，请确认是本人操作"
    }
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        guard let model = self.model else{return}
        HPBAlertView.showPasswordAlert(in: self) {
            guard let password = $0 else {return}
            let timestamp = "\(Int(Date().timeIntervalSince1970))"
            let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
            HPBSignerManager.signLoginMsg(password, timestamp: timestamp, uuID: model.uuID, currentAddress: currentAddress, success: { (signagure) in
                //发送数据到登录的url
                let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
                let signLoginModel = HPBLoginRespModel(model: model, sign: signagure, account: currentAddress.noneNull,timestamp: timestamp)
                let jsonStr = signLoginModel.toJSON()
                debugLog(jsonStr)
                
            }, failure: { (errorMsg) in
                showBriefMessage(message: errorMsg ,view: self.view)
            })
        }
       
        
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    

}
