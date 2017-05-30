//
//  DefaultPercentDrivenInteractiveTransition.swift
//  DefaultPercentDrivenInteractiveTransition
//
//  Created by John_LS on 2016/12/22.
//  Copyright © 2016年 John_LS. All rights reserved.
//

import UIKit

class DefaultPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition   {
    
    
    ///以下是自定义交互控制器
    var transitionContext : UIViewControllerContextTransitioning!
    var formView : UIView!
    var toView : UIView!
    let x_to : CGFloat = -100.0 ///toview起始x坐标
    
    
    /// 以下----自定义交互控制器
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        
        let containerView = transitionContext.containerView
        
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {
                ///预防rootviewcontroller触发
                return
        }
        
        
        self.transitionContext = transitionContext
        
        
        containerView.insertSubview((toViewController.view)!, belowSubview: (fromViewController.view)!)
        
        
        /// 加点阴影
        fromViewController.view.layer.shadowOpacity = 0.8
        fromViewController.view.layer.shadowColor = UIColor.black.cgColor
        fromViewController.view.layer.shadowOffset = CGSize(width: 3, height: 3)
        fromViewController.view.layer.shadowRadius = 3
        
        self.formView = fromViewController.view
        self.toView = toViewController.view
        self.toView.frame = CGRect(x:x_to,y:0,width:self.toView.frame.width,height:self.toView.frame.height)

    }
    override func update(_ percentComplete: CGFloat) {
        
        if transitionContext == nil {
            ///预防rootviewcontroller触发
            return
        }
        
        self.formView?.frame = CGRect(x:(self.formView?.frame.width)!*percentComplete, y:0, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
        self.toView?.frame = CGRect(x:self.x_to+CGFloat(fabsf(Float(self.x_to*percentComplete))), y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
        transitionContext?.updateInteractiveTransition(percentComplete)
        
    }
    
    
    
    func finishBy(cancelled: Bool) {
        if self.transitionContext == nil {
            ///预防rootviewcontroller触发
            return
        }
        if cancelled {
            UIView.animate(withDuration: 0.2, animations: {
                self.formView?.frame = CGRect(x:0, y:0, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
                self.toView?.frame = CGRect(x:self.x_to, y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
            }, completion: {completed in
                self.transitionContext!.cancelInteractiveTransition()
                self.transitionContext!.completeTransition(false)
                self.transitionContext = nil
                self.toView = nil
                self.formView = nil
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.formView?.frame = CGRect(x:(self.formView?.frame.width)!, y:0, width:(self.formView?.frame.width)! , height: (self.formView?.frame.height)!)
                self.toView?.frame = CGRect(x:0, y:0, width:(self.toView?.frame.width)! , height: (self.toView?.frame.height)!)
            }, completion: {completed in
                self.transitionContext!.finishInteractiveTransition()
                self.transitionContext!.completeTransition(true)
                self.transitionContext = nil
                self.toView = nil
                self.formView = nil
            })
        }
    }
    
}
