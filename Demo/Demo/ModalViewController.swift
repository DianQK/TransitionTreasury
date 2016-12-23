//
//  ModalViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury

class ModalViewController: UIViewController {
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var backButton: UIButton!
    
    lazy var dismissGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ModalViewController.panDismiss(_:)))
        self.view.addGestureRecognizer(pan)
        return pan
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.isHidden = !(navigationController?.isNavigationBarHidden ?? true)
    }

    @IBAction func dismissClick(_ sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: ["title":title ?? ""])
    }

    
    func panDismiss(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began :
            guard sender.translation(in: view).y < 0 else {
                break
            }
            modalDelegate?.modalViewControllerDismiss(true, callbackData: nil)
        default : break
        }
    }

    deinit {
        print("Modal deinit.")
    }
    
}
