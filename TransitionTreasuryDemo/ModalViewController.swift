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
    
    lazy var dismissGestureRecognizer: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: Selector("panDismiss:"))
        self.view.addGestureRecognizer(pan)
        return pan
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func dismissClick(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(interactive: false, callbackData: ["title":title ?? ""])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func panDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            guard sender.translationInView(view).y < 0 else {
                break
            }
            modalDelegate?.modalViewControllerDismiss(interactive: true, callbackData: ["title":title ?? ""])
        default : break
        }
    }
    
    deinit {
        print("Modal deinit.")
    }
    
}
