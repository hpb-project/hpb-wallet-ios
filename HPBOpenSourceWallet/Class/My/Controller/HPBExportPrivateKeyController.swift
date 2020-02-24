//
//  HPBExportPrivateKeyController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/12.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBExportPrivateKeyController: HPBBaseController {

    
    @IBOutlet weak var copyBtn: HPBBackImgeButton!
    @IBOutlet weak var promptBackView: UIView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    var privateKeyStr: String?
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocalizable()
        self.view.backgroundColor = UIColor.white
        privateKeyLabel.text = privateKeyStr
        HPBExportViewModel.showAlert(vc: self, content: "CommonAlert-Export-PrivateKey".localizable)
    }

    private func  steupLocalizable(){
       
        self.title = "WalletHandel-Export-PK".localizable
        promptLabel.text = "ExportPrivateKey-Prompt-New".localizable
        copyBtn.setTitle("ExportPrivateKey-Copy".localizable, for: .normal)
        
    }

    
    @IBAction func copyPrivateKeyClick(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = privateKeyStr
        sender.setTitle("Common-Copyed".localizable, for: .normal)
        sender.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            sender.isUserInteractionEnabled = true
            sender.setTitle("ExportPrivateKey-Copy".localizable, for: .normal)
        }
        showBriefMessage(message: "Common-Copy-Success".localizable, view: self.view)
        
    }
    


}
