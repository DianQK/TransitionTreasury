//
//  PopTipTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/29/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Pop Your Tip ViewController.
public class PopTipTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    private var mainVC: UIViewController?
    
    lazy private var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopTipTransitionAnimation.tapDismiss(_:)))
        return tap
    }()
    
    lazy private var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
    public private(set) var visibleHeight: CGFloat
    
    private let bounce: Bool
    
    public init(visibleHeight height: CGFloat, bounce: Bool = false, status: TransitionStatus = .Present) {
        transitionStatus = status
        visibleHeight = height
        self.bounce = bounce
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
        
        var startFrame = CGRectOffset(screenBounds, 0, screenBounds.size.height)
        var finalFrame = CGRectOffset(screenBounds, 0, screenBounds.height - visibleHeight)
        
        var startOpacity: CGFloat = 0
        var finalOpacity: CGFloat = 0.3
        
        containView?.addSubview(fromVC!.view)
        
        if transitionStatus == .Dismiss {
            swap(&fromVC, &toVC)
            swap(&startFrame, &finalFrame)
            swap(&startOpacity, &finalOpacity)
        } else if transitionStatus == .Present {
            let bottomView = UIView(frame: screenBounds)
            bottomView.layer.contents = {
                let scale = UIScreen.mainScreen().scale
                UIGraphicsBeginImageContextWithOptions(fromVC!.view.bounds.size, true, scale)
                fromVC!.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image.CGImage
                }()
            bottomView.addGestureRecognizer(tapGestureRecognizer)
            containView?.addSubview(bottomView)
            maskView.frame = screenBounds
            maskView.alpha = startOpacity
            bottomView.addSubview(maskView)
            mainVC = fromVC
        }
        
        toVC?.view.layer.frame = startFrame
        
        containView?.addSubview(toVC!.view)
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: (bounce ? 0.8 : 1), initialSpringVelocity: (bounce ? 0.6 : 1), options: .CurveEaseInOut, animations: {
            toVC?.view.layer.frame = finalFrame
            self.maskView.alpha = finalOpacity
            }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    
    }
    
    func tapDismiss(tap: UITapGestureRecognizer) {
        mainVC?.presentedViewController?.transitioningDelegate = nil
        mainVC?.dismissViewControllerAnimated(true, completion: nil)
    }
}


