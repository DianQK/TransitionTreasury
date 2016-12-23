//
//  BlixtTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/1/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury

open class BlixtTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    open var keyView: UIView
    
    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    open var percentTransition: UIPercentDrivenInteractiveTransition?
    
    open var completion: (() -> Void)?
    
    open var cancelPop: Bool = false
    
    open var interacting: Bool = false
    
    open let toFrame: CGRect
    
    fileprivate lazy var keyViewCopy: UIView = self.keyView.tr_copyWithSnapshot()
    
    public init(key: UIView, toFrame frame:CGRect, status: TransitionStatus = .push) {
        keyView = key
        toFrame = frame
        transitionStatus = status
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containView = transitionContext.containerView
        
        let leftX: CGFloat = 0
        let rightX = UIScreen.main.bounds.width
        
        fromVC?.view.layer.frame.origin.x = leftX
        toVC?.view.layer.frame.origin.x = transitionStatus == .push ? rightX : -rightX
        
        containView.addSubview(fromVC!.view)
        containView.addSubview(toVC!.view)
        containView.tr_addSubview(keyViewCopy, convertFrom: (transitionStatus == .push ? keyView : keyViewCopy))
        keyView.layer.opacity = 0
        
        func bounce(_ completion: (() -> Void)? = nil) {
            UIView.animate(withDuration: 0.1) {
                self.keyViewCopy.frame = containView.convert(self.keyView.frame.tr_shape(0.97), from: self.keyView.superview)
            }
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: {
                self.keyViewCopy.frame = containView.convert(self.keyView.frame, from: self.keyView.superview)
                }) { finished in
                    completion?()
            }
        }
        
        if transitionStatus == .push {
            bounce()
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext) - 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
            switch self.transitionStatus {
            case .push :
                fromVC?.view.layer.frame.origin.x = -rightX
                toVC?.view.layer.frame.origin.x = leftX
                self.keyViewCopy.frame = self.toFrame
            case .pop :
                fromVC?.view.layer.frame.origin.x = rightX
                toVC?.view.layer.frame.origin.x = leftX
                self.keyViewCopy.frame = containView.convert(self.keyView.frame, from: self.keyView.superview)
            default :
                fatalError("You set false status.")
            }
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if finished && !self.cancelPop {
                    toVC?.view.addSubview(self.keyViewCopy)
                    if self.transitionStatus == .pop {
                        self.keyView.layer.opacity = 1
                        self.keyViewCopy.removeFromSuperview()
                        
                    }
                    self.completion?()
                    self.completion = nil
                }
            self.cancelPop = false
        }
    }
    
}

