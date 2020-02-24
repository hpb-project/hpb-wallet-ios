//
//  HPBBaseController.swift
//  LXLTest1
//
//  Created by liuxiaoliang on 2018/5/23.
//  Copyright © 2018年 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBBaseController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.paBackground

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HPBNavigationBarStyle.setupStyleByNavigation(self.navigationController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        debugLog(String(describing: self.classForCoder) + "析构方法执行")
    }
}
