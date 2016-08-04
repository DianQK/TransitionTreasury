//
//  TRTabBarTransitionDelegate.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/19.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit

public class TRTabBarTransitionDelegate: NSObject, UITabBarControllerDelegate {
    
    public var transitionAnimation: UIViewControllerAnimatedTransitioning
    
    weak var tr_delegate: TRTabBarControllerDelegate?
    
    public init(method: TransitionAnimationable) {
        transitionAnimation = method.transitionAnimation()
        super.init()
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return tr_delegate?.tr_tabBarController(tabBarController, shouldSelectViewController: viewController) ?? true
    }

    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tr_delegate?.tr_tabBarController(tabBarController, didSelectViewController: viewController)
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]) {
        tr_delegate?.tr_tabBarController(tabBarController, willBeginCustomizingViewControllers: viewControllers)
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, willEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        tr_delegate?.tr_tabBarController(tabBarController, willEndCustomizingViewControllers: viewControllers, changed: changed)
    }

    public func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
        tr_delegate?.tr_tabBarController(tabBarController, didEndCustomizingViewControllers: viewControllers, changed: true)
    }
    
    public func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return tr_delegate?.tr_tabBarControllerSupportedInterfaceOrientations(tabBarController) ?? UIApplication.shared.supportedInterfaceOrientations(for: nil)
    }

    public func tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation {
        return tr_delegate?.tr_tabBarControllerPreferredInterfaceOrientationForPresentation(tabBarController) ?? UIInterfaceOrientation.unknown
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transitionAnimation = transitionAnimation as? TabBarTransitionInteractiveable else {
            return nil
        }
        return transitionAnimation.interacting ? transitionAnimation.percentTransition : nil
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimation
    }
}
