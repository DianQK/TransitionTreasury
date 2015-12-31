//
//  UINavigationController+TRPushPop.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
// MARK: - Transition Treasury UINavgationController Extension
public extension UINavigationController {
    /**
     Transition treasury push viewController.
     */
    public func tr_pushViewController(viewController: UIViewController, method: TRPushMethod, completion: (() -> Void)? = nil) {
        let transition = TRNavgationTransitionDelegate(method: method, status: .Push, gestureFor: viewController)
        transition.completion = completion
        (viewController as? TRTransition)?.tr_transition = transition
        delegate = transition
        pushViewController(viewController, animated: true)
    }
    /**
     Transition treasury pop viewController.
     */
    public func tr_popViewController(completion: (() -> Void)? = nil) -> UIViewController? {
        let transition = (topViewController as? TRTransition)?.tr_transition
        let popViewController = topViewController
        transition?.completion = {
            completion?()
            (popViewController as? TRTransition)?.tr_transition = nil
        }
        transition?.transition.transitionStatus = .Pop
        delegate = transition
        return popViewControllerAnimated(true)
    }
    /**
     Transition treasury pop to viewController.
     */
    public func tr_popToViewController(viewController: UIViewController, completion: (() -> Void)? = nil) -> [UIViewController]? {
        guard let index = viewControllers.indexOf(viewController) else {
            fatalError("No this viewController for pop!!!")
        }
        let transition = (viewController as? TRTransition)?.tr_transition
        transition?.transition.transitionStatus = .Pop
        transition?.completion = completion
        transition?.transition.popToVCIndex(index)
        delegate = transition
        return {
            return popToViewController(viewController, animated: true)?.flatMap({ (viewController) -> UIViewController? in
                (viewController as? TRTransition)?.tr_transition = nil
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
        let transition = (viewControllers[1] as? TRTransition)?.tr_transition
        transition?.completion = completion
        transition?.transition.transitionStatus = .Pop
        transition?.transition.popToVCIndex(0)
        delegate = transition
        return {
            return popToRootViewControllerAnimated(true)?.flatMap({ (viewController) -> UIViewController? in
                (viewController as? TRTransition)?.tr_transition = nil
                return viewController
            })
            }()
    }
    
}
/// Retain transiton delegate
public protocol TRTransition: class {
    /// Transiton delegate
    var tr_transition: TRNavgationTransitionDelegate?{get set}
}
