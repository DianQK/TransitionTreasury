//
//  BlixtTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/1/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit

public class BlixtTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var keyView: UIView
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var completion: (() -> Void)?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    public let toFrame: CGRect
    
    private lazy var keyViewCopy: UIView = {
        let view = self.keyView.snapshotViewAfterScreenUpdates(false)
        view.frame = self.keyView.frame
        return view
    }()
    
    init(key: UIView, toFrame frame:CGRect, status: TransitionStatus = .Push) {
        keyView = key
        toFrame = frame
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        let leftX: CGFloat = 0
        let rightX = UIScreen.mainScreen().bounds.width
        
        fromVC?.view.layer.frame.origin.x = leftX
        toVC?.view.layer.frame.origin.x = transitionStatus == .Push ? rightX : -rightX
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        containView?.addSubview(keyViewCopy)
        keyView.layer.opacity = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            switch self.transitionStatus! {
            case .Push :
                fromVC?.view.layer.frame.origin.x = -rightX
                toVC?.view.layer.frame.origin.x = leftX
                self.keyViewCopy.frame = self.toFrame
            case .Pop :
                fromVC?.view.layer.frame.origin.x = rightX
                toVC?.view.layer.frame.origin.x = leftX
                self.keyViewCopy.frame = self.keyView.frame
            default :
                fatalError("You set false status.")
            }
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if finished && !self.cancelPop {
                    toVC?.view.addSubview(self.keyViewCopy)
                    if self.transitionStatus == .Pop {
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

