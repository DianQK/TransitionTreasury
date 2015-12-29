//
//  UIViewController+TRPresent.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public func tr_presentViewController(viewControllerToPresent: UIViewController, method: TRPresentMethod, completion: (() -> Void)? = nil) {
        let transitionDelegate = TRViewControllerTransitionDelegate(method: method)
        (self as? ModalViewControllerDelegate)?.tr_transition = transitionDelegate
        viewControllerToPresent.transitioningDelegate = transitionDelegate
        transitionDelegate.transition.completion = completion
        if transitionDelegate.transition.completion != nil { // Choose who deal completion
            presentViewController(viewControllerToPresent, animated: true, completion: nil)
        } else {
            presentViewController(viewControllerToPresent, animated: true, completion: completion)
        }
    }
    
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
    }
}

public protocol ModalViewControllerDelegate: class, NSObjectProtocol {
    var tr_transition: TRViewControllerTransitionDelegate?{get set}

    func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>?)
}

public extension ModalViewControllerDelegate where Self:UIViewController  {
    
    func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>? = nil) {
        tr_dismissViewController()
    }
}

public protocol MainViewControllerDelegate: class, NSObjectProtocol {
    
    weak var modalDelegate: ModalViewControllerDelegate?{get set}
}


