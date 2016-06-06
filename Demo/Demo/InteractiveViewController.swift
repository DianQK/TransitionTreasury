//
//  InteractiveViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/15/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

class InteractiveViewController: UIViewController, ModalTransitionDelegate, NavgationTransitionable {
	var tr_presentTransition: TRViewControllerTransitionDelegate?

	var tr_pushTransition: TRNavgationTransitionDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let pan = UIPanGestureRecognizer(target: self, action: #selector(InteractiveViewController.interactiveTransition(_:)))
		pan.delegate = self
		view.addGestureRecognizer(pan)
	}

	@IBAction func PresentClick(sender: UIButton) {
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
		vc.modalDelegate = self
		tr_presentViewController(vc, method: TRPresentTransitionMethod.Scanbot(present: nil, dismiss: vc.dismissGestureRecognizer), completion: {
			print("Present finished")
		})
	}

	@IBAction func popClick(sender: UIButton) {
		navigationController?.popViewControllerAnimated(true)
	}

	func interactiveTransition(sender: UIPanGestureRecognizer) {
		switch sender.state {
		case .Began:
			guard sender.velocityInView(view).y > 0 else {
				break
			}
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
			vc.modalDelegate = self
			tr_presentViewController(vc, method: TRPresentTransitionMethod.Scanbot(present: sender, dismiss: vc.dismissGestureRecognizer), completion: {
				print("Present finished")
			})
			default: break
		}
	}

	func modalViewControllerDismiss(interactive interactive: Bool, callbackData data: AnyObject?) {
		tr_dismissViewController(interactive: interactive, completion: nil)
	}
}

extension InteractiveViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let ges = gestureRecognizer as? UIPanGestureRecognizer {
			return ges.translationInView(ges.view).y != 0
		}
		return false
	}
}
