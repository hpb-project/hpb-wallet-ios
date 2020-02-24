//
//  HPBPageControl.swift
//  HPBOpenSourceWallet
//
//  Created by 刘晓亮 on 2019/1/11.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPageControl: UIPageControl {

    init(){
        super.init(frame: CGRect.zero)
        self.setValue(UIImage(named: "banner_pagecontrol_select"), forKey: "_currentPageImage")
        self.setValue(UIImage(named: "banner_pagecontrol_normal"), forKey: "_pageImage")
        
    }
    
    func setCurrentPage(_ page: Int){
        self.currentPage = page
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
