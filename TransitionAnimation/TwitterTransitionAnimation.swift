//
//  TwitterTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury

/// Like Twitter Present.
public class TwitterTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    private var anchorPointBackup: CGPoint?
    
    private var positionBackup: CGPoint?
    
    private var transformBackup: CATransform3D?
    
    public init(status: TransitionStatus = .Present) {
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containView = transitionContext.containerView()
        let screenBounds = UIScreen.mainScreen().bounds
        var angle = M_PI/48
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/500.0
        
        transformBackup = fromVC?.view.layer.transform
        
        var startFrame = CGRectOffset(screenBounds, 0, screenBounds.size.height)
        var finalFrame = screenBounds
        
        if transitionStatus == .Dismiss {
            swap(&fromVC, &toVC)
            swap(&startFrame, &finalFrame)
            angle = -angle
        } else if transitionStatus == .Present {
            transform = CATransform3DRotate(transform, CGFloat(angle), 1, 0, 0)
            anchorPointBackup = fromVC?.view.layer.anchorPoint
            positionBackup = fromVC?.view.layer.position
            fromVC?.view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            fromVC?.view.layer.position = CGPoint(x: fromVC!.view.layer.position.x, y: fromVC!.view.layer.position.y + fromVC!.view.layer.bounds.height / 2)
        }
        
        toVC?.view.layer.frame = startFrame
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            fromVC?.view.layer.transform = transform
            toVC?.view.layer.frame = finalFrame
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if self.transitionStatus == .Dismiss && finished {
                    fromVC?.view.layer.anchorPoint = self.anchorPointBackup ?? CGPoint(x: 0.5, y: 0.5)
                    fromVC?.view.layer.position = self.positionBackup ?? CGPoint(x: fromVC!.view.layer.position.x, y: fromVC!.view.layer.position.y - fromVC!.view.layer.bounds.height / 2)
                    fromVC?.view.layer.transform = self.transformBackup ?? CATransform3DIdentity
                }
        }
    }
}

