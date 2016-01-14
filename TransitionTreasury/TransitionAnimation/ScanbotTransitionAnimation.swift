//
//  ScanbotTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/14/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit

public class ScanbotTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    public var edgeSlidePop: Bool = false
    
    private let panGesture: UIPanGestureRecognizer?
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    init(gesture: UIPanGestureRecognizer?, status: TransitionStatus = .Push) {
        panGesture = gesture
        transitionStatus = status
        super.init()
        panGesture?.addTarget(self, action: Selector("slideTransition:"))
        if panGesture != nil {
            interacting = true
        }
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
    
    public func slideTransition(sender: UIPanGestureRecognizer) {
        
    }
    
}
