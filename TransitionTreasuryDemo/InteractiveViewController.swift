//
//  InteractiveViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/15/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury

class InteractiveViewController: UIViewController, ModalTransitionDelegate {
    
    var tr_transition: TRViewControllerTransitionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let pan = UIPanGestureRecognizer(target: self, action: "interactiveTransition:")
        view.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func PresentClick(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
        vc.modalDelegate = self
//        let nav = UINavigationController(rootViewController: vc)
        tr_presentViewController(vc, method: .Scanbot(gesture: nil), completion: {
            print("Present finished")
        })
    }
    
    @IBAction func popClick(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func interactiveTransition(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
            vc.modalDelegate = self
            let nav = UINavigationController(rootViewController: vc)
            tr_presentViewController(vc, method: .Scanbot(gesture: sender), completion: {
                print("Present finished")
            })
        default : break
        }
    }

}
