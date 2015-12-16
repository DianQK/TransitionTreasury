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
        
        if viewControllerToPresent.transitioningDelegate == nil || !(viewControllerToPresent.transitioningDelegate is QKTransitionDelegate) {
            viewControllerToPresent.transitioningDelegate = transitionDelegate
        } else {
            let transitionDelegate = viewControllerToPresent.transitioningDelegate as! QKTransitionDelegate
            transitionDelegate.updateStatus(.Present)
        }
        print("Present:\(viewControllerToPresent.transitioningDelegate)")
        presentViewController(viewControllerToPresent, animated: true, completion: completion)

    }
    
    public func qk_dismissViewController() {
        qk_dismissViewController(nil)
    }
    
    public func qk_dismissViewController(completion: (() -> Void)?) {
        let transitionDelegate = QKTransitionDelegate(method: .Twitter, status: .Dismiss)
        presentedViewController?.transitioningDelegate = transitionDelegate
        dismissViewControllerAnimated(true, completion: completion)
    }
}

public protocol MainPresentDelegate: class, NSObjectProtocol {
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

