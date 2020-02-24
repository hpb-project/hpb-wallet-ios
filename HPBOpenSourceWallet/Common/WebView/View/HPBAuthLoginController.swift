//
//  HPBAuthLoginController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/7.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBAuthLoginController: UIViewController {
    
    struct HPBConfirmModel{
        var fromAdd  : String = ""
        var content  : String = ""
        var dappName  : String = ""
        var dappIcon  : String = ""
        
        init( _ fromAdd: String,_ content: String,_ dappName: String,_ dappIcon: String){
            self.fromAdd = fromAdd
            self.content = content
            self.dappName = dappName
            self.dappIcon = dappIcon
        }
    }
    
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var authAddressTitleLabel: UILabel!
    @IBOutlet weak var confirmBtn: HPBSelectImgeButton!
    @IBOutlet weak var dappIconImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dappNameContentLabel: UILabel!
    //@IBOutlet weak var dappAuthContentLabel: UILabel!
    @IBOutlet weak var walletAddContentLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    
    let bottomHeight: CGFloat = 318 + UIScreen.tabbarSafeBottomMargin
    var closeBlock: (()-> Void)?
    var confirmBlock: (()-> Void)?

    var model: HPBConfirmModel?{
        didSet{
            guard  let `model` = model else {
                return
            }
            dappNameContentLabel.text = model.dappName
            //dappAuthContentLabel.text = model.content
            walletAddContentLabel.text = model.fromAdd
            dappIconImage.sd_setImage(with: URL(string: model.dappIcon), placeholderImage:  #imageLiteral(resourceName: "bannerPlaceholder"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupLocationable()
        showAnimation()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeBtnClick))
        topView.addGestureRecognizer(gesture)
    }
    
    private func steupLocationable(){
        topTitleLabel.text = "Common-Auth-Login-Title".localizable
        authAddressTitleLabel.text = "Common-Auth-Address-Title".localizable
        confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
    }


    private func showAnimation(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        bottomConstraint.constant = -bottomHeight
        btnBottomConstraint.constant = UIScreen.tabbarSafeBottomMargin + 25
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
   
    func hideAnimation(finish: (()-> Void)?){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint.constant = -self.bottomHeight
            self.view.layoutIfNeeded()
        }) {(state) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            finish?()
        }
    }
    
    deinit {
        debugLog("释放了")
    }
    
    
    @IBAction func confirmBtnClick(_ sender: UIButton) {
         confirmBlock?()
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        hideAnimation {
            self.closeBlock?()
        }
    }
    
    

}
