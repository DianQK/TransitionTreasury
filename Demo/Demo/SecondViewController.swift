//
//  SecondViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

class SecondViewController: UIViewController, NavgationTransitionable {
	var tr_pushTransition: TRNavgationTransitionDelegate?

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		/**
		 Advande Usage (Get keyView or KeyViewCopy)
		 Issue: https://github.com/DianQK/TransitionTreasury/issues/1
		 */
		if let transitionAnimation = tr_pushTransition?.transition as? IBanTangTransitionAnimation {
			print(transitionAnimation.keyView)
			print(transitionAnimation.keyViewCopy)
		}
		if let view = view.viewWithTag(20000) {
			print(view)
		}
	}

	@IBAction func popClick(sender: AnyObject) {
		navigationController?.tr_popViewController({ () -> Void in
			print("Pop finished.")
		})
	}

	deinit {
		print("Second deinit.")
	}
}
