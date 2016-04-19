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

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		if let tabBarController = window?.rootViewController as? UITabBarController {
			tabBarController.tr_transitionDelegate = TRTabBarTransitionDelegate(method: TRTabBarTransitionMethod.Slide)
			tabBarController.tr_delegate = self
		}
		return true
	}

	func tr_tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		print("You did select \(viewController.dynamicType).")
	}
}

