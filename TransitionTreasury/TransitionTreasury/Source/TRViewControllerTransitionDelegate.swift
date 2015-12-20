//
//  TRViewControllerTransitionDelegate.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/// Transition(Present) Animation Delegate Object
public class TRViewControllerTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var percentTransition: UIPercentDrivenInteractiveTransition?
    
    var transition: TRViewControllerAnimatedTransitioning
    
    public init(method: TRPresentMethod, status: TransitionStatus = .Present) {
        transition = method.TransitionAnimation()
        super.init()
    }
    
    public func updateStatus(status: TransitionStatus) {
        transition.transitionStatus = status
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transition.interacting ? percentTransition : nil
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}
