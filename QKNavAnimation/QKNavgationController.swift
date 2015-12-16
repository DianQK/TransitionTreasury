//
//  QKViewController.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/11/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit
// TODO 对枚举类别的处理 
public extension UINavigationController {
    
    var qk_nav_transition_delegate: QKNavgationTransitionDelegate? {
        get {
            return objc_getAssociatedObject(self, "qk_nav_transition_delegate") as? QKNavgationTransitionDelegate
        }
        set {
            objc_setAssociatedObject(self, "qk_nav_transition_delegate", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func qk_pushViewController(viewcontroller: UIViewController,key: UIView, method: QKKeyPushMethod) {
        qk_pushViewController(viewcontroller, key: key, method: method, completion: nil)
    }
    
    public func qk_pushViewController(viewcontroller: UIViewController,key: UIView, method: QKKeyPushMethod, completion: (() -> Void)?) {
        let transition = QKNavgationTransitionDelegate(method: method, key: key, status: .Push, gestureFor: viewcontroller)
        transition.completion = completion
//        qk_nav_transition_delegate = transition
        if delegate == nil || !(delegate is QKNavgationTransitionDelegate) {
            delegate = transition
        } else {
            let transitionDelegate = delegate as! QKNavgationTransitionDelegate
            transitionDelegate.updateStatus(key, status: .Push, gestureFor: viewcontroller)
        }
        pushViewController(viewcontroller, animated: true)
    }
    
    public func qk_popViewController() -> UIViewController? {
        return qk_popViewController(nil)
    }
    
    public func qk_popViewController(completion: (() -> Void)?) -> UIViewController? {
//        if let transitionDelegate = delegate as? QKNavgationTransitionDelegate {
//            transitionDelegate.transition.transitionStatus = .Pop
//            transitionDelegate.completion = completion
//        }
        let transition = QKNavgationTransitionDelegate(method: .OMIN, key: UIView(), status: .Pop, gestureFor: nil)
        transition.completion = completion
        delegate = transition
        print(delegate)
        return popViewControllerAnimated(true)
    }
    
    public func qk_popToViewController(viewController: UIViewController) -> [UIViewController]? {
        return qk_popToViewController(viewController, completion: nil)
    }
    
    public func qk_popToViewController(viewController: UIViewController, completion: (() -> Void)?) -> [UIViewController]? {
        guard let index = viewControllers.indexOf(viewController) else {
            fatalError("No this viewController for pop!!!")
        }
        if let transitionDelegate = delegate as? QKNavgationTransitionDelegate {
            transitionDelegate.transition.transitionStatus = .Pop
            transitionDelegate.completion = completion
            transitionDelegate.transition.popToVCIndex(index)
        }
        return popToViewController(viewController, animated: true)
    }
    
    public func qk_popToRootViewController() -> [UIViewController]? {
        return qk_popToRootViewController(nil)
    }
    
    public func qk_popToRootViewController(completion: (() -> Void)?) -> [UIViewController]? {
        let transitionDelegate = delegate as? QKNavgationTransitionDelegate
        transitionDelegate?.completion = completion
        transitionDelegate?.transition.transitionStatus = .Pop
        transitionDelegate?.transition.popToVCIndex(0)
        return popToRootViewControllerAnimated(true)
    }
    
}

public protocol QKTransitionData: class {
    var qk_transition_data: AnyObject?{get set}
}

