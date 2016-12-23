//
//  TwitterTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury

/// Like Twitter Present.
open class TwitterTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    fileprivate var anchorPointBackup: CGPoint?
    
    fileprivate var positionBackup: CGPoint?
    
    fileprivate var transformBackup: CATransform3D?
    
    public init(status: TransitionStatus = .present) {
        transitionStatus = status
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let containView = transitionContext.containerView
        let screenBounds = UIScreen.main.bounds
        var angle = M_PI/48
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/500.0
        
        transformBackup = fromVC?.view.layer.transform
        
        var startFrame = screenBounds.offsetBy(dx: 0, dy: screenBounds.size.height)
        var finalFrame = screenBounds
        
        if transitionStatus == .dismiss {
            swap(&fromVC, &toVC)
            swap(&startFrame, &finalFrame)
            angle = -angle
        } else if transitionStatus == .present {
            transform = CATransform3DRotate(transform, CGFloat(angle), 1, 0, 0)
            anchorPointBackup = fromVC?.view.layer.anchorPoint
            positionBackup = fromVC?.view.layer.position
            fromVC?.view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            fromVC?.view.layer.position = CGPoint(x: fromVC!.view.layer.position.x, y: fromVC!.view.layer.position.y + fromVC!.view.layer.bounds.height / 2)
        }
        
        toVC?.view.layer.frame = startFrame
        
        containView.addSubview(fromVC!.view)
        containView.addSubview(toVC!.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromVC?.view.layer.transform = transform
            toVC?.view.layer.frame = finalFrame
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if self.transitionStatus == .dismiss && finished {
                    fromVC?.view.layer.anchorPoint = self.anchorPointBackup ?? CGPoint(x: 0.5, y: 0.5)
                    fromVC?.view.layer.position = self.positionBackup ?? CGPoint(x: fromVC!.view.layer.position.x, y: fromVC!.view.layer.position.y - fromVC!.view.layer.bounds.height / 2)
                    fromVC?.view.layer.transform = self.transformBackup ?? CATransform3DIdentity
                }
        }
    }
}

