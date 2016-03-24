//
//  FirstViewController.swift
//  Example
//
//  Created by DianQK on 16/3/24.
//  Copyright © 2016年 com.transitiontreasury. All rights reserved.
//

import UIKit
import TransitionTreasury

class FirstViewController: UIViewController, ModalTransitionDelegate {
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func pushClick(sender: UIButton) {
        let second = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
        navigationController?.tr_pushViewController(second, method: Transition.Push)
    }
    
    
    @IBAction func presentClick(sender: UIButton) {
        let model = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
        model.modalDelegate = self
        tr_presentViewController(model, method: Transition.Present)
    }
    
    func modalViewControllerDismiss(callbackData data: AnyObject?) {
        tr_dismissViewController()
    }

}
