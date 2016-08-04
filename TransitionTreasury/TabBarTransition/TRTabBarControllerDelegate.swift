//
//  TRTabBarControllerDelegate.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/19.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit

public protocol TRTabBarControllerDelegate: class, NSObjectProtocol {

    func tr_tabBarController(_ tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool

    func tr_tabBarController(_ tabBarController: UITabBarController, didSelectViewController viewController: UIViewController)

    func tr_tabBarController(_ tabBarController: UITabBarController, willBeginCustomizingViewControllers viewControllers: [UIViewController])

    func tr_tabBarController(_ tabBarController: UITabBarController, willEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool)

    func tr_tabBarController(_ tabBarController: UITabBarController, didEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool)

    func tr_tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask

    func tr_tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation

}

public extension TRTabBarControllerDelegate {

    func tr_tabBarController(_ tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }

    func tr_tabBarController(_ tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
    }
    
    func tr_tabBarController(_ tabBarController: UITabBarController, willBeginCustomizingViewControllers viewControllers: [UIViewController]) {
        
    }

    func tr_tabBarController(_ tabBarController: UITabBarController, willEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool) {
        
    }

    func tr_tabBarController(_ tabBarController: UITabBarController, didEndCustomizingViewControllers viewControllers: [UIViewController], changed: Bool) {
        
    }
    
    func tr_tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return UIApplication.shared.supportedInterfaceOrientations(for: nil)
    }

    func tr_tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation {
        return UIInterfaceOrientation.unknown
    }
    
}
