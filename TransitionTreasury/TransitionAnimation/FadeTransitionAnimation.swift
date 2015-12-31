//
//  FadeTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/22/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/// Fade Out In Animation
public class FadeTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?

    public var cancelPop: Bool = false

    public var interacting: Bool = false
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        toVC!.view.layer.opacity = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            toVC!.view.layer.opacity = 1
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
}
