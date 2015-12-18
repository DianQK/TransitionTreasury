//
//  QKNavgationAnimation.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/12/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit

public class QKNavgationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    var percentTransition: UIPercentDrivenInteractiveTransition?
    
    var transition: QKViewControllerAnimatedTransitioning
    
    var completion: (() -> Void)? {
        get {
            return self.transition.completion
        }
        set {
            self.transition.completion = newValue
        }
    }
    
    lazy public var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("edgePan:"))
        edgePanGestureRecognizer.edges = .Left
        return edgePanGestureRecognizer
    }()
    
    public init(method: QKKeyPushMethod, key: UIView?, status: TransitionStatus, gestureFor viewcontroller: UIViewController?) {
        transition = QKCreateKeyPushTransition(method, key: key, status: status)
        super.init()
        viewcontroller?.view.addGestureRecognizer(edgePanGestureRecognizer)
    }
    
    public func updateStatus(key: UIView, status: TransitionStatus,  gestureFor viewcontroller: UIViewController) {
        transition.keyView = key
        transition.transitionStatus = status
        viewcontroller.view.addGestureRecognizer(edgePanGestureRecognizer)
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
        print(percent)
        switch recognizer.state {
        case .Began :
            transition.interacting = true
            percentTransition = UIPercentDrivenInteractiveTransition()
            percentTransition!.startInteractiveTransition(transition.transitionContext!)
            //fromVC 获取不到 navVC ，第二次返回必现 此时 fromVC 已经从 nav 移除了
            toVC!.navigationController!.qk_popViewController()
        case .Changed :
            percentTransition?.updateInteractiveTransition(percent)
        default :
            transition.interacting = false
            if percent > 0.3 {
                transition.cancelPop = false
                percentTransition!.completionSpeed = 1.0 - percentTransition!.percentComplete
                percentTransition?.finishInteractiveTransition()
                fromVC?.view.removeGestureRecognizer(edgePanGestureRecognizer)
//                toVC?.view.addGestureRecognizer(edgePanGestureRecognizer)
            } else {
                transition.cancelPop = true
                percentTransition?.cancelInteractiveTransition()
            }
            percentTransition = nil
        }
    }
}