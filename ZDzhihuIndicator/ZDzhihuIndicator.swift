//
//  ZDzhihuIndicator.swift
//  ZDInfinity
//
//  Created by 张亚东 on 15/3/28.
//  Copyright (c) 2015年 zhangyd. All rights reserved.
//

import UIKit
let ZDScreenWidth = UIScreen.mainScreen().bounds.width
let ZDScreenHeight = UIScreen.mainScreen().bounds.height


class ZDzhihuIndicator: UIView {

    class var sharedIndicator :ZDzhihuIndicator {
        //4
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ZDzhihuIndicator?
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = ZDzhihuIndicator()
        })
        
        return Static.instance!
    }
    //5
    lazy var maskWindow : UIWindow? = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.windowLevel = UIWindowLevelNormal
        
        return window
    }()
    
    lazy var indicatorLayer : CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        layer.position = CGPoint(x: ZDScreenWidth / 2, y: ZDScreenHeight / 2)
        layer.path = UIBezierPath(arcCenter: CGPoint(x: layer.bounds.width / 2, y: layer.bounds.height / 2), radius: layer.bounds.width / 2, startAngle: 0, endAngle: CGFloat(2 * M_PI) , clockwise: true).CGPath
        layer.lineWidth = 3
        layer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeEnd = 0
        layer.strokeStart = 0
        return layer
    }()
    
    //10
    lazy var strokeEndAnimation : CABasicAnimation = {
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        end.duration = 1
        end.fromValue = 0
        end.toValue = 0.95
        end.removedOnCompletion = false
        end.fillMode = kCAFillModeForwards
        return end
    }()
    
    lazy var strokeStartAnimation : CABasicAnimation = {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        start.duration = 1
        start.fromValue = 0
        start.toValue = 0.95
        start.beginTime = 1
        start.removedOnCompletion = false
        start.fillMode = kCAFillModeForwards
        
        return start
    }()
    
    lazy var animationGroup : CAAnimationGroup = {
        let group = CAAnimationGroup()
        group.animations = [self.strokeEndAnimation,self.strokeStartAnimation]
        group.repeatCount = HUGE
        group.duration = 2
        return group
    }()
    
    //11
    lazy var rotateZAnimation : CABasicAnimation = {
        let rotateZ = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateZ.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotateZ.duration = 2
        rotateZ.fromValue = 0
        rotateZ.toValue = 2 * M_PI
        rotateZ.repeatCount = HUGE
        
        return rotateZ
    }()
    
    //6
    override init(frame: CGRect) {
        super.init(frame:CGRectZero)
        self.alpha = 0
        self.frame = self.maskWindow!.bounds
        self.layer.addSublayer(self.indicatorLayer)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    class func show() {
        //1.show mask window
        sharedIndicator.maskWindow!.makeKeyAndVisible()
        sharedIndicator.maskWindow!.addSubview(sharedIndicator)
        //2.start
        sharedIndicator.beginAnimation()
    }
    
    class func dismiss() {
        
        sharedIndicator.endAnimationWithCompletion { () -> Void in
            //3.
            self.sharedIndicator.maskWindow!.resignKeyWindow()
            self.sharedIndicator.removeFromSuperview()
            
            let originalWindow = UIApplication.sharedApplication().delegate!.window
            originalWindow!?.makeKeyAndVisible()
        }
    }
 
    func beginAnimation () {
        //7
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 1
        }) { (_) -> Void in
            self.beginIndicatorAnimation()
        }
    }
    
    func beginIndicatorAnimation() {
        //8
        indicatorLayer.addAnimation(animationGroup, forKey: "group")
        indicatorLayer.addAnimation(rotateZAnimation, forKey: "rotationZ")
    }
    
    func endAnimationWithCompletion(completion:() -> Void) {
        //9
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0
            self.indicatorLayer.removeAllAnimations()
            }) { (_) -> Void in
                completion()
        }
    }
}















