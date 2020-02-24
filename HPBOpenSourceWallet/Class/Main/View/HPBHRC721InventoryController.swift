//
//  HPBHRC721InventoryController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/3.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit
import MJRefresh

class HPBHRC721InventoryController: UIViewController,HPBEmptyViewProtocol {
    var emptyView: HPBEmptyView?
    @IBOutlet weak var collectionView: UICollectionView!
    let itemWidth: CGFloat = (UIScreen.width - 54)/2
    let itemHeight: CGFloat = 158
    var contractAddress: String = "" //合约地址
    var selectBlock: ((Int,String)-> Void)?
    var currentPage: Int = 1
    var recordModels: [HPB721StockModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        steupCollectionView()
        request721StockList(page: self.currentPage)
    }
    
    func  steupCollectionView(){
        collectionView.register(UINib(nibName: "HPBHRC721InventoryCell", bundle: nil), forCellWithReuseIdentifier: "HPBHRC721InventoryCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize  = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 18, bottom: 0, right: 18)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 18
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.backgroundColor = UIColor.paBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let mjHeader = MJRefreshNormalHeader.init(){ [weak self] in
            self?.currentPage = 1
            self?.startRequestData(true) {
                self?.collectionView.mj_header.endRefreshing()
            }
            
        }
        collectionView.mj_header = mjHeader
        
        
        let footer = MJRefreshAutoNormalFooter{ [weak self] in
            guard let `self` = self else{return}
            self.startRequestData(false) {
            self.collectionView.mj_footer.endRefreshing()
            }
        }
        collectionView.mj_footer = footer
        collectionView.mj_footer.isHidden = true
    }
}


extension HPBHRC721InventoryController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recordModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "HPBHRC721InventoryCell", for: indexPath) as!  HPBHRC721InventoryCell
        let model = self.recordModels[indexPath.row]
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let model = self.recordModels[indexPath.row]
        selectBlock?(model.count,model.tokenId)
        
    }
    
}


extension HPBHRC721InventoryController{
 
    func startRequestData(_ isRefresh: Bool, finish: (() -> Void)?) {
        self.request721StockList(page: self.currentPage) {
              finish?()
        }
    }
    
    func request721StockList(page: Int,complete: (() -> Void)? = nil){
        
        if self.recordModels.isEmpty{
          showHudText(view: self.view)
        }
        let currentAddress = HPBUserMannager.shared.currentWalletInfo?.addressStr
        let contractAddress = self.contractAddress
        let (requestUrl,param) = HPBAppInterface.getToken721StockList(address: currentAddress.noneNull, contractAddress: contractAddress, page: "\(page)")
        HPBNetwork.default.request(requestUrl, parameters: param) { (result, errorMsg) in
            complete?()
            hideHUD(view: self.view)
            if errorMsg == nil{
                guard let model =  HPBBaseModel.mp_effectiveModel(result: result) as HPB721StockList? else{return}
                if self.currentPage == 1{
                    self.recordModels.removeAll()
                    self.collectionView.mj_footer.isHidden = false
                }
                debugLog(self.currentPage)
                if model.pages == self.currentPage || model.pages == 0{
                     self.collectionView.mj_footer.isHidden = true
                }else{
                    self.currentPage += 1
                }
                self.recordModels += model.list
                self.collectionView.reloadData()
                self.isHiddenEmptyView(!self.recordModels.isEmpty, topView: self.collectionView)
            }else{
               showBriefMessage(message: errorMsg,view: self.view)
            }
        }
        
    }

    
}

