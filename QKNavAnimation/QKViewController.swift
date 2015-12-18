//
//  QKViewController.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/13/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit


public extension UIViewController {
    
    public func qk_presentViewController(viewControllerToPresent: UIViewController, method: QKPresentMethod) {
        qk_presentViewController(viewControllerToPresent, method: method, completion: nil)
    }
    
    public func qk_presentViewController(viewControllerToPresent: UIViewController, method: QKPresentMethod, completion: (() -> Void)?) {

        let transitionDelegate = QKTransitionDelegate(method: method)
        (self as? MainPresentDelegate)?.qk_transition = transitionDelegate
        viewControllerToPresent.transitioningDelegate = transitionDelegate
        presentViewController(viewControllerToPresent, animated: true, completion: completion)

    }
    
    public func qk_dismissViewController() {
        qk_dismissViewController(nil)
    }
    
    public func qk_dismissViewController(completion: (() -> Void)?) {
        let transition = (self as? MainPresentDelegate)?.qk_transition
        transition?.transition.transitionStatus = .Dismiss
        presentedViewController?.transitioningDelegate = transition
        (self as? MainPresentDelegate)?.qk_transition = nil
        dismissViewControllerAnimated(true, completion: completion)
    }
}

public protocol MainPresentDelegate: class, NSObjectProtocol {
    var qk_transition: QKTransitionDelegate?{get set}
    
    // TODO update -> Dictionary
    func modalViewControllerDismiss(callbackData data:NSDictionary?)
}

public extension MainPresentDelegate where Self:UIViewController  {
    
    func modalViewControllerDismiss(callbackData data:NSDictionary?) {
        qk_dismissViewController()
    }
}

public protocol ModalPresentDelegate: class, NSObjectProtocol {
    
    weak var modalDelegate: MainPresentDelegate?{get set}
}

