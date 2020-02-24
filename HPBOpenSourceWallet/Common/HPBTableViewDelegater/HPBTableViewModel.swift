//
//  HPBTableViewModel.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2018/6/6.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import Foundation
import UIKit


/// 快速生成 HPBSectionModel
struct HPBTableViewModel {
    static func getSectionModel(_ cellModels: [HPBCellModel], sectionName: String? = nil, headerViewModel: HPBHeaderFooterViewModel? = nil, footerViewModel: HPBHeaderFooterViewModel? = nil) -> HPBSectionModel {
        var sectionModel = HPBSectionModel()
        sectionModel.sectionName = sectionName
        sectionModel.cellModelArr = cellModels
        sectionModel.headerViewModel = headerViewModel
        sectionModel.footerViewModel = footerViewModel
        return sectionModel
    }
    
    static func getSectionModel(cellModelTupleArr: (HPBCellModel, Int)...,headerViewModel: HPBHeaderFooterViewModel? = nil) -> HPBSectionModel {
        var cellModels: [HPBCellModel] = []
        cellModelTupleArr.forEach { cellModelTuple in
            let (cellModel, cellCount) = (cellModelTuple.0, cellModelTuple.1)
            cellModels += [HPBCellModel](repeating: cellModel, count: cellCount)
        }
        let sectionModel = HPBTableViewModel.getSectionModel(cellModels,headerViewModel: headerViewModel)
        return sectionModel
    }
    
}

/// Section配置
struct HPBSectionModel {
    var headerViewModel: HPBHeaderFooterViewModel?
    var footerViewModel: HPBHeaderFooterViewModel?
    var cellModelArr: [HPBCellModel] = []
    var sectionName: String?
    
    init(){
        
    }
    subscript(indexPath: IndexPath) -> HPBCellModel {
        return cellModelArr[indexPath.row]
    }
}



/// cell配置
struct HPBCellModel {
    var cellName: String?
    var identifier: String
    var height: CGFloat = -1
    var isRegisterByClass: Bool = false
    var classType: AnyClass?
    var canEdit: Bool = false
    
    init(identifier: String, height: CGFloat = -1, classType: AnyClass? = nil, canEdit: Bool = false) {
        self.identifier = identifier
        self.height = height
        if classType != nil {
            self.isRegisterByClass = true
            self.classType = classType
        }
        self.canEdit = canEdit
    }
}


/// HeaderFooter配置
struct HPBHeaderFooterViewModel {
    var identifier: String
    var height: CGFloat = 0.01
    var isRegisterByClass: Bool = false
    var classType: AnyClass?
    var headerFooterViewName: String?
    
    init(identifier: String, height: CGFloat = -1, isRegisterByClass: Bool = false, classType: AnyClass? = nil,name: String? = nil) {
        self.identifier = identifier
        self.height = height
        self.isRegisterByClass = isRegisterByClass
        self.classType = classType
        self.headerFooterViewName = name
    }
}
