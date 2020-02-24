//
//  HPBAdController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/5.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import SDWebImage
class HPBAdController: HPBBaseController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var jumpBtn: UIButton!
    
    var timer: Timer?
    var skipFlag: Bool = true
    var pushBlock: (()->Void)?
    var  countDownNumber: Int = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        jumpBtn.layer.cornerRadius = 15
        
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownHandel), userInfo: nil, repeats: true)
        timer?.fire()
        //加载图片
        self.imageView.image  = HPBAdManager.share.adImage
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(judgeToDestation))
        self.imageView.addGestureRecognizer(tapgesture)
    }
    
    @objc func countdownHandel(){
        countDownNumber -= 1
        if countDownNumber < 0{
           enterAnimation()
        }else{
          jumpBtn.setTitle("\("Guide-skip".localizable) \(countDownNumber)", for: .normal)
        }
        
    }

    @IBAction func jumpBtnClick(_ sender: UIButton) {
        enterAnimation()
    }
    
    
    @objc func judgeToDestation(){
       enterAnimation()
       pushBlock?()
    }
    
    @objc func enterAnimation(){
        timer?.invalidate()
        self.view.alpha = 1
        var animationTime: TimeInterval = 0.5
        var pageAlpha: CGFloat = 0
        if HPBLockManager.shared.secureLoginState{    //防止先出现内容页,再出现锁屏页面
            animationTime = 0
            pageAlpha = 1
        }
        UIView.animate(withDuration: animationTime, animations: {
            self.view.alpha = pageAlpha
        }) { (flag) in
            AppDelegate.shared.unlockAccount{               //解锁界面,成功后显示广告页
                self.view.removeFromSuperview()
            }
            
        }
    }
    
    deinit {
        print("HPBAdController释放了")
    }
    
   
}


extension HPBAdController{
    
    /*
    func getLaunchImage() -> UIImage? {
        let viewOr = "Portrait"//垂直
        var launchImageName = ""
        let viewSize        = UIScreen.main.bounds.size
        let tmpLaunchImages = Bundle.main.infoDictionary!["UILaunchImages"] as? [Any]
        for dict in tmpLaunchImages! {
            if let someDict = dict as? [String: Any] {
                let imageSize = CGSizeFromString(someDict["UILaunchImageSize"] as! String)
                if __CGSizeEqualToSize(viewSize, imageSize) && viewOr == someDict["UILaunchImageOrientation"] as! String {
                    launchImageName = someDict["UILaunchImageName"] as! String
                }
            }
        }
        let launchImage = UIImage(named: launchImageName)
        return launchImage
    }
 */
}
