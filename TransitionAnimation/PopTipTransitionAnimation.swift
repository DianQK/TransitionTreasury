//
//  PopTipTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/29/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Pop Your Tip ViewController.
open class PopTipTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    open var cancelPop: Bool = false
    
    open var interacting: Bool = false
    
    fileprivate var mainVC: UIViewController?
    
    lazy fileprivate var tapGestureRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(PopTipTransitionAnimation.tapDismiss(_:)))
        return tap
    }()
    
    lazy fileprivate var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    open fileprivate(set) var visibleHeight: CGFloat
    
    fileprivate let bounce: Bool
    
    public init(visibleHeight height: CGFloat, bounce: Bool = false, status: TransitionStatus = .present) {
        transitionStatus = status
        visibleHeight = height
        self.bounce = bounce
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
        
        var startFrame = screenBounds.offsetBy(dx: 0, dy: screenBounds.size.height)
        var finalFrame = screenBounds.offsetBy(dx: 0, dy: screenBounds.height - visibleHeight)
        
        var startOpacity: CGFloat = 0
        var finalOpacity: CGFloat = 0.3
        
        containView.addSubview(fromVC!.view)
        
        if transitionStatus == .dismiss {
            swap(&fromVC, &toVC)
            swap(&startFrame, &finalFrame)
            swap(&startOpacity, &finalOpacity)
        } else if transitionStatus == .present {
            let bottomView = UIView(frame: screenBounds)
            bottomView.layer.contents = {
                let scale = UIScreen.main.scale
                UIGraphicsBeginImageContextWithOptions(fromVC!.view.bounds.size, true, scale)
                fromVC!.view.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image?.cgImage
                }()
            bottomView.addGestureRecognizer(tapGestureRecognizer)
            containView.addSubview(bottomView)
            maskView.frame = screenBounds
            maskView.alpha = startOpacity
            bottomView.addSubview(maskView)
            mainVC = fromVC
        }
        
        toVC?.view.layer.frame = startFrame
        
        containView.addSubview(toVC!.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: (bounce ? 0.8 : 1), initialSpringVelocity: (bounce ? 0.6 : 1), options: .curveEaseInOut, animations: {
            toVC?.view.layer.frame = finalFrame
            self.maskView.alpha = finalOpacity
            }) { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    
    }
    
    func tapDismiss(_ tap: UITapGestureRecognizer) {
        mainVC?.presentedViewController?.transitioningDelegate = nil
        mainVC?.dismiss(animated: true, completion: nil)
    }
}


