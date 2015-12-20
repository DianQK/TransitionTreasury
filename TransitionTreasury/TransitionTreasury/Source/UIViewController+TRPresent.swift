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
        (self as? ModalViewControllerDelegate)?.qk_transition = transitionDelegate
        viewControllerToPresent.transitioningDelegate = transitionDelegate
        presentViewController(viewControllerToPresent, animated: true, completion: completion)
    }
    
    public func qk_dismissViewController() {
        qk_dismissViewController(nil)
    }
    
    public func qk_dismissViewController(completion: (() -> Void)?) {
        let transition = (self as? ModalViewControllerDelegate)?.qk_transition
        transition?.transition.transitionStatus = .Dismiss
        presentedViewController?.transitioningDelegate = transition
        (self as? ModalViewControllerDelegate)?.qk_transition = nil
        dismissViewControllerAnimated(true, completion: completion)
    }
}

public protocol ModalViewControllerDelegate: class, NSObjectProtocol {
    var qk_transition: TRViewControllerTransitionDelegate?{get set}
    
    // TODO update -> Dictionary
    func modalViewControllerDismiss(callbackData data:NSDictionary?)
}

public extension ModalViewControllerDelegate where Self:UIViewController  {
    
    func modalViewControllerDismiss(callbackData data:NSDictionary?) {
        qk_dismissViewController()
    }
}

public protocol MainViewControllerDelegate: class, NSObjectProtocol {
    
    weak var modalDelegate: ModalViewControllerDelegate?{get set}
}


