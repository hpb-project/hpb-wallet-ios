//
//  HPBAddressBookController.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/17.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit
import RealmSwift


class HPBAddressBookController: HPBBaseController,HPBEmptyViewProtocol {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    var emptyView: HPBEmptyView?
    enum HPBSourceType{
        case my,transfer
    }
    let separatStr = "##HPB##"
    var contractModels: Results<HPBAddressBookRealmModel>? {
          return  HPBAddressBookManager.getAllAddressBooks()
    }
    
    var openState: Bool{
        return  HPBiCouldManager.getiCouldState()
    }
    
    var nameArr: [String]{
        var array: [String] = []
        if let modesArr = self.contractModels{
            for model in  modesArr {
                array.append(model.contractName.noneNull + separatStr + model.addressStr.noneNull + separatStr + model.uuid.noneNull)
            }
        }
        return array
    }
    
    @IBOutlet weak var icloudTitleLabel: UILabel!
    @IBOutlet weak var icouldContentLabel: UILabel!
    @IBOutlet weak var tableVIew: UITableView!
  
    var sourceType: HPBSourceType = .my
    var selectBlock: ((String) -> Void)?
    var dataArr: [Any] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My-Address-List".localizable
        if self.sourceType == .my{
            steupLocation()
        }
        steuptableView()
        if openState{
            self.getICouldContractNetwork()
        }
        configNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.sourceType == .my{
            steupLocation()
        }
        reloadTableViewData()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    fileprivate func configNavigationItem(){
        let imageName = UIImage(named: "my_address_add")
        let barButtonItem = HPBBarButton.init(image: imageName)
        barButtonItem.clickBlock = {[weak self] in
            self?.clickedRightNavItem()
        }
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc fileprivate func  clickedRightNavItem(){
         let addressBookVC = HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBAddNewContractController.self))
        self.navigationController?.pushViewController(addressBookVC, animated: true)
    }
    
    func steuptableView(){
       
        if #available(iOS 11.0, *){
            self.tableVIew.contentInsetAdjustmentBehavior = .never
        }
        self.tableVIew.register(HPBAddressbookHeader.self, forHeaderFooterViewReuseIdentifier: "HPBAddressbookHeader")
        self.view.backgroundColor = UIColor.white
        self.tableVIew.backgroundColor = UIColor.white
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        self.tableVIew.sectionIndexColor = UIColor.paNavigationColor
        self.tableVIew.sectionIndexBackgroundColor = UIColor.clear
        self.tableVIew.rowHeight = 60
        self.tableVIew.sectionHeaderHeight = 45
        self.tableVIew.tableFooterView = UIView()
        if self.sourceType == .transfer{
            self.tableVIew.tableHeaderView = nil
        }
        reloadTableViewData()
    }
    
    func reloadTableViewData(){
        if let array = (nameArr as NSArray).withPinYinFirstLetterFormat(){
            dataArr = array
        }
        self.isHiddenEmptyView(!dataArr.isEmpty, topView: self.tableVIew)
        self.tableVIew.reloadData()
    }
    
    
    func separatContent(_ str: String) -> (String,String,String){
        let array =  str.components(separatedBy: separatStr)
        if array.count == 3{
            return (array[0],array[1],array[2])
        }
        return ("","","")
    }
    
    
    func  steupLocation(){
        
        self.icloudTitleLabel.text = "AddressBook-iCould-backup".localizable
        self.icouldContentLabel.text = openState  ?
            "AddressBook-iCould-open".localizable :
            "AddressBook-iCould-close".localizable
    }
    
    
    @IBAction func icouldBtnClick(_ sender: UIButton) {
        
        
        
    }
    
}

extension HPBAddressBookController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableVIew.dequeueReusableCell(withIdentifier: String(describing: HPBAddContractCell.self))
        if let  dict = self.dataArr[indexPath.section] as? [String: Any],
            let array = dict["content"] as? [String]{
            (cell as? HPBAddContractCell)?.titleLabel.text = separatContent(array[indexPath.row]).0
        }
        return cell ?? UITableViewCell()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let  dict = self.dataArr[section] as? [String: Any],
            let array = dict["content"] as? [String]{
          return array.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HPBAddressbookHeader") as?  HPBAddressbookHeader
        if headerView == nil{
            headerView = HPBAddressbookHeader(reuseIdentifier: "HPBAddressbookHeader")
        }
        if let  dict = self.dataArr[section] as? [String: Any],
            let title = dict["firstLetter"] as? String{
            headerView?.title = title
        }
        return headerView
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
       let array = self.dataArr.map { (data) -> String in
            if let  dict = data as? [String: Any],
                let title = dict["firstLetter"] as? String{
                return title
            }else{
                return ""
            }
        }
        return array
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let  dict = self.dataArr[indexPath.section] as? [String: Any],
            let array = dict["content"] as? [String]{
            if self.sourceType == .transfer{
                self.selectBlock?(array[indexPath.row])
               self.navigationController?.popViewController(animated: true)
            }else{
                let model =  HPBAddressBookRealmModel()
                model.contractName = separatContent(array[indexPath.row]).0
                model.addressStr = separatContent(array[indexPath.row]).1
                model.uuid = separatContent(array[indexPath.row]).2
                let detailVC =  HPBControllerUtil.instantiateControllerWithIdentifier(String(describing: HPBContractDetailController.self)) as!  HPBContractDetailController
                detailVC.model = model
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}


extension HPBAddressBookController{
    func getICouldContractNetwork(){
        showHudText(view: self.view)
        HPBAddressBookManager.downloadiCouldList(success: { (models) in
            hideHUD(view: self.view)
            HPBAddressBookManager.deleteAllAddressBooks()
            for model in models{
                let addressBookRealmModel =  HPBAddressBookRealmModel()
                addressBookRealmModel.configModel(model.addressContact, name: model.mark)
                 HPBAddressBookManager.insertContractInfo(addressBookRealmModel)
            }
            self.reloadTableViewData()
        }) { (errorMsg) in
            showBriefMessage(message: errorMsg,view: self.view)
        }
    }
    
    
}
