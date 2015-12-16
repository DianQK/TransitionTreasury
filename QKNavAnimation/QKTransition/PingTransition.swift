//
//  PingTransition.swift
//  StudyAnimation
//
//  Created by 宋宋 on 12/11/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit
/// Ping 具体实现

public class PingTransition: NSObject, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate {
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    let keyView: UIView
    
    var transitionStatus: TransitionStatus
    
    var percentTransition: UIPercentDrivenInteractiveTransition?
    
    var edgeGes: UIScreenEdgePanGestureRecognizer?
    
    
    init(key: UIView, status: TransitionStatus) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let contView = transitionContext.containerView()
        
        var maskStartBP = UIBezierPath(ovalInRect: keyView.frame)
        
        contView?.addSubview(fromVC!.view)
        contView?.addSubview(toVC!.view)
        
        //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
        
        let finalPoint: CGPoint = {
            if keyView.frame.origin.x > (toVC!.view.bounds.size.width / 2) {
                if keyView.frame.origin.y < (toVC!.view.bounds.size.height / 2) {// 1
                    return CGPoint(x: keyView.center.x - 0, y: keyView.center.y-CGRectGetMaxX(toVC!.view.bounds) + 30 - 64 * 3)
                }else{// 2
                    return CGPoint(x: keyView.center.x - 0, y: keyView.center.y - 0)
                }
            }else{
                if keyView.frame.origin.y < (toVC!.view.bounds.size.height / 2) {// 3
                    return CGPoint(x: keyView.center.x - CGRectGetMaxX(toVC!.view.bounds), y: keyView.center.y - CGRectGetMaxY(toVC!.view.bounds) + 30 - 64 * 3)
                }else{// 3
                    return CGPoint(x: keyView.center.x - CGRectGetMaxX(toVC!.view.bounds), y: keyView.center.y - 0)
                }
            }
        }()
        
        let radius = sqrt(finalPoint.x*finalPoint.x + finalPoint.y*finalPoint.y)
        var maskFinalBP = UIBezierPath(ovalInRect: CGRectInset(keyView.frame, -radius, -radius))
        
        //创建一个 CAShapeLayer 来负责展示圆形遮盖
        let maskLayer = CAShapeLayer()
        
        if transitionStatus == .Pop {
            (maskStartBP, maskFinalBP) = (maskFinalBP, maskStartBP)
            contView?.bringSubviewToFront(fromVC!.view)
            fromVC!.view.layer.mask = maskLayer
        } else {
            edgeGes = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("edgePan:"))
            edgeGes!.edges = .Left
            toVC!.view.addGestureRecognizer(edgeGes!)
            toVC!.view.layer.mask = maskLayer
        }
        
        maskLayer.path = maskFinalBP.CGPath
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = maskStartBP.CGPath
        maskLayerAnimation.toValue = maskFinalBP.CGPath
        maskLayerAnimation.duration = transitionDuration(transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.removedOnCompletion = false
        maskLayerAnimation.fillMode = kCAFillModeForwards
        maskLayerAnimation.delegate = self
        
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
        
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //告诉 iOS 这个 transition 完成
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
        //清除 fromVC 的 mask
//        transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
//        transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
    }
    
    
    
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push {
            return self
        } else if operation == .Pop {
            return self
        } else {
            return nil
        }
    }
    
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if transitionStatus == .Push {
            return nil
        } else {
            return percentTransition
        }
    }
    
    func edgePan(recognizer: UIPanGestureRecognizer) {
        
        let fromVC = transitionContext!.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let view = fromVC!.view
        
        var percent = recognizer.translationInView(view).x / view.bounds.size.width
        
        percent = min(1.0, max(0, percent))
        
        if recognizer.state == .Began {
            percentTransition = UIPercentDrivenInteractiveTransition()
            fromVC?.navigationController?.qk_popViewController()
        } else if recognizer.state == .Changed {
            percentTransition?.updateInteractiveTransition(percent)
        } else {
            if percent > 0.3 {
                percentTransition?.finishInteractiveTransition()
                edgeGes?.removeTarget(self, action: Selector("edgePan:"))
                edgeGes = nil
            } else {
                percentTransition?.cancelInteractiveTransition()
            }
            
        }
        
    }
}
