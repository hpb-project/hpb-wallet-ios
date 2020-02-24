//
//  HPBCellRegister.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/8.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

extension UITableView{
    
    func registerCell(_ sectionModels: [HPBSectionModel]?){
        
        guard let `sectionModels` = sectionModels else{
            return
        }
        
        //查找所有不重复的cellmodes的标识符
        var cellModels: [HPBCellModel] = []
        var identifierArr: [String] = []
        sectionModels.forEach {
            let rowModel = $0.cellModelArr
            rowModel.forEach{
                if !identifierArr.contains($0.identifier){
                    identifierArr.append($0.identifier)
                    cellModels.append($0)
                }
            }
        }
        //注册cell
        for rowModel in cellModels{
            let identifier = rowModel.identifier
            if rowModel.isRegisterByClass {
                register(rowModel.classType, forCellReuseIdentifier: identifier)
            } else {
                register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
            }
        }
        
        //注册headerView
        let headerModels = sectionModels.compactMap {$0.headerViewModel}
        for model in headerModels{
            let identifier = model.identifier
            if model.isRegisterByClass {
              register(model.classType, forHeaderFooterViewReuseIdentifier: identifier)
            } else if !identifier.isEmpty {
              register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
            }
        }
    }
    
}
