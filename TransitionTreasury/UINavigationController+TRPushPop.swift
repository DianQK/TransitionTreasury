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
    public func tr_pushViewController(viewController: UIViewController, method: TRPushMethod, statusBarStyle: TRStatusBarStyle = .Default, completion: (() -> Void)? = nil) {
        let transitionDelegate = TRNavgationTransitionDelegate(method: method, status: .Push, gestureFor: viewController)
        transitionDelegate.completion = completion
        (viewController as? TRTransition)?.tr_transition = transitionDelegate
        delegate = transitionDelegate
        pushViewController(viewController, animated: true)
        transitionDelegate.transition.previousStatusBarStyle = TRStatusBarStyle.CurrentlyTRStatusBarStyle()
        guard transitionDelegate.transition.previousStatusBarStyle != nil else {
            debugPrint("WARNING: This animation not support update status bar style.")
            return
        }
        statusBarStyle.updateStatusBarStyle()
    }
    /**
     Transition treasury pop viewController.
     */
    public func tr_popViewController(completion: (() -> Void)? = nil) -> UIViewController? {
        let transitionDelegate = (topViewController as? TRTransition)?.tr_transition
        let popViewController = topViewController
        transitionDelegate?.completion = {
            completion?()
            (popViewController as? TRTransition)?.tr_transition = nil
        }
        transitionDelegate?.transition.transitionStatus = .Pop
        delegate = transitionDelegate
        transitionDelegate?.transition.previousStatusBarStyle?.updateStatusBarStyle()
        return popViewControllerAnimated(true)
    }
    /**
     Transition treasury pop to viewController.
     */
    public func tr_popToViewController(viewController: UIViewController, completion: (() -> Void)? = nil) -> [UIViewController]? {
        guard let index = viewControllers.indexOf(viewController) else {
            fatalError("No this viewController for pop!!!")
        }
        let transitionDelegate = (viewController as? TRTransition)?.tr_transition
        transitionDelegate?.transition.transitionStatus = .Pop
        transitionDelegate?.completion = completion
        transitionDelegate?.transition.popToVCIndex(index)
        delegate = transitionDelegate
        transitionDelegate?.transition.previousStatusBarStyle?.updateStatusBarStyle()
        return {
            popToViewController(viewController, animated: true)?.flatMap({ (viewController) -> UIViewController? in
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
        let transitionDelegate = (viewControllers[1] as? TRTransition)?.tr_transition
        transitionDelegate?.completion = completion
        transitionDelegate?.transition.transitionStatus = .Pop
        transitionDelegate?.transition.popToVCIndex(0)
        delegate = transitionDelegate
        transitionDelegate?.transition.previousStatusBarStyle?.updateStatusBarStyle()
        return {
            popToRootViewControllerAnimated(true)?.flatMap({ (viewController) -> UIViewController? in
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
