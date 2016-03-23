//
//  MainViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import XCTest
@testable import TransitionTreasury
@testable import TransitionAnimation

class MainViewController: UIViewController, ModalTransitionDelegate {
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modalViewControllerDismiss(interactive interactive: Bool, callbackData data:AnyObject?) {
        
    }
    
    func modalViewControllerDismiss(callbackData data:AnyObject?) {
        
    }

}
