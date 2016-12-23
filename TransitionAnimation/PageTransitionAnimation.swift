//
//  PageTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Page Motion
open class PageTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    open var percentTransition: UIPercentDrivenInteractiveTransition?
    
    open var completion: (() -> Void)?

    open var cancelPop: Bool = false

    open var interacting: Bool = false
    
    fileprivate var transformBackup: CATransform3D?
    fileprivate var shadowOpacityBackup: Float?
    fileprivate var shadowOffsetBackup: CGSize?
    fileprivate var shadowRadiusBackup: CGFloat?
    fileprivate var shadowPathBackup: CGPath?
    
    fileprivate lazy var maskView: UIView = {
        let maskView = UIView(frame: UIScreen.main.bounds)
        maskView.backgroundColor = UIColor.black
        return maskView
    }()
    
    public init(status: TransitionStatus = .push) {
        transitionStatus = status
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containView = transitionContext.containerView
        
        var startPositionX: CGFloat = UIScreen.main.bounds.width
        var endPositionX: CGFloat = 0
        
        var startOpacity: Float = 0
        var endOpacity: Float = 0.3
        
        transformBackup = transformBackup ?? fromVC?.view.layer.transform
        
        var transform3D: CATransform3D = CATransform3DIdentity
        transform3D.m34 = -1.0/500.0
        
        if transitionStatus == .pop {
            swap(&fromVC, &toVC)
            swap(&startPositionX, &endPositionX)
            swap(&startOpacity, &endOpacity)
        } else {
            transform3D = CATransform3DTranslate(transform3D, 0, 0, -35)
        }
        
        containView.addSubview(fromVC!.view)
        containView.addSubview(toVC!.view)
        fromVC?.view.addSubview(maskView)
        
        maskView.layer.opacity = startOpacity
        toVC?.view.layer.position.x = startPositionX + toVC!.view.layer.bounds.width / 2
        shadowOpacityBackup = toVC?.view.layer.shadowOpacity
        shadowOffsetBackup = toVC?.view.layer.shadowOffset
        shadowRadiusBackup = toVC?.view.layer.shadowRadius
        shadowPathBackup = toVC?.view.layer.shadowPath
        toVC?.view.layer.shadowOpacity = 0.5
        toVC?.view.layer.shadowOffset = CGSize(width: -3, height: 0)
        toVC?.view.layer.shadowRadius = 5
        toVC?.view.layer.shadowPath = CGPath(rect: toVC!.view.layer.bounds, transform: nil)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            self.maskView.layer.opacity = endOpacity
            fromVC?.view.layer.transform = transform3D
            toVC?.view.layer.position.x = endPositionX + toVC!.view.layer.bounds.width / 2
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !self.cancelPop {
                    toVC?.view.layer.shadowOpacity = 0
                    if self.transitionStatus == .pop && finished && !self.cancelPop {
                        self.maskView.removeFromSuperview()
                        fromVC?.view.layer.transform = self.transformBackup ?? CATransform3DIdentity
                    }
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
