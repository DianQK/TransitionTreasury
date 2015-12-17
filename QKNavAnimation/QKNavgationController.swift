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

    public func qk_pushViewController(viewcontroller: UIViewController,key: UIView, method: QKKeyPushMethod) {
        qk_pushViewController(viewcontroller, key: key, method: method, completion: nil)
    }

    public func qk_pushViewController(viewcontroller: UIViewController,key: UIView, method: QKKeyPushMethod, completion: (() -> Void)?) {
        let transition = QKNavgationTransitionDelegate(method: method, key: key, status: .Push, gestureFor: viewcontroller)
        transition.completion = completion
        (viewcontroller as? QKTransition)?.qk_transition = transition
        delegate = transition
        pushViewController(viewcontroller, animated: true)
    }
    
    public func qk_popViewController() -> UIViewController? {
        return qk_popViewController(nil)
    }
    
    public func qk_popViewController(completion: (() -> Void)?) -> UIViewController? {
        let transition = (topViewController as? QKTransition)?.qk_transition//QKNavgationTransitionDelegate(method: .OMIN, key: UIView(), status: .Pop, gestureFor: nil)
        let popViewController = topViewController
        transition?.completion = {
            completion?()
            (popViewController as? QKTransition)?.qk_transition = nil
        }
        transition?.transition.transitionStatus = .Pop
        delegate = transition
        return {
            let popViewController = popViewControllerAnimated(true)
//            (popViewController as? QKTransition)?.qk_transition = nil
            return popViewController
        }()
    }
    
    public func qk_popToViewController(viewController: UIViewController) -> [UIViewController]? {
        return qk_popToViewController(viewController, completion: nil)
    }
    
    public func qk_popToViewController(viewController: UIViewController, completion: (() -> Void)?) -> [UIViewController]? {
        guard let index = viewControllers.indexOf(viewController) else {
            fatalError("No this viewController for pop!!!")
        }
        let transition = QKNavgationTransitionDelegate(method: .OMIN, key: UIView(), status: .Pop, gestureFor: nil)
        transition.completion = completion
        transition.transition.popToVCIndex(index)
        delegate = transition
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

public protocol QKTransition: class {
    var qk_transition: QKNavgationTransitionDelegate?{get set}
}

