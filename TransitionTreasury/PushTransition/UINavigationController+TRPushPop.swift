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
    public func tr_pushViewController<T: UIViewController>(_ viewController: T, method: TransitionAnimationable, statusBarStyle: TRStatusBarStyle = .default, completion: (() -> Void)? = nil) where T: NavgationTransitionable {
        let transitionDelegate = TRNavgationTransitionDelegate(method: method, status: .push, gestureFor: viewController)
        transitionDelegate.completion = completion
        viewController.tr_pushTransition = transitionDelegate
        
        delegate = transitionDelegate
        transitionDelegate.previousStatusBarStyle = TRStatusBarStyle.currentlyTRStatusBarStyle()
        transitionDelegate.currentStatusBarStyle = statusBarStyle
        pushViewController(viewController, animated: true)
    }
    /**
     Transition treasury pop viewController.
     */
    @discardableResult
    public func tr_popViewController(_ completion: (() -> Void)? = nil) -> UIViewController? {
        let transitionDelegate = (topViewController as? NavgationTransitionable)?.tr_pushTransition
        transitionDelegate?.completion = { [weak self] in
            completion?()
            (self?.topViewController as? NavgationTransitionable)?.tr_pushTransition = nil
        }
        delegate = transitionDelegate
        
        return popViewController(animated: true)
    }
    /**
     Transition treasury pop to viewController.
     */
    public func tr_popToViewController<T: UIViewController>(_ viewController: T, completion: (() -> Void)? = nil) -> [UIViewController]? where T: NavgationTransitionable {
        guard let index = viewControllers.index(of: viewController) else {
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
    public func tr_popToRootViewController(_ completion: (() -> Void)? = nil) -> [UIViewController]? {
        guard viewControllers.count > 1 else {
            return popToRootViewController(animated: true)
        }
        let transitionDelegate = (viewControllers[1] as? NavgationTransitionable)?.tr_pushTransition
        transitionDelegate?.completion = completion
        transitionDelegate?.transition.popToVCIndex(0)
        delegate = transitionDelegate
        return {
            popToRootViewController(animated: true)?.flatMap({ (viewController) -> UIViewController? in
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
