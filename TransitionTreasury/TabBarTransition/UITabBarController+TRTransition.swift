//
//  UITabBarController+TRTransition.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/19.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit

private var transition_key: Void?
private var delegate_key: Void?

public typealias ViewControllerIndex = Int

public extension UITabBarController {
    
    public var tr_transitionDelegate: TRTabBarTransitionDelegate? {
        get {
            return objc_getAssociatedObject(self, &transition_key) as? TRTabBarTransitionDelegate
        }
        set {
            self.delegate = newValue
            objc_setAssociatedObject(self,
                &transition_key, newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public weak var tr_delegate: TRTabBarControllerDelegate? {
        get {
            if tr_transitionDelegate == nil {
                debugPrint("Warning: You forget set tr_transitionDelegate.")
            }
            return tr_transitionDelegate?.tr_delegate
        }
        set {
            if tr_transitionDelegate == nil {
                debugPrint("Warning: You forget set tr_transitionDelegate.")
            }
            tr_transitionDelegate?.tr_delegate = newValue
        }
    }
    
    public func tr_selected(_ index: ViewControllerIndex, gesture: UIGestureRecognizer, completion: (() -> Void)? = nil) {
        if let transitionAnimation = tr_transitionDelegate?.transitionAnimation as? TabBarTransitionInteractiveable {
            transitionAnimation.gestureRecognizer = gesture
            transitionAnimation.interacting = true
            transitionAnimation.completion = completion
        }
        selectedIndex = index
    }
    
}
