//
//  UIViewController+TRPresent.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit

/**
 *  Enable Transition for Present.
 */
public protocol ViewControllerTransitionable: class, NSObjectProtocol {
    /// Retain transition delegate.
    var tr_presentTransition: TRViewControllerTransitionDelegate?{get set}
}

// MARK: - Transition Treasury UIViewController Extension.
public extension ViewControllerTransitionable where Self: UIViewController {
    /**
     Transition treasury present viewController.
     */
    public func tr_presentViewController(viewControllerToPresent: UIViewController, method: TransitionAnimationable, statusBarStyle: TRStatusBarStyle = .Default, completion: (() -> Void)? = nil) {
        let transitionDelegate = TRViewControllerTransitionDelegate(method: method)
        
        tr_presentTransition = transitionDelegate
        
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
    public func tr_dismissViewController(interactive interactive: Bool = false, completion: (() -> Void)? = nil) {
        let transitionDelegate = tr_presentTransition
        if var interactiveTransition = transitionDelegate?.transition as? TransitionInteractiveable {
            interactiveTransition.interacting = interactive
        }
        presentedViewController?.transitioningDelegate = transitionDelegate
        let fullCompletion = {
            completion?()
            transitionDelegate?.previousStatusBarStyle?.updateStatusBarStyle()
            self.tr_presentTransition = nil
        }
        transitionDelegate?.transition.completion = fullCompletion
        if transitionDelegate?.transition.completion != nil {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: fullCompletion)
        }
    }
}
/// Modal Transition & Delegate.
public typealias ModalTransitionDelegate = protocol<ViewControllerTransitionable,ModalViewControllerDelegate>

/**
 *  Your `MianViewController` should conform this delegate.
 */
public protocol ModalViewControllerDelegate: class, NSObjectProtocol {
    /**
     Dismiss by delegate.
     
     - parameter data: callback data
     */
    func modalViewControllerDismiss(interactive interactive: Bool, callbackData data:AnyObject?)
    func modalViewControllerDismiss(callbackData data:AnyObject?)
}


// MARK: - Implement dismiss
public extension ModalViewControllerDelegate where Self: ViewControllerTransitionable, Self: UIViewController {
    func modalViewControllerDismiss(interactive interactive: Bool = false, callbackData data:AnyObject? = nil) {
        if data != nil {
            debugPrint("WARNING: You set callbackData, but you forget implement this `modalViewControllerDismiss(_:_:)` to get data.")
        }
        tr_dismissViewController(interactive: interactive, completion: nil)
    }
    
    func modalViewControllerDismiss(callbackData data:AnyObject? = nil) {
        if data != nil {
            debugPrint("WARNING: You set callbackData, but you forget implement this `modalViewControllerDismiss(_:)` to get data.")
        }
        tr_dismissViewController(completion: nil)
    }
}