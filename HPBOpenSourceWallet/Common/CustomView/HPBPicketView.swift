//
//  HPBSelectAddressView.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/6/18.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import RealmSwift

class HPBPicketView: UIView {

    enum HPBPickerViewType{
        case leftAndRight
        case singleLine
        case topAndBottom
    }
    var pickerViewType: HPBPickerViewType = .leftAndRight
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var confirmBtn: HPBSelectImgeButton!
    var topTitle: String = ""{
        willSet{
          titleLabel.text =  newValue
        }
    }
    var recordRow: Int?
    
    /// 如果存在就直接选中,如果不存在就选中第一个
    var selectDataSourceStr: String = ""
    ///返回的是"\(row)”
    var selectBlock: ((String) -> Void)?
    var dataSources: [(String,String)] = []
    
    
   
    
    
     var leftAndRightView: UIView {
        let reusingView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.width - 20, height: 40))
        reusingView.backgroundColor = UIColor.white
        let leftLabel = HPBLabel(backgroundColor: UIColor.clear, titleColor: UIColor.black, fontValue: 15)
        leftLabel.tag = 100000
        leftLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.minimumScaleFactor = 0.5
        let rightLabel = HPBLabel(backgroundColor: UIColor.clear, titleColor: UIColor.black, fontValue: 15, alignment: .left)
        rightLabel.lineBreakMode = .byTruncatingMiddle
        rightLabel.frame = CGRect(x: 110, y: 0, width: UIScreen.width - 20 - 10 - 100, height: 40)
        rightLabel.tag = 100001
        reusingView.addSubview(leftLabel)
        reusingView.addSubview(rightLabel)
        return reusingView
    }
    
     var centerView: UIView{
        let reusingView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.width - 20, height: 40))
        reusingView.backgroundColor = UIColor.white
        let centerLabel = HPBLabel(backgroundColor: UIColor.clear, titleColor: UIColor.black, fontValue: 15)
        centerLabel.tag = 100002
        centerLabel.textAlignment = .center
        centerLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.width - 20, height: 40)
        centerLabel.adjustsFontSizeToFitWidth = true
        centerLabel.minimumScaleFactor = 0.5
        reusingView.addSubview(centerLabel)
        return reusingView
    }
    
    var topAndBottomView: UIView{
        let reusingView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.width - 20, height: 40))
        reusingView.backgroundColor = UIColor.white
        let topLabel = HPBLabel(backgroundColor: UIColor.clear, titleColor: UIColor.black, fontValue: 16)
        topLabel.tag = 100003
        topLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.width - 20, height: 20)
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.minimumScaleFactor = 0.5
        topLabel.textAlignment = .center
        let bottomLabel = HPBLabel(backgroundColor: UIColor.clear, titleColor: UIColor.init(withRGBValue: 0xBABDC1), fontValue: 14, alignment: .left)
        bottomLabel.lineBreakMode = .byTruncatingMiddle
        bottomLabel.frame = CGRect(x: 0, y: 22, width: UIScreen.width - 20, height: 17)
        bottomLabel.tag = 100004
        bottomLabel.textAlignment = .center
        reusingView.addSubview(topLabel)
        reusingView.addSubview(bottomLabel)
        return reusingView
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        cancelBtn.setTitle("Common-Cancel".localizable, for: .normal)
        confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        topView.addGestureRecognizer(gesture)
        configInitLayout()
        
    }
    
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        tapDismiss()
    }
    
    @IBAction func confirmClick(_ sender: HPBButton) {
        if let row = self.recordRow{
            tapDismiss()
            switch pickerViewType{
            case .leftAndRight:
                selectBlock?(dataSources[row].1)
            case .singleLine:
                 selectBlock?("\(row)")
            case .topAndBottom:
                 selectBlock?("\(row)")
            }
        }else{
            switch pickerViewType{
            case .leftAndRight:
                showBriefMessage(message: "News-RedPacket-Receive-Select-Tip".localizable)
            case .singleLine:
                showBriefMessage(message: "Transfer-Coin-Type-Empty-Tip".localizable)
            case .topAndBottom:
                showBriefMessage(message: "Transfer-Coin-Select-Empty-Tip".localizable)
            }
        }
        
       
    }
    
    
    func initSelectRow(){
        if !dataSources.isEmpty{
            // 没有找到的话就选择第一行
             self.pickerView.selectRow(0, inComponent: 0, animated: false)
             self.recordRow = 0
            if selectDataSourceStr.isEmpty{
                return
            }
            for (index,data) in dataSources.enumerated(){
                if data.0 == selectDataSourceStr{
                    self.pickerView.selectRow(index, inComponent: 0, animated: false)
                    self.recordRow = index
                    return
                }
            }
        }
    }
    
    func configInitLayout(){
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        bottomConstraint.constant = -360
        self.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25) {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.bottomConstraint.constant = 0
                self.layoutIfNeeded()
            }
        }
    }

    
    @objc func tapDismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.bottomConstraint.constant = -360
            self.layoutIfNeeded()
        }) {(state) in
            self.removeFromSuperview()
        }
    }
}

extension HPBPicketView: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSources.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 40
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.recordRow = row
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var reusingView = view
        if reusingView == nil{
            switch pickerViewType{
            case .leftAndRight:
                reusingView = leftAndRightView
            case .singleLine:
                reusingView = centerView
            case .topAndBottom:
                reusingView = topAndBottomView
                
            }
        }
        
        switch pickerViewType{
        case .leftAndRight:
            (reusingView?.viewWithTag(100000) as? UILabel)?.text = dataSources[row].0
            (reusingView?.viewWithTag(100001) as? UILabel)?.text = dataSources[row].1
        case .singleLine:
            (reusingView?.viewWithTag(100002) as? UILabel)?.text = dataSources[row].0
        case .topAndBottom:
             (reusingView?.viewWithTag(100003) as? UILabel)?.text = dataSources[row].0
            (reusingView?.viewWithTag(100004) as? UILabel)?.text = dataSources[row].1
            break
        }

         //在该代理方法里添加以下两行代码删掉上下的黑线
        if  pickerView.subviews.count >= 3{
            pickerView.subviews[1].isHidden = true
            pickerView.subviews[2].isHidden = true

        }
        return reusingView ?? UIView()
    }

}
