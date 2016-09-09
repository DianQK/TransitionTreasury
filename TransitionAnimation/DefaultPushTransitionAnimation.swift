//
//  DefaultPushTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/24.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Apple Default Push Transition
public class DefaultPushTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var completion: (() -> Void)?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    private var shadowOpacityBackup: Float?
    private var shadowOffsetBackup: CGSize?
    private var shadowRadiusBackup: CGFloat?
    private var shadowPathBackup: CGPath?
    
    public init(status: TransitionStatus = .push) {
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containView = transitionContext.containerView
        
        var fromVCStartX: CGFloat = 0
        var fromVCEndX = -UIScreen.main.bounds.width/3
        
        var toVCStartX = UIScreen.main.bounds.width
        var toVCEndX: CGFloat = 0
        
        if transitionStatus == .pop {
            swap(&fromVC, &toVC)
            swap(&fromVCStartX, &fromVCEndX)
            swap(&toVCStartX, &toVCEndX)
        }
        
        containView.addSubview(fromVC!.view)
        containView.addSubview(toVC!.view)
        
        fromVC?.view.frame.origin.x = fromVCStartX
        
        toVC?.view.frame.origin.x = toVCStartX
        shadowOpacityBackup = toVC?.view.layer.shadowOpacity
        shadowOffsetBackup = toVC?.view.layer.shadowOffset
        shadowRadiusBackup = toVC?.view.layer.shadowRadius
        shadowPathBackup = toVC?.view.layer.shadowPath
        toVC?.view.layer.shadowOpacity = 0.3
        toVC?.view.layer.shadowOffset = CGSize(width: -3, height: 0)
        toVC?.view.layer.shadowRadius = 5
        toVC?.view.layer.shadowPath = CGPath(rect: toVC!.view.layer.bounds, transform: nil)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromVC?.view.frame.origin.x = fromVCEndX
            toVC?.view.frame.origin.x = toVCEndX
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !self.cancelPop {
                    toVC?.view.layer.shadowOpacity = 0
                    if finished {
                        toVC?.view.layer.shadowOpacity = self.shadowOpacityBackup ?? 0
                        toVC?.view.layer.shadowOffset = self.shadowOffsetBackup ?? CGSize(width: 0, height: 0)
                        toVC?.view.layer.shadowRadius = self.shadowRadiusBackup ?? 0
                        toVC?.view.layer.shadowPath = self.shadowPathBackup ?? CGPath(rect: CGRect.zero, transform: nil)
                        self.completion?()
                        self.completion = nil
                    }
                }
                self.cancelPop = false
        }
    }
    
}
