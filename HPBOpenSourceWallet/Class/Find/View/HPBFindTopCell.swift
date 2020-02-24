//
//  HPBFindTopCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/25.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBFindTopCell: UITableViewCell {

    enum HPBSelectType: String{
        case redPacket = "News-Top-RedPacket"
        case governance = "News-Top-Governance"
    }
    
    
    static let cellModel = HPBCellModel(identifier: String(describing: HPBFindTopCell.self), height: 176)

    
    var selectType: ((HPBSelectType)-> Void)?
    

    @IBOutlet weak var redPacketLabel: UILabel!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var governanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        topTitle.text = "TabBar-News.title".localizable
        redPacketLabel.text = HPBSelectType.redPacket.rawValue.localizable
        governanceLabel.text = HPBSelectType.governance.rawValue.localizable
    }

    @IBAction func redPacketClick(_ sender: UIButton) {
        
        selectType?(.redPacket)
    }

    @IBAction func governanceBtnClick(_ sender: Any) {
        selectType?(.governance)
    }
   
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
