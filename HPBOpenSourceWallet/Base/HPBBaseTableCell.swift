//
//  HPBBaseTableCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/8.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import SnapKit


 enum HPBTableViewCellSeparatorLineStyle: Int{
    case none = 0
    case top
    case bottom
    case space
    case doubleSpace
    case topAndBottom
    case topAndBottomSpace
}

 enum HPBTableViewCellAccessoryStyle: Int{
    case none = 0
    case disclosureIndicator
}


struct HPBTableViewSpace{
    static let separatorLeft: CGFloat  = 15
    static let separatorRight: CGFloat = 15
    static let accessoryRight: CGFloat = 15
}

class HPBBaseTableCell: UITableViewCell {
    
    var separatorLineStyle: HPBTableViewCellSeparatorLineStyle = .none{
        didSet{
            separatorLineViewConfig()
        }
    }
    var accessoryStyle: HPBTableViewCellAccessoryStyle = .none{
        didSet{
            disclosureIndicatorView.isHidden = (accessoryStyle == .none)
        }
    }
    
    var accessoryRight: CGFloat = HPBTableViewSpace.accessoryRight{
        willSet{
            disclosureIndicatorView.snp.updateConstraints { (make) in
                make.right.equalToSuperview().offset(-newValue)
            }
        }
    }
    
    var separatorLineColor: UIColor = UIColor.paDividing{
        willSet{
            topSeparatorLineView.backgroundColor = newValue
            bottomSeparatorLineView.backgroundColor = newValue
        }
    }
    
    private var lineWidth: CGFloat = 0.5
    
    private var topSeparatorLineView:UIView = {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = UIColor.paDividing
        return view
    }()
    
    private var bottomSeparatorLineView:UIView = {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = UIColor.paDividing
        return view
    }()
    
    private var disclosureIndicatorView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "pa_rightArrow")
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initData()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initData()
    }
    
    func initData() {
        self.selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 1, width: self.frame.size.width, height: self.frame.size.height - 2))
        self.selectedBackgroundView?.backgroundColor = UIColor.hpbCellSelectColor
        self.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        contentView.addSubview(topSeparatorLineView)
        contentView.addSubview(disclosureIndicatorView)
        contentView.addSubview(bottomSeparatorLineView)
        topSeparatorLineView.isHidden = true
        bottomSeparatorLineView.isHidden = true
        
       disclosureIndicatorView.isHidden = (accessoryStyle == .none)
        if self.accessoryType == .disclosureIndicator{
            self.accessoryType = .none
            disclosureIndicatorView.isHidden = false
        }
        topSeparatorLineView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(lineWidth)
        }
        
        bottomSeparatorLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(lineWidth)
        }
        
        disclosureIndicatorView.snp.makeConstraints { (make) in
            make.width.equalTo(8)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-HPBTableViewSpace.accessoryRight)
        }
    }
}

extension HPBBaseTableCell{
    
    fileprivate func separatorLineViewConfig(){
        
        switch separatorLineStyle {
        case .none:
            topSeparatorLineView.isHidden = true
            bottomSeparatorLineView.isHidden = true
        case .top:
            topSeparatorLineView.isHidden = false
            bottomSeparatorLineView.isHidden = true
        case .bottom:
            topSeparatorLineView.isHidden = true
            bottomSeparatorLineView.isHidden = false
        case .topAndBottom:
            topSeparatorLineView.isHidden = false
            bottomSeparatorLineView.isHidden = false
        case .space:
            topSeparatorLineView.isHidden = true
            bottomSeparatorLineView.isHidden = false
            bottomSeparatorLineView.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(HPBTableViewSpace.separatorLeft)
            }
        case .doubleSpace:
            bottomSeparatorLineView.isHidden = false
            topSeparatorLineView.isHidden = true
            bottomSeparatorLineView.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(HPBTableViewSpace.separatorLeft)
                make.right.equalToSuperview().offset(-HPBTableViewSpace.separatorRight)
            }
            
        case .topAndBottomSpace:
            bottomSeparatorLineView.isHidden = false
            topSeparatorLineView.isHidden = false
            bottomSeparatorLineView.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(HPBTableViewSpace.separatorLeft)
            }
            topSeparatorLineView.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(HPBTableViewSpace.separatorLeft)
            }
        }
        self.layoutIfNeeded()
    }
}



class HPBBottomSeparatorCell: HPBBaseTableCell{
   override func initData() {
        super.initData()
         self.separatorLineStyle = .doubleSpace
    }
}
