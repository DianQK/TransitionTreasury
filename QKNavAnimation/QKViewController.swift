//
//  QKViewController.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/13/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit


public extension UIViewController {
    
//    var qk_transition_delegate: QKTransitionDelegate? {
//        get {
//            
//            return objc_getAssociatedObject(self, "qk_transition_delegate") as? QKTransitionDelegate
//        }
//        set {
//            objc_setAssociatedObject(self, "qk_transition_delegate", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
    
    public func qk_presentViewController(viewControllerToPresent: UIViewController, method: QKPresentMethod) {
        qk_presentViewController(viewControllerToPresent, method: method, completion: nil)
    }
    
    public func qk_presentViewController(viewControllerToPresent: UIViewController, method: QKPresentMethod, completion: (() -> Void)?) {

        print("viewControllerToPresent\(viewControllerToPresent)")
        let transitionDelegate = QKTransitionDelegate(method: method)
//        qk_transition_delegate = transitionDelegate
        
        if viewControllerToPresent.transitioningDelegate == nil || !(viewControllerToPresent.transitioningDelegate is QKTransitionDelegate) {
            viewControllerToPresent.transitioningDelegate = transitionDelegate
        } else {
            let transitionDelegate = viewControllerToPresent.transitioningDelegate as! QKTransitionDelegate
            transitionDelegate.updateStatus(.Present)
        }
//        print("\(qk_transition_delegate)")
        print("Present:\(viewControllerToPresent.transitioningDelegate)")
        presentViewController(viewControllerToPresent, animated: true, completion: completion)

    }
    
    public func qk_dismissViewController() {
        qk_dismissViewController(nil)
    }
    
    public func qk_dismissViewController(completion: (() -> Void)?) {
        let transitionDelegate = QKTransitionDelegate(method: .Twitter, status: .Dismiss)
        presentedViewController?.transitioningDelegate = transitionDelegate
//        if let transitionDelegate = transitioningDelegate as? QKTransitionDelegate {
//            transitionDelegate.transition.transitionStatus = .Dismiss
//        }
        weak var weakSelf = self
        let completionWithRelease = {
            completion?()
            weakSelf?.transitioningDelegate = nil
//            weakSelf?.qk_transition_delegate = nil
        }
        dismissViewControllerAnimated(true, completion: completionWithRelease)
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

