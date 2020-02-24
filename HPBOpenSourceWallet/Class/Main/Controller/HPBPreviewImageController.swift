//
//  HPBPreviewImageController.swift
//  HPBOpenSourceWallet
//
//  Created by liuxiaoliang on 2019/9/4.
//  Copyright © 2019 Zhaoxi Network. All rights reserved.
//

import UIKit

class HPBPreviewImageController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollow: UIScrollView!
    
    @IBOutlet weak var image: UIImageView!
    var assertImageUrlStr: String = ""
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13, *){
            return .darkContent
        }
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollow.maximumZoomScale = 2
        scrollow.minimumZoomScale = 0.5
        scrollow.delegate = self
        image.image = UIImage.init(named: "common_head_placehoder")
        image.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapZoom))
        tapgesture.numberOfTapsRequired = 2
        image.addGestureRecognizer(tapgesture)
    }
    
    @objc func tapZoom(){
       
        if  scrollow.zoomScale == 1{
             scrollow.setZoomScale(2, animated: true)
        }else if  scrollow.zoomScale == 2{
            scrollow.setZoomScale(1, animated: true)
        }
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }
    
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale < 1{
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
}
