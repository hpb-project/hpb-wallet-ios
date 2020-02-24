//
//  HPBConfirmMnemoCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/11.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit
import SnapKit
class HPBConfirmMnemoCell: HPBBaseTableCell {

    static let cellModel = HPBCellModel(identifier: String(describing: HPBConfirmMnemoCell.self),height: 667)
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var confirmTitleLabel: UILabel!
    let originalBtnFirstTag = 401
    let selectBtnFirstTag   = 301
    
    

    //先前的助记词数组
    var originalMnemos: [String] = []{
        didSet{
            //为保持正确性更高，判断是否能生成12个单词的助记词字符串
            guard originalMnemos.count == 12 else{ return}
            //数组乱序
            originalMnemos.sort(){_,_ in
               return arc4random() % 2 > 0
            }
            for index in 0..<12{
                if let button = self.viewWithTag(originalBtnFirstTag+index) as? UIButton{
                    button.setTitle(originalMnemos[index], for: .normal)
                }
            }
        }
    }
    
    //选中的助记词数组
    var selectMnemos: [String] = []
    //记录选中原始助记词组的tag
    lazy var selectOriginalTags: [Int]  = []
    var confirmBlock: ((String)-> Void)?
    
}

extension HPBConfirmMnemoCell{
   
    @IBAction func confirmBtnClick(_ sender: UIButton) {
        if selectMnemos.count < 12{
            return
        }
        var mnemoStr = selectMnemos.reduce("") {
            return $0 + " " + $1
        }
        mnemoStr.removeFirst(1)
        confirmBlock?(mnemoStr)
    }
    
    
    @IBAction func originalBtnClick(_ sender: UIButton) {
        //拼接选中的助记词
        selectMnemos.append(originalMnemos[sender.tag - originalBtnFirstTag])
        selectOriginalTags.append(sender.tag)
        reloadSelectBtns()
        reloadOriginalBtns()
        showConfirmBtnState()
    }
    
    @IBAction func selectBtnClick(_ sender: UIButton) {
     
        //删除选中的助记词
        selectMnemos.remove(at: sender.tag - selectBtnFirstTag)
        selectOriginalTags.remove(at: sender.tag - selectBtnFirstTag)
        reloadSelectBtns()
        reloadOriginalBtns()
        showConfirmBtnState()
    }
    
   fileprivate func showConfirmBtnState(){
        if selectMnemos.count == 12{
            self.confirmBtn.isSelected = true
        }else{
            self.confirmBtn.isSelected = false
        }
    }
    
    
    func reloadSelectBtns(){
        for index in 0..<12{
            guard let button = self.viewWithTag(selectBtnFirstTag+index) as? UIButton else{return}
            //已经选择的
            if index < selectMnemos.count{
                button.isHidden = false
                button.setTitle(selectMnemos[index], for: .normal)
            }else{
                button.isHidden = true
            }
        }
    }
    
    func reloadOriginalBtns(){
        for index in 0..<12{
            let currentTag = originalBtnFirstTag+index
            guard let button = self.viewWithTag(currentTag) as? UIButton else{return}
            button.setTitle(originalMnemos[index], for: .normal)
            button.isHidden = false
            if selectOriginalTags.contains(currentTag){
                button.isHidden = true
            }
        }
    }
    
}

extension HPBConfirmMnemoCell{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.paBackground
        confirmTitleLabel.text = "DV6-qK-IIG.text".MainLocalizable
        promptLabel.text = "t9v-Wk-nQW.text".MainLocalizable
        confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
    }
    
}
