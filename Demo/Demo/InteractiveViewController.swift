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

	@IBAction func PresentClick(_ sender: UIButton) {
		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
		vc.modalDelegate = self
		tr_presentViewController(vc, method: TRPresentTransitionMethod.scanbot(present: nil, dismiss: vc.dismissGestureRecognizer), completion: {
			print("Present finished")
		})
	}

	@IBAction func popClick(_ sender: UIButton) {
        
		_ = navigationController?.popViewController(animated: true)
	}

	func interactiveTransition(_ sender: UIPanGestureRecognizer) {
		switch sender.state {
		case .began:
			guard sender.velocity(in: view).y > 0 else {
				break
			}
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
			vc.modalDelegate = self
			tr_presentViewController(vc, method: TRPresentTransitionMethod.scanbot(present: sender, dismiss: vc.dismissGestureRecognizer), completion: {
				print("Present finished")
			})
			default: break
		}
	}

	func modalViewControllerDismiss(interactive: Bool, callbackData data: AnyObject?) {
		tr_dismissViewController(interactive, completion: nil)
	}
}

extension InteractiveViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let ges = gestureRecognizer as? UIPanGestureRecognizer {
			return ges.translation(in: ges.view).y != 0
		}
		return false
	}
}
