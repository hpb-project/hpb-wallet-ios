//
//  ProgresView.swift
//  RoundProgressSwift
//
//  Created by 刘晓亮 on 15/8/24.
//  Copyright (c) 2018年 . All rights reserved.
//

import UIKit
//let degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
func degreesToRadians(x:CGFloat) ->CGFloat
{
    return CGFloat(CGFloat(Double.pi) * x/180.0)
}

class HPBProgressView: UIView {

    private  var  _progressLabel:UILabel!
    private  var  _backLayer:CAShapeLayer!
    private  var  _fillShapeLayer:CAShapeLayer!
    private  var  _display:CADisplayLink!
    var space: CGFloat = 10
    var duration: CGFloat = 3
    var circleLineWidth: CGFloat = 6.0
    var           angel: CGFloat = 0
    var       backColor: UIColor = UIColor.lightGray
    var      fillColor1: UIColor = UIColor.red

    var     finishAnimationBlock: (()-> Void)?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.isHidden = true
        steupSkipBtn()
    }
      
    
     override init(frame: CGRect) {
       super.init(frame: frame)
          steupSkipBtn()
    }
    
    func steupSkipBtn(){
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(skipBtnClick))
        self.addGestureRecognizer(tapgesture)
    }

    @objc func skipBtnClick(){
         stopAnimation()
    }
    
    func stopAnimation(){
        _display.invalidate()
        finishAnimationBlock?()
        self.removeFromSuperview()
    }
    
    @objc func updateProgress()
    {
        self.angel += 360/duration/60;
        if self.angel >= 360{
            stopAnimation()
        }
        let fillPath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.width/2), radius:CGFloat((self.bounds.size.width - 2 * space - 2 * self.circleLineWidth)/2), startAngle: CGFloat(-Double.pi / 2), endAngle:degreesToRadians(x: self.angel-90), clockwise: true)
        _fillShapeLayer.path = fillPath.cgPath
        _progressLabel.text = "\(Int(duration) - Int(self.angel * duration/360))"
        
    }
    
    func startAnimation(){
        self.isHidden = false
        _display = CADisplayLink(target: self, selector:#selector(updateProgress))
        _display.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    
    override func layoutSubviews() {
        if _backLayer==nil{

            //创建背景的圆环
            _backLayer = CAShapeLayer()
            _backLayer.masksToBounds = true
            _backLayer.frame = self.bounds;
            _backLayer.strokeColor = self.backColor.cgColor;
            _backLayer.fillColor = UIColor.clear.cgColor
            _backLayer.lineWidth = self.circleLineWidth;
            //创建背景路径
            let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.width / 2), radius: CGFloat((self.bounds.size.width - 2 * space - 2 * self.circleLineWidth)/2), startAngle: CGFloat(0), endAngle: CGFloat(2*Double.pi), clockwise: true)
            _backLayer.path = path.cgPath;
            self.layer.addSublayer(_backLayer)

            
            //create shape layer
            _fillShapeLayer = CAShapeLayer()
            _fillShapeLayer.frame = self.bounds
            _fillShapeLayer.strokeColor = fillColor1.cgColor
            _fillShapeLayer.fillColor = UIColor.clear.cgColor
            _fillShapeLayer.lineWidth =  self.circleLineWidth
            _fillShapeLayer.lineJoin = kCALineJoinMiter
            _fillShapeLayer.lineCap = kCALineCapButt
            self.layer.addSublayer(_fillShapeLayer)
            
            
            _progressLabel = UILabel(frame: CGRect(x: 0 ,y: 0, width: self.bounds.size.width, height: self.bounds.size.height - 2 * space - 2 * self.circleLineWidth))
            _progressLabel.isUserInteractionEnabled = true
            _progressLabel.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.width/2)
            _progressLabel.textAlignment = NSTextAlignment.center
            _progressLabel.textColor = UIColor.white
            _progressLabel.font = UIFont.systemFont(ofSize: 19)
            self.addSubview(_progressLabel)
    
        }
 
    }
}
