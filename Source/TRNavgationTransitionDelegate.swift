//
//  TRNavgationTransitionDelegate.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/// Transition(Push & Pop) Animation Delegate Object
public class TRNavgationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    /// Control transition precent
    var percentTransition: UIPercentDrivenInteractiveTransition?
    /// The transition animation object
    var transition: TRViewControllerAnimatedTransitioning
    /// Transition completion block
    var completion: (() -> Void)? {
        get {
            return self.transition.completion
        }
        set {
            self.transition.completion = newValue
        }
    }
    /// The edge gesture for pop
    lazy public var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("edgePan:"))
        edgePanGestureRecognizer.edges = .Left
        return edgePanGestureRecognizer
    }()
    /**
     Init method
     
     - parameter method:         the push method
     - parameter status:         default is .Push
     - parameter viewController: for edge gesture
     
     - returns: Transition Animation Delegate Object
     */
    public init(method: TRPushMethod, status: TransitionStatus = .Push, gestureFor viewController: UIViewController?) {
        transition = method.transitionAnimation()
        super.init()
        viewController?.view.addGestureRecognizer(edgePanGestureRecognizer)
    }
    
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push {
            return transition
        } else if operation == .Pop {
            return transition
        } else {
            return nil
        }
    }
    
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transition.interacting ? percentTransition : nil
    }
    
    public func edgePan(recognizer: UIPanGestureRecognizer) {
        
        let fromVC = transition.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transition.transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let view = fromVC!.view
        
        var percent = recognizer.translationInView(view).x / view.bounds.size.width
        
        percent = min(1.0, max(0, percent))

        switch recognizer.state {
        case .Began :
            transition.interacting = true
            percentTransition = UIPercentDrivenInteractiveTransition()
            percentTransition!.startInteractiveTransition(transition.transitionContext!)
            toVC!.navigationController!.tr_popViewController()
        case .Changed :
            percentTransition?.updateInteractiveTransition(percent)
        default :
            transition.interacting = false
            if percent > transition.interactivePrecent {
                transition.cancelPop = false
                percentTransition!.completionSpeed = 1.0 - percentTransition!.percentComplete
                percentTransition?.finishInteractiveTransition()
                fromVC?.view.removeGestureRecognizer(edgePanGestureRecognizer)
            } else {
                transition.cancelPop = true
                percentTransition?.cancelInteractiveTransition()
            }
            percentTransition = nil
        }
    }
}
