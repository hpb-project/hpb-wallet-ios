//
//  HPBDividendVoteCell.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/18.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBDividendVoteCell: UITableViewCell {
    enum HPBVoteCellType {
        case normal,query
    }
    static let cellModel = HPBCellModel(identifier: String(describing: HPBDividendVoteCell.self), height: 45)
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var voteNumberLabel: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var dividendImage: UIImageView!
    @IBOutlet weak var dividendLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    var voteBlock: (() -> Void)?
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
    
    ///设置分红的调用
    func setDividendState(_ showType: HPBVoteModel.HPBVoteDidendType, _ present: String){
        
        
        switch showType {
        case .noSet:
            self.dividendImage.isHidden = true
            self.dividendLabel.isHidden = false
            self.dividendLabel.text = "Common-Unset".localizable
        case .noEnouth:
            self.dividendImage.isHidden = false
            self.dividendLabel.isHidden = true
        case .showRate:
            self.dividendImage.isHidden = true
            self.dividendLabel.isHidden = false
            self.dividendLabel.text = present + "%"
        }
    }
    
    
    @IBAction func voteBtnClick(_ sender: UIButton) {
        voteBlock?()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
