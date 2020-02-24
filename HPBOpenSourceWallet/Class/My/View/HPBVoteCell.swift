//
//  HPBVoteCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/8/1.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBVoteCell: UITableViewCell {

    enum HPBVoteCellType {
        case normal,query
    }
    static let cellModel = HPBCellModel(identifier: String(describing: HPBVoteCell.self), height: 45)
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var voteNumberLabel: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var rankLabel: UILabel!
    var voteBlock: (() -> Void)?
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        voteBtn.setTitle("Vote-Vote-Btn".localizable, for: .normal)
        
    }
    func configData(name: String,number: String?,row: Int = 0,rank: String? = nil,type: HPBVoteCellType = .normal){
        nameLabel.text = name
        voteNumberLabel.text = number
        if row < 4 && type == .normal{
            rankLabel.isHidden = true
             leftImage.isHidden = false
            leftImage.image = UIImage(named: "my_vote_rank\(row)")
        }else{
            rankLabel.isHidden = false
            leftImage.isHidden = true
            rankLabel.text = "\(row)"
        }
        let singelColor = UIColor.init(withRGBValue: 0xFCFCFC)
        let doubleColor = UIColor.init(withRGBValue: 0xF9FAFF)
        let isSignal =  row % 2 == 1
        if type == .query{
            rankLabel.text = rank
            self.contentView.backgroundColor = isSignal ? singelColor : doubleColor
        }
        self.backView.backgroundColor = isSignal ? singelColor : doubleColor
       
    }
    
    
    @IBAction func voteBtnClick(_ sender: UIButton) {
        voteBlock?()
    }

    
}
