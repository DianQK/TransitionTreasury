//
//  QKTransitionDelegate.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/15/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit

public class QKTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var percentTransition: UIPercentDrivenInteractiveTransition?
    
    var transition: QKViewControllerAnimatedTransitioning
    
    public init(method: QKPresentMethod, status: TransitionStatus = .Present) {
        transition = QKCreatePresentTransition(method, status: status)
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
