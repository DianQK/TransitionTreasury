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
        transitionDelegate.previousStatusBarStyle = TRStatusBarStyle.CurrentlyTRStatusBarStyle()
        let fullCompletion = {
            completion?()
            statusBarStyle.updateStatusBarStyle()
        }
        transitionDelegate.transition.completion = fullCompletion
        /**
        *  http://stackoverflow.com/questions/20320591/uitableview-and-presentviewcontroller-takes-2-clicks-to-display
        */
        /**
        *  http://stackoverflow.com/questions/21075540/presentviewcontrolleranimatedyes-view-will-not-appear-until-user-taps-again
        */
        dispatch_async(dispatch_get_main_queue(), {
            if transitionDelegate.transition.completion != nil { // Choose who deal completion
                self.presentViewController(viewControllerToPresent, animated: true, completion: nil)
            } else {
                self.presentViewController(viewControllerToPresent, animated: true, completion: fullCompletion)
            }
            });
    }
    /**
     Transition treasury dismiss ViewController.
     */
    public func tr_dismissViewController(completion: (() -> Void)? = nil) {
        let transitionDelegate = (self as? ModalViewControllerDelegate)?.tr_transition
        transitionDelegate?.transition.transitionStatus = .Dismiss
        presentedViewController?.transitioningDelegate = transitionDelegate
        let fullCompletion = {
            completion?()
            transitionDelegate?.previousStatusBarStyle?.updateStatusBarStyle()
            (self as? ModalViewControllerDelegate)?.tr_transition = nil
        }
        transitionDelegate?.transition.completion = fullCompletion
        if transitionDelegate?.transition.completion != nil {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: fullCompletion)
        }
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


