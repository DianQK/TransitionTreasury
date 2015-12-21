//
//  UIViewController+TRPresent.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public func tr_presentViewController(viewControllerToPresent: UIViewController, method: TRPresentMethod) {
        tr_presentViewController(viewControllerToPresent, method: method, completion: nil)
    }
    
    public func tr_presentViewController(viewControllerToPresent: UIViewController, method: TRPresentMethod, completion: (() -> Void)?) {
        let transitionDelegate = TRViewControllerTransitionDelegate(method: method)
        (self as? ModalViewControllerDelegate)?.tr_transition = transitionDelegate
        viewControllerToPresent.transitioningDelegate = transitionDelegate
        presentViewController(viewControllerToPresent, animated: true, completion: completion)
    }
    
    public func tr_dismissViewController() {
        tr_dismissViewController(nil)
    }
    
    public func tr_dismissViewController(completion: (() -> Void)?) {
        let transition = (self as? ModalViewControllerDelegate)?.tr_transition
        transition?.transition.transitionStatus = .Dismiss
        presentedViewController?.transitioningDelegate = transition
        (self as? ModalViewControllerDelegate)?.tr_transition = nil
        dismissViewControllerAnimated(true, completion: completion)
    }
}

public protocol ModalViewControllerDelegate: class, NSObjectProtocol {
    var tr_transition: TRViewControllerTransitionDelegate?{get set}

    func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>)
}

public extension ModalViewControllerDelegate where Self:UIViewController  {
    
    func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>) {
        tr_dismissViewController()
    }
}

public protocol MainViewControllerDelegate: class, NSObjectProtocol {
    
    weak var modalDelegate: ModalViewControllerDelegate?{get set}
}


