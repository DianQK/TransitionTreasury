//
//  ModalViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury

class ModalViewController: UIViewController, MainViewControllerDelegate {
    
    weak var modalDelegate: ModalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func dismissClick(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: ["title":title ?? ""])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("Modal deinit.")
    }
    
}
