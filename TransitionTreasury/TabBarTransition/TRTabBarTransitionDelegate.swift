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
    
    public func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return tr_delegate?.tr_tabBarController(tabBarController, shouldSelectViewController: viewController) ?? true
    }

    public func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        tr_delegate?.tr_tabBarController(tabBarController, didSelectViewController: viewController)
    }
    
    public func tabBarController(tabBarController: UITabBarController, willBeginCustomizingViewControllers viewControllers: [UIViewController]) {
        tr_delegate?.tr_tabBarController(tabBarController, willBeginCustomizingViewControllers: viewControllers)
    }
    
    public func tabBarController(tabBarController: UITabBarController, willEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool) {
        tr_delegate?.tr_tabBarController(tabBarController, willEndCustomizingViewControllers: viewControllers, changed: changed)
    }

    public func tabBarController(tabBarController: UITabBarController, didEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool) {
        tr_delegate?.tr_tabBarController(tabBarController, didEndCustomizingViewControllers: viewControllers, changed: true)
    }
    
    public func tabBarControllerSupportedInterfaceOrientations(tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return tr_delegate?.tr_tabBarControllerSupportedInterfaceOrientations(tabBarController) ?? UIApplication.sharedApplication().supportedInterfaceOrientationsForWindow(nil)
    }

    public func tabBarControllerPreferredInterfaceOrientationForPresentation(tabBarController: UITabBarController) -> UIInterfaceOrientation {
        return tr_delegate?.tr_tabBarControllerPreferredInterfaceOrientationForPresentation(tabBarController) ?? UIInterfaceOrientation.Unknown
    }
    
    public func tabBarController(tabBarController: UITabBarController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let transitionAnimation = transitionAnimation as? TabBarTransitionInteractiveable else {
            return nil
        }
        return transitionAnimation.interacting ? transitionAnimation.percentTransition : nil
    }
    
    public func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimation
    }
}
