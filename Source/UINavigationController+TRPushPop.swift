//
//  UINavigationController+TRPushPop.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public extension UINavigationController {
    
    public func tr_pushViewController(viewcontroller: UIViewController, method: TRPushMethod, completion: (() -> Void)? = nil) {
        let transition = TRNavgationTransitionDelegate(method: method, status: .Push, gestureFor: viewcontroller)
        transition.completion = completion
        (viewcontroller as? TRTransition)?.tr_transition = transition
        delegate = transition
        pushViewController(viewcontroller, animated: true)
    }
    
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

public protocol TRTransition: class {
    var tr_transition: TRNavgationTransitionDelegate?{get set}
}
