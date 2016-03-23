//
//  TRNavgationTransitionDelegate.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
/// Transition(Push & Pop) Animation Delegate Object
public class TRNavgationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    /// The transition animation object
    public var transition: TRViewControllerAnimatedTransitioning
    
    public var previousStatusBarStyle: TRStatusBarStyle?
    
    public var currentStatusBarStyle: TRStatusBarStyle?
    
    private var p_completion: (() -> Void)?
    
    /// Transition completion block
    var completion: (() -> Void)? {
        get {
            return self.transition.completion ?? p_completion
        }
        set {
            self.transition.completion = newValue
            if self.transition.completion == nil {
                p_completion = newValue
            }
        }
    }
    /// The edge gesture for pop
    lazy var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(TRNavgationTransitionDelegate.tr_edgePan(_:)))
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
    public init(method: TransitionAnimationable, status: TransitionStatus = .Push, gestureFor viewController: UIViewController?) {
        transition = method.transitionAnimation()
        super.init()
        if let transition = transition as? TransitionInteractiveable where transition.edgeSlidePop {
            viewController?.view.addGestureRecognizer(edgePanGestureRecognizer)
        }
    }
    
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push :
            transition.transitionStatus = .Push
            return transition
        case .Pop :
            transition.transitionStatus = .Pop
            return transition
        case .None :
            return nil
        }
    }
    
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        guard let transition = transition as? TransitionInteractiveable else {
            return nil
        }
        
        return transition.interacting ? transition.percentTransition : nil
    }
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        switch transition.transitionStatus {
        case .Push :
            currentStatusBarStyle?.updateStatusBarStyle()
        case .Pop :
            previousStatusBarStyle?.updateStatusBarStyle()
        default :
            fatalError("No this transition status here.")
        }
    }
    
    public func tr_edgePan(recognizer: UIPanGestureRecognizer) {
        
        let fromVC = transition.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transition.transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        guard var transition = transition as? TransitionInteractiveable else {
            return
        }
        
        let view = fromVC!.view
        
        var percent = recognizer.translationInView(view).x / view.bounds.size.width
        
        percent = min(1.0, max(0, percent))

        switch recognizer.state {
        case .Began :
            transition.interacting = true
            transition.percentTransition = UIPercentDrivenInteractiveTransition()
            transition.percentTransition?.startInteractiveTransition((transition as! TRViewControllerAnimatedTransitioning).transitionContext!)
            toVC!.navigationController!.tr_popViewController()
        case .Changed :
            transition.percentTransition?.updateInteractiveTransition(percent)
        default :
            transition.interacting = false
            if percent > transition.interactivePrecent {
                transition.cancelPop = false
                transition.percentTransition?.completionSpeed = 1.0 - transition.percentTransition!.percentComplete
                transition.percentTransition?.finishInteractiveTransition()
                fromVC?.view.removeGestureRecognizer(edgePanGestureRecognizer)
            } else {
                transition.cancelPop = true
                transition.percentTransition?.cancelInteractiveTransition()
            }
            transition.percentTransition = nil
        }
    }
}