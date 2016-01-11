//
//  UIViewController+TRPresent.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
// MARK: - Transition Treasury UIViewController Extension.
public extension UIViewController {
    /**
     Transition treasury present viewController.
     */
    public func tr_presentViewController(viewControllerToPresent: UIViewController, method: TRPresentMethod, statusBarStyle: TRStatusBarStyle = .Default, completion: (() -> Void)? = nil) {
        let transitionDelegate = TRViewControllerTransitionDelegate(method: method)
        (self as? ModalViewControllerDelegate)?.tr_transition = transitionDelegate
        viewControllerToPresent.transitioningDelegate = transitionDelegate
        transitionDelegate.transition.completion = completion
        if transitionDelegate.transition.completion != nil { // Choose who deal completion
            presentViewController(viewControllerToPresent, animated: true, completion: nil)
        } else {
            presentViewController(viewControllerToPresent, animated: true, completion: completion)
        }
        transitionDelegate.transition.previousStatusBarStyle = TRStatusBarStyle.CurrentlyTRStatusBarStyle()
        guard transitionDelegate.transition.previousStatusBarStyle != nil else {
            debugPrint("WARNING: This animation not support update status bar style.")
            return
        }
        statusBarStyle.updateStatusBarStyle()
    }
    /**
     Transition treasury dismiss VvewController.
     */
    public func tr_dismissViewController(completion: (() -> Void)? = nil) {
        let transition = (self as? ModalViewControllerDelegate)?.tr_transition
        transition?.transition.transitionStatus = .Dismiss
        presentedViewController?.transitioningDelegate = transition
        let fullCompletion = {
            completion?()
            (self as? ModalViewControllerDelegate)?.tr_transition = nil
        }
        transition?.transition.completion = fullCompletion
        if transition?.transition.completion != nil {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: fullCompletion)
        }
        transition?.transition.previousStatusBarStyle?.updateStatusBarStyle()
    }
}
/**
 *  Your `MianViewController` should conform this delegate.
 */
public protocol ModalViewControllerDelegate: class, NSObjectProtocol {
    /// Retain transition delegate.
    var tr_transition: TRViewControllerTransitionDelegate?{get set}
    /**
     Dismiss by delegate.
     
     - parameter data: callback data
     */
    func modalViewControllerDismiss(callbackData data:AnyObject?)
}
// MARK: - Implement dismiss
public extension ModalViewControllerDelegate where Self:UIViewController  {
    func modalViewControllerDismiss(callbackData data:AnyObject? = nil) {
        if data != nil {
            debugPrint("WARNING: You set callbackData, but you forget implement this `modalViewControllerDismiss(_:)` to get data.")
        }
        tr_dismissViewController()
    }
}
/**
 *  Your `ModalViewController` should conform this delegate.
 */
public protocol MainViewControllerDelegate: class, NSObjectProtocol {
    /// Delegate for call dismiss.
    weak var modalDelegate: ModalViewControllerDelegate?{get set}
}


