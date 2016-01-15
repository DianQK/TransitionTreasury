//
//  ScanbotTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/14/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit

public class ScanbotTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    public var edgeSlidePop: Bool = false
    
    private let panGesture: UIPanGestureRecognizer?
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    init(gesture: UIPanGestureRecognizer?, status: TransitionStatus = .Push) {
        panGesture = gesture
        transitionStatus = status
        super.init()
        if panGesture != nil {
            panGesture?.addTarget(self, action: Selector("slideTransition:"))
            interacting = true
            percentTransition = UIPercentDrivenInteractiveTransition()
        }
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        toVC!.view.layer.opacity = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            toVC!.view.layer.opacity = 1
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    public func slideTransition(sender: UIPanGestureRecognizer) {

        let fromVC = transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)

        
        let view = fromVC!.view
        
        var percent = sender.translationInView(view).y / view.bounds.size.height
        
        percent = min(1.0, max(0, percent))
        
        switch sender.state {
        case .Began :
            interacting = true
            percentTransition = UIPercentDrivenInteractiveTransition()
            percentTransition?.startInteractiveTransition(transitionContext!)
            toVC!.navigationController!.tr_popViewController()
        case .Changed :
            percentTransition?.updateInteractiveTransition(percent)
        default :
            interacting = false
            if percent > interactivePrecent {
                cancelPop = false
                percentTransition?.completionSpeed = 1.0 - percentTransition!.percentComplete
                percentTransition?.finishInteractiveTransition()
            } else {
                cancelPop = true
                percentTransition?.cancelInteractiveTransition()
            }
            percentTransition = nil
        }

    }
    
}
