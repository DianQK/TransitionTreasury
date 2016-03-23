//
//  UINavigationController+TRPushPop.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
// MARK: - Transition Treasury UINavgationController Extension
public extension UINavigationController {
    /**
     Transition treasury push viewController.
     */
    public func tr_pushViewController<T: UIViewController where T: NavgationTransitionable>(viewController: T, method: TransitionAnimationable, statusBarStyle: TRStatusBarStyle = .Default, completion: (() -> Void)? = nil) {
        let transitionDelegate = TRNavgationTransitionDelegate(method: method, status: .Push, gestureFor: viewController)
        transitionDelegate.completion = completion
        viewController.tr_pushTransition = transitionDelegate
        
        delegate = transitionDelegate
        transitionDelegate.previousStatusBarStyle = TRStatusBarStyle.CurrentlyTRStatusBarStyle()
        transitionDelegate.currentStatusBarStyle = statusBarStyle
        pushViewController(viewController, animated: true)
    }
    /**
     Transition treasury pop viewController.
     */
    public func tr_popViewController(completion: (() -> Void)? = nil) -> UIViewController? {
        let transitionDelegate = (topViewController as? NavgationTransitionable)?.tr_pushTransition
        let popViewController = topViewController
        transitionDelegate?.completion = {
            completion?()
            (popViewController as? NavgationTransitionable)?.tr_pushTransition = nil
        }
        delegate = transitionDelegate
        return popViewControllerAnimated(true)
    }
    /**
     Transition treasury pop to viewController.
     */
    public func tr_popToViewController<T: UIViewController where T: NavgationTransitionable>(viewController: T, completion: (() -> Void)? = nil) -> [UIViewController]? {
        guard let index = viewControllers.indexOf(viewController) else {
            fatalError("No this viewController for pop!!!")
        }
        let transitionDelegate = viewController.tr_pushTransition
        transitionDelegate?.completion = completion
        transitionDelegate?.transition.popToVCIndex(index)
        delegate = transitionDelegate
        return {
            popToViewController(viewController, animated: true)?.flatMap({ (viewController) -> UIViewController? in
                (viewController as? NavgationTransitionable)?.tr_pushTransition = nil
                return viewController
            })
            }()
    }
    /**
     Transition Treasury Pop to Root ViewController.
     */
    public func tr_popToRootViewController(completion: (() -> Void)? = nil) -> [UIViewController]? {
        guard viewControllers.count > 1 else {
            return popToRootViewControllerAnimated(true)
        }
        let transitionDelegate = (viewControllers[1] as? NavgationTransitionable)?.tr_pushTransition
        transitionDelegate?.completion = completion
        transitionDelegate?.transition.popToVCIndex(0)
        delegate = transitionDelegate
        return {
            popToRootViewControllerAnimated(true)?.flatMap({ (viewController) -> UIViewController? in
                (viewController as? NavgationTransitionable)?.tr_pushTransition = nil
                return viewController
            })
            }()
    }
    
}
/// Retain transiton delegate
public protocol NavgationTransitionable: class {
    /// Transiton delegate
    var tr_pushTransition: TRNavgationTransitionDelegate?{get set}
}
