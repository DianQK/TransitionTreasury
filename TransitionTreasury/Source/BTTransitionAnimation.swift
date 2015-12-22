//
//  BTTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/22/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public class BTTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var keyView: UIView?
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var completion: (() -> Void)?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    init(key: UIView?, status: TransitionStatus = .Push) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 7
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        let keyViewCopy = UIView(frame: keyView!.frame)
        keyViewCopy.layer.contents = keyView?.layer.contents
        
        let lightMaskLayer = CALayer()
        lightMaskLayer.frame = CGRect(origin: CGPointZero, size: toVC!.view.bounds.size)
        lightMaskLayer.backgroundColor = UIColor.whiteColor().CGColor
        lightMaskLayer.opacity = 0
        
        let maskAnimation = CABasicAnimation(keyPath: "opacity")
        maskAnimation.toValue = 1
        maskAnimation.duration = transitionDuration(transitionContext)
        lightMaskLayer.addAnimation(maskAnimation, forKey: "")
        
        
        containView?.addSubview(toVC!.view)
        containView?.addSubview(fromVC!.view)
        containView?.layer.addSublayer(lightMaskLayer)
        containView?.addSubview(keyViewCopy)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            keyViewCopy.layer.position.y = keyViewCopy.layer.bounds.height / 2
//            lightMaskLayer.opacity = 0.5
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if !self.cancelPop {
                    if finished {
                        self.completion?()
                        self.completion = nil
                    }
                }
                self.cancelPop = false
        }
    }

}
