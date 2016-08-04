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
    public init(method: TransitionAnimationable, status: TransitionStatus = .present) {
        transition = method.transitionAnimation()
        super.init()
    }
    /**
     Update transition status
     
     - parameter status: .Present or .dismiss
     */
    public func updateStatus(_ status: TransitionStatus) {
        transition.transitionStatus = status
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionStatus = .present
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionStatus = .dismiss
        return transition
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transition = transition as? TransitionInteractiveable else {
            return nil
        }
        return transition.interacting ? transition.percentTransition : nil
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transition = transition as? TransitionInteractiveable else {
            return nil
        }
        return transition.interacting ? transition.percentTransition : nil
    }
    
}
