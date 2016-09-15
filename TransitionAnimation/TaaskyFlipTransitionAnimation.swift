//
//  TaaskyFlipTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/31/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury

public class TaaskyFlipTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public private(set) var blurEffect: Bool = true
    
    private var anchorPointBackup: CGPoint?
    
    private var positionBackup: CGPoint?
    
    public init(blurEffect blur: Bool = true, status: TransitionStatus = .present) {
        blurEffect = blur
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        let containView = transitionContext.containerView
        
        let angle = M_PI/2
        var startTransform = CATransform3DIdentity
        startTransform.m34 = -1.0/500.0
        startTransform = CATransform3DRotate(startTransform, CGFloat(angle), 0, 1, 0)
        var endTransform = CATransform3DIdentity
        endTransform.m34 = -1.0/500.0
        
        if transitionStatus == .dismiss {
            swap(&fromVC, &toVC)
            swap(&startTransform, &endTransform)
        }
        
        anchorPointBackup = toVC?.view.layer.anchorPoint
        positionBackup = toVC?.view.layer.position
        toVC?.view.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        toVC?.view.layer.position = CGPoint(x: toVC!.view.layer.position.x + toVC!.view.layer.bounds.width / 2, y: toVC!.view.layer.position.y)
        toVC?.view.layer.transform = startTransform
        
        containView.addSubview(fromVC!.view)
        if blurEffect && (transitionStatus == .present) {
            let effectView = UIVisualEffectView(frame: fromVC!.view.frame)
            effectView.effect = UIBlurEffect(style: .dark)
            containView.addSubview(effectView)
        }
        containView.addSubview(toVC!.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            toVC?.view.layer.transform = endTransform
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                toVC?.view.layer.anchorPoint = self.anchorPointBackup ?? CGPoint(x: 0.5, y: 0.5)
                toVC?.view.layer.position = self.positionBackup ?? CGPoint(x: toVC!.view.layer.position.x, y: toVC!.view.layer.position.y - toVC!.view.layer.bounds.height / 2)
        }
    }
    
}

