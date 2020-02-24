//
//  HPBFeedbackController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/7/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBFeedbackController: HPBBaseTableController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var contentBackView: UIView!
    @IBOutlet weak var textView: HPBTextView!
    @IBOutlet weak var selectView: HPBFeedbackSelectView!
    @IBOutlet weak var titleField: HPBTextField!
    @IBOutlet weak var contractField: HPBTextField!
    @IBOutlet weak var selectImageView: HPBSelectImageView!
    
    //国际化配置
    @IBOutlet weak var classifyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contractLabel: UILabel!
    @IBOutlet weak var commitBtn: HPBSelectImgeButton!
     fileprivate var imageDatas: [Data] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HelpCenter-Feedback".localizable
        steupView()
        steupLocalizable()
    }
    
    func steupLocalizable(){
        titleField.placeholder = "Feedback-Title-Placehoder".localizable
        titleField.setPlaceHoder()
        contractField.placeholder = "W3t-mz-uTY.placeholder".MainLocalizable
        contractField.setPlaceHoder()
        classifyLabel.text = "q23-Bt-hAH.text".MainLocalizable
        titleLabel.text = "rzq-gc-wLb.text".MainLocalizable
        contractLabel.text = "ahe-aS-4Dg.text".MainLocalizable
        commitBtn.setTitle("xU1-d3-rJV.normalTitle".MainLocalizable, for: .normal)
    }
    
    func  steupView(){
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
        commitBtn.layer.shadowColor = UIColor.black.cgColor
        commitBtn.layer.shadowOffset = CGSize.zero
        commitBtn.layer.shadowOpacity = 0.2
        commitBtn.layer.shadowRadius = 30
        contentBackView.layer.borderWidth = UIScreen.separatorSize
        contentBackView.layer.borderColor = UIColor.paDividing.cgColor
        textView.placehoder = "Feedback-Content-Placehoder".localizable
        selectView.btnTitles = ["Feedback-Questions","Feedback-Suggestion","Feedback-Others"]
        selectImageView.reloadImages(datas: [])
        selectImageView.selectImageBlock = { [weak self] in
            self?.initPhotoPicker()
        }
        selectImageView.clearBlock = {[weak self,weak selectImageView] in
            guard  let `self` = self else {
                return
            }
            self.imageDatas.remove(at: $0)
            selectImageView?.reloadImages(datas: self.imageDatas)
        }
    }
    


    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        let title = titleField.text.noneNull
        let content = textView.content.noneNull
        let contract = contractField.text.noneNull
        
        if title.isEmpty{
            showBriefMessage(message: "Feedback-Title-Tip".localizable)
            return
        }else if content.isEmpty{
            showBriefMessage(message: "Feedback-Content-Tip".localizable)
            return
        }else if contract.isEmpty{
            showBriefMessage(message: "Feedback-Contract-Tip".localizable)
            return
        }
        
        if title.count > 100 || contract.count>100{
            showBriefMessage(message: "Feedback-Max-Content".localizable)
            return
        }
        suggestNetwork(title: title, content: content, contact: contract)
    }
    
}

extension HPBFeedbackController {
    
    //从相册中选择
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获得照片
        let image  = info[UIImagePickerControllerEditedImage] as! UIImage
        if let data = UIImageJPEGRepresentation(image, 0.03){
            imageDatas.append(data)
            selectImageView.reloadImages(datas: imageDatas)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HPBFeedbackController {
    
    fileprivate func suggestNetwork(title: String,content: String,contact: String){
        
        showHudText(view: self.view)
        let (requestUrl,param) = HPBAppInterface.getSuggestion(type: "\(selectView.index)", title: title, content: content, time: Date().toString(), contact: contact)
        HPBNetwork.default.upload(requestUrl, parameters: param, imageDatas: imageDatas) { (result, errorMsg) in
            if errorMsg == nil{
                showImage(text: "Feedback-Success-Tip".localizable)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                showBriefMessage(message: errorMsg, view: self.view)
            }
        }
    }
    
}
