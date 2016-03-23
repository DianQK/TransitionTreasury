//
//  TRViewControllerTransitionDelegate.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
/// Transition(Present) Animation Delegate Object
public class TRViewControllerTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    /// The transition animation object
    public var transition: TRViewControllerAnimatedTransitioning
    
    public var previousStatusBarStyle: TRStatusBarStyle?
    /**
     Init method
     
     - parameter method: the present method option
     - parameter status: default is .Present
     
     - returns: Transition Animation Delegate Object
     */
    public init(method: TransitionAnimationable, status: TransitionStatus = .Present) {
        transition = method.transitionAnimation()
        super.init()
    }
    /**
     Update transition status
     
     - parameter status: .Present or .Dismiss
     */
    public func updateStatus(status: TransitionStatus) {
        transition.transitionStatus = status
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionStatus = .Present
        return transition
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionStatus = .Dismiss
        return transition
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transition = transition as? TransitionInteractiveable else {
            return nil
        }
        return transition.interacting ? transition.percentTransition : nil
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transition = transition as? TransitionInteractiveable else {
            return nil
        }
        return transition.interacting ? transition.percentTransition : nil
    }
    
}