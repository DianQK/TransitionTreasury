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
            return tr_transitionDelegate?.tr_delegate
//            return objc_getAssociatedObject(self, &delegate_key) as? TRTabBarControllerDelegate
        }
        set {
            tr_transitionDelegate?.tr_delegate = newValue
//            objc_setAssociatedObject(self,
//                &delegate_key, newValue,
//                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}