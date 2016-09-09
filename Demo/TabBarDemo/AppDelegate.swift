//
//  AppDelegate.swift
//  TransitionTreasuryTabbarDemo
//
//  Created by DianQK on 16/1/16.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TRTabBarControllerDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		if let tabBarController = window?.rootViewController as? UITabBarController {
			tabBarController.tr_transitionDelegate = TRTabBarTransitionDelegate(method: TRTabBarTransitionMethod.slide)
			tabBarController.tr_delegate = self
		}
		return true
	}

	func tr_tabBarController(_ tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		print("You did select \(type(of: viewController)).")
	}
}

