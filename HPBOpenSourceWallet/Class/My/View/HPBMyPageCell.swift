//
//  HPBMyPageCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/8.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBMyPageCell: HPBBaseTableCell {

  
    struct HPBMyPageModel{
        var title: String = ""
        var image: UIImage? = nil
        var leftConstraint: CGFloat = 44
        var rightConstraint: CGFloat = 44
        var isHavaBottom: Bool = false
        var noSpace: Bool = false
        var isHiddenRed: Bool = true
        var rightText: String? = ""
        
        init(title: String, image: UIImage? = nil,leftConstraint: CGFloat = 26,rightConstraint: CGFloat = 22,isHavaBottom: Bool = false,noSpace: Bool = false,rightText: String? = ""){
            self.title = title
            self.image = image
            self.leftConstraint = leftConstraint
            self.isHavaBottom = isHavaBottom
            self.rightConstraint = rightConstraint
            self.rightText = rightText
            self.noSpace = noSpace
        }
        
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var readView: UIView!
    lazy var rightLabel: HPBLabel = {
      let label = HPBLabel(titleColor: UIColor.hpbInputColor, fontValue: 14, alignment: .right)
        return label
    }()
    var model: HPBMyPageModel?{
        willSet{
            guard let `newValue` = newValue else{return}
            nameLabel.text = newValue.title
            leftImage.image = newValue.image
            self.leftConstraint.constant = newValue.leftConstraint
            self.accessoryRight = newValue.rightConstraint
            self.readView.isHidden = newValue.isHiddenRed
            if newValue.isHavaBottom{
                if newValue.noSpace{
                    self.separatorLineStyle = .bottom
                    self.separatorLineColor = UIColor.paBackground
                }else{
                    self.separatorLineStyle = .doubleSpace
                }
            }else{
                self.separatorLineStyle = .none
            }
            //右边显示的label
            self.rightLabel.text = newValue.rightText
        }
    }
    
    static func cellModel(_ height: CGFloat = 50) -> HPBCellModel{
       return HPBCellModel(identifier: String(describing: HPBMyPageCell.self), height: height)
    }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-36)
        }
        readView.layer.cornerRadius = 4
        self.accessoryStyle = .disclosureIndicator
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
