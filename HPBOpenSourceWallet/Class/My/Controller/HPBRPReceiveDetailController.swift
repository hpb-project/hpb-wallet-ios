//
//  HPBRedPacketDetailController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/17.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBRPReceiveDetailController: HPBBaseTableController {
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var bottomlabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    var model: HPBRedPacketReceiveModel?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News-RedPacket-Detail".localizable
        steupViews()
        steupTableView()
        
    }
    func steupTableView(){
        self.tableView.backgroundColor = UIColor.init(withRGBValue: 0xFCFCFC)
        headerView.frame = CGRect(x:0, y: 0, width: UIScreen.width, height: UIScreen.scaleFontIphone6(336))
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        topView.backgroundColor = UIColor.paNavigationColor
        tableView.tableHeaderView = topView
        tableView.contentInset = UIEdgeInsets(top: -UIScreen.height, left: 0, bottom: 0, right: 0)
    }

    func  steupViews(){
        guard let `model` = model else {
            return
        }
        var typeImageName = ""
        if model.type == "1"{
            typeImageName = "redpacket_white_pu"
        }else{
            typeImageName = "redpacket_white_pin"
        }
        if HPBLanguageUtil.share.language == .english{
           typeImageName.append("_en")
        }
        typeImage.image = UIImage(named: typeImageName)
        self.tipLabel.text = model.title
        var locationStr = model.fromAddr.cutOutAddress() + "的HPB红包"
        if HPBLanguageUtil.share.language == .english{
          locationStr = "Red Packet from " + model.fromAddr.cutOutAddress()
        }
        self.topTitleLabel.text = locationStr
         let coinStr = HPBStringUtil.converHpbMoneyFormat(model.coinValue, 4).noneNull
        self.moneyLabel.text = coinStr
        self.bottomlabel.text = "News-RedPacket-Transfer-In".localizable + model.toAddr.cutOutAddress()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UIScreen.scaleFontIphone6(336)
    }

  

}
