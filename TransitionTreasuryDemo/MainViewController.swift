//
//  MainViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ModalViewControllerDelegate {
    
    var tr_transition: TRViewControllerTransitionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tr_presentVC(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
        vc.modalDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        let list = ListTransitionAnimation(visibleHeight: 500, bounce: true)
        tr_presentViewController(nav, method: .Custom(list), completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>?) {
        print(data)
        self.tr_dismissViewController()
    }

}
