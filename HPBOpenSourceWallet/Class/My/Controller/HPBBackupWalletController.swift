//
//  HPBBackupWalletController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/11.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBBackupWalletController: HPBBaseController,HPBCustomPopProtocol {

    
    @IBOutlet weak var tipTitlelabel: UILabel!
    @IBOutlet weak var tipContentLabel: UILabel!
    @IBOutlet weak var confirmBtn: HPBSelectImgeButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var noBackupBtn: UIButton!
    
    
    var mnemonics: String?
    var walletAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocalizable()
        topConstraint.constant = (UIDevice.isRETIAN_4_0 || UIDevice.isRETIAN_3_5) ? 10 : 45
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    fileprivate func steupLocalizable(){
       noBackupBtn.setTitle("Mnemonics-No-Backup-Btn".localizable, for: .normal)
       tipTitlelabel.text = "bYw-MW-bpE.text".MainLocalizable
       let frontTextAttr = "OBg-kj-Ieu.text".MainLocalizable.attributeStrColor(UIColor.paNavigationColor)
       let behindTextAttr = "ULe-rx-oj3.normalTitle".MainLocalizable.attributeStrColor(UIColor.init(withRGBValue: 0x4A5FE2))
        let finishAttr = NSMutableAttributedString(attributedString: frontTextAttr)
        finishAttr.append(behindTextAttr)
        tipContentLabel.attributedText = finishAttr
        confirmBtn.setTitle("Mnemonics-backup-Btn".localizable, for: .normal)
    }
    
    @IBAction func courseBtnClick(_ sender: UIButton) {
        let webView =   HPBWebViewController()
        webView.url = HPBWebViewURL.backupCourse.webViewUrllocalizable
        webView.webTitle = "Mnemonics-Tutorial".localizable
        webView.animationNavgation = true
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    @IBAction func noBackupClick(_ sender: UIButton) {
        self.popTodestinationVC()
    }
}

extension HPBBackupWalletController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HPBMnemonicsController{
            let mnemonicsVC = segue.destination as! HPBMnemonicsController
            mnemonicsVC.mnemonics = self.mnemonics
             mnemonicsVC.walletAddress = self.walletAddress
        }
    }
}
