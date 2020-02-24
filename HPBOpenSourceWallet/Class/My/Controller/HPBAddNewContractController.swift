//
//  HPBAddNewContractController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/17.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class HPBAddNewContractController: HPBBaseTableController {

    
    enum HPBHandelType: String{
        case edit = "AddressBook-Edit"
        case add  = "AddressBook-AddNew"
    }
    
    enum HPBSourceFrom{
        case normal, scan
    }
   
    var sourceFrom: HPBSourceFrom = .normal
    var handeType: HPBHandelType = .add
    var addBookmodel: HPBAddressBookRealmModel?
    var scanAddress: String?
    var openState: Bool{
        return  HPBiCouldManager.getiCouldState()
    }
    @IBOutlet weak var textView: HPBTextView!
    @IBOutlet weak var confirmBtn: HPBSelectImgeButton!
    @IBOutlet weak var delet4eBtn: UIButton!
    @IBOutlet weak var nameTextField: HPBTextField!
    @IBOutlet weak var textBumberLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = handeType.rawValue.localizable
        self.textView.content = scanAddress
        nameTextField.delegate = self
          NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nameTextField)
        if handeType == .add{
            self.delet4eBtn.isHidden = true
        }else{
            if let model = addBookmodel{
                self.nameTextField.text = model.contractName
                self.textView.content = model.addressStr
                self.textBumberLabel.text = "\(20 - nameTextField.text.noneNull.count)"
            }
        }
        steupLocation()
    }
    
    
    func  steupLocation(){
     textView.placehoder = "AddressBook-textView-Placehoder".localizable
     confirmBtn.setTitle("Common-Confirm".localizable, for: .normal)
        delet4eBtn.setTitle("AddressBook-delete-record".localizable, for: .normal)
     nameTextField.placeholder = "AddressBook-name-Placehoder".localizable
     nameTextField.setPlaceHoder()
    }
    
    
    @IBAction func confirmBtnClick(_ sender: UIButton) {
        let addressStr = (self.textView.content.noneNull as NSString).replacingOccurrences(of: " ", with:  "")
        let nameStr = self.nameTextField.text.noneNull
        if addressStr.isEmpty{
            showBriefMessage(message: "Common-Address-Empty-Tip".localizable)
            return
        }else if nameStr.isEmpty{
            showBriefMessage(message: "AddressBook-Name-Empty-Tip".localizable)
            return
        }else if !HPBStringUtil.isValidAddress(addressStr){
            showBriefMessage(message: "ImportWallet-Address-inValid".localizable, view: self.view)
            return
        }else if (nameStr as NSString).judgeTheillegalCharacter(){
            showBriefMessage(message: "AddressBook-Emoj-Tip".localizable, view: self.view)
            return
        }
        let model = HPBAddressBookRealmModel()
        model.configModel(addressStr, name: nameStr)
         if HPBAddressBookManager.judgeExistInfo(model){
            showBriefMessage(message: "AddressBook-Exist-Tip".localizable,view: self.view)
            return
        }
        if handeType == .add{
            HPBAddressBookManager.insertContractInfo(model)
        }else{
            HPBAddressBookManager.updateContractInfoBy(hash: HPBStringUtil.noneNull(addBookmodel?.uuid), address: addressStr,name: nameStr)
        }
        //如果开启云同步几句推送到云端
        pushToClould()
    }
    
    
    @IBAction func scanBtnClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let scanVC =  HPBScanController()
        scanVC.scanType = .addContract
        scanVC.successBlock = {
          self.textView.content = $0
        }
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    @IBAction func deleteBtnClick(_ sender: UIButton) {
        HPBAddressBookManager.deleteContractInfoBy(hash: HPBStringUtil.noneNull(addBookmodel?.uuid))
        //如果开启云同步几句推送到云端
        pushToClould()
    }
    
    
    fileprivate func popToController(){
        func poptoAddressBookListVC(){
            if let nav = self.navigationController{
                if nav.viewControllers.count > 2{
                    self.navigationController?.popToViewController(nav.viewControllers[1], animated: true)
                }
            }
        }
        if self.handeType == .edit{
            poptoAddressBookListVC()
            
        }else{
            showBriefMessage(message: "AddressBook-AddNew-Success".localizable)
            switch sourceFrom{
            case .normal:
                self.navigationController?.popViewController(animated: true)
            case .scan:
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    
    func pushToClould(){
        switch handeType {
        case .add:
            if openState{
                showHudText(view: self.view)
                HPBAddressBookManager.pushLocalListToCould(success: {
                    hideHUD(view: self.view)
                    self.popToController()
                }) { (errorMsg) in
                    showBriefMessage(message: "AddressBook-iCould-Faile-Tip".localizable, view: self.view)
                }
            }else{
                self.popToController()
            }
        default:
            if openState{
                showHudText(view: self.view)
                HPBAddressBookManager.pushLocalListToCould(success: {
                    hideHUD(view: self.view)
                    self.popToController()
                }) { (errorMsg) in
                    showBriefMessage(message: "AddressBook-iCould-Faile-Tip".localizable, view: self.view)
                }
            }else{
                self.popToController()
            }
        }
    }

}

extension HPBAddNewContractController: UITextFieldDelegate{
    
    @objc func textFieldChange(userInfo: NSNotification){
        if let textfield = userInfo.object as? UITextField{
         textBumberLabel.text = "\(20 - textfield.text.noneNull.count)"
        }
    }
    
    func  textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if string.isEmpty{
            return true
        }
        if textField.text.noneNull.count<20{
            return true
        }else{
            return false
        }
        
        
}


}




