//
//  HPBDAppCell.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/12/20.
//  Copyright © 2018 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBDAppCell: HPBBaseTableCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   static let cellModel = HPBCellModel(identifier: String(describing: HPBDAppCell.self), height: UIScreen.width/5.5 - 30 + 38 + 15)
    
    var clickBlock: ((Int)->Void)?
    var models: [HPBDAppModel] = []{
        didSet{
          self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0.01
        layout.minimumLineSpacing = 0.01
         self.collectionView.register(UINib(nibName: "HPBDAppItemCell", bundle: nil), forCellWithReuseIdentifier: "HPBDAppItemCell")
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = layout
    }
    
}


extension HPBDAppCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "HPBDAppItemCell", for: indexPath) as!  HPBDAppItemCell
        let model = self.models[indexPath.row]
        let name = HPBLanguageUtil.share.language == .chinese ? model.nameCn : model.nameEn
        cell.config(name: name, imageUrl: model.logo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        self.clickBlock?(index)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            return CGSize(width: UIScreen.width/5.5, height: UIScreen.width/5.5 - 30 + 38)
    }
    
}




