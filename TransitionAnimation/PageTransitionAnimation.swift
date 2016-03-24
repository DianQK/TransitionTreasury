//
//  PageTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Page Motion
public class PageTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var completion: (() -> Void)?

    public var cancelPop: Bool = false

    public var interacting: Bool = false
    
    private var transformBackup: CATransform3D?
    private var shadowOpacityBackup: Float?
    private var shadowOffsetBackup: CGSize?
    private var shadowRadiusBackup: CGFloat?
    private var shadowPathBackup: CGPath?
    
    private lazy var maskView: UIView = {
        let maskView = UIView(frame: UIScreen.mainScreen().bounds)
        maskView.backgroundColor = UIColor.blackColor()
        return maskView
    }()
    
    public init(status: TransitionStatus = .Push) {
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        var startPositionX: CGFloat = UIScreen.mainScreen().bounds.width
        var endPositionX: CGFloat = 0
        
        var startOpacity: Float = 0
        var endOpacity: Float = 0.3
        
        transformBackup = transformBackup ?? fromVC?.view.layer.transform
        
        var transform3D: CATransform3D = CATransform3DIdentity
        transform3D.m34 = -1.0/500.0
        
        if transitionStatus == .Pop {
            swap(&fromVC, &toVC)
            swap(&startPositionX, &endPositionX)
            swap(&startOpacity, &endOpacity)
        } else {
            transform3D = CATransform3DTranslate(transform3D, 0, 0, -35)
        }
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
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
        toVC?.view.layer.shadowPath = CGPathCreateWithRect(toVC!.view.layer.bounds, nil)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            self.maskView.layer.opacity = endOpacity
            fromVC?.view.layer.transform = transform3D
            toVC?.view.layer.position.x = endPositionX + toVC!.view.layer.bounds.width / 2
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if !self.cancelPop {
                    toVC?.view.layer.shadowOpacity = 0
                    if self.transitionStatus == .Pop && finished && !self.cancelPop {
                        self.maskView.removeFromSuperview()
                        fromVC?.view.layer.transform = self.transformBackup ?? CATransform3DIdentity
                    }
                    if finished {
                        toVC?.view.layer.shadowOpacity = self.shadowOpacityBackup ?? 0
                        toVC?.view.layer.shadowOffset = self.shadowOffsetBackup ?? CGSize(width: 0, height: 0)
                        toVC?.view.layer.shadowRadius = self.shadowRadiusBackup ?? 0
                        toVC?.view.layer.shadowPath = self.shadowPathBackup ?? CGPathCreateWithRect(CGRectZero, nil)
                        self.completion?()
                        self.completion = nil
                    }
                }
                self.cancelPop = false
        }
    }
    
}
