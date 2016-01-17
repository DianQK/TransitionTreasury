//
//  StorehouseTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/4/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
// Developer~ 
public class StorehouseTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public private(set) var keyView: UIView
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var completion: (() -> Void)?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    private var animationCount = 0
    
    private var transformBackup: CATransform3D?
    
    lazy public private(set) var keyViewCopy: UIView = self.keyView.tr_copyWithSnapshot()
    
    public init(key: UIView, status: TransitionStatus = .Push) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        transformBackup = transformBackup ?? (toVC?.view.layer.transform ?? CATransform3DIdentity)
        
        let scale = keyView.layer.bounds.width / toVC!.view.layer.bounds.width
        let offsetY = toVC!.view.convertPoint(keyView.frame.origin, fromView: keyView.superview).y - (1 - scale) * toVC!.view.layer.bounds.height / 2
        
        var startTransform: CATransform3D = CATransform3DIdentity
        startTransform = CATransform3DTranslate(startTransform, 0, offsetY, 0)
        startTransform = CATransform3DScale(startTransform, scale, scale, 0)
        
        var endTransform = transformBackup!
        
        debugPrint(startTransform)
        
        var startPath = UIBezierPath(rect: keyView.bounds).CGPath
        var endPath = UIBezierPath(rect: (transitionStatus == .Push ? toVC : fromVC)!.view.bounds).CGPath
        
        if transitionStatus == .Pop {
            swap(&fromVC, &toVC)
            swap(&startTransform, &endTransform)
            swap(&startPath, &endPath)
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath

        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        
//        print(toVC)
        
        toVC?.view.layer.mask = maskLayer
//        toVC?.view.layer.transform = endTransform
        
        let transformAnimation = CABasicAnimation(tr_keyPath: .transform)
        transformAnimation.fromValue = startTransform.tr_ns_value
        transformAnimation.toValue = endTransform.tr_ns_value
        transformAnimation.duration = transitionDuration(transitionContext)
        transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transformAnimation.delegate = self
        // FIXME: - transform
        animationCount++
        toVC?.view.layer.addAnimation(transformAnimation, forKey: "transform")
        
        let pathAnimation = CABasicAnimation(tr_keyPath: .path)
        pathAnimation.fromValue = startPath
        pathAnimation.toValue = endPath
        pathAnimation.duration = transitionDuration(transitionContext)
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.delegate = self
        
        animationCount++
        maskLayer.addAnimation(pathAnimation, forKey: "path")
        

    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animationCount--
        if animationCount == 0 {
        
        if !self.cancelPop {
//            if finished {
                self.completion?()
                self.completion = nil
//            }
        }
        
        self.cancelPop = false
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
        transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
        transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
//        }
    }
    }
    
}

