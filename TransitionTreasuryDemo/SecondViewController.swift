//
//  SecondViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
import TransitionTreasury

class SecondViewController: UIViewController, NavgationTransitionable {
    
    var tr_transition: TRNavgationTransitionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /**
        Advande Usage (Get keyView or KeyViewCopy)
        Issue: https://github.com/DianQK/TransitionTreasury/issues/1
        */
        if let transitionAnimation = tr_transition?.transition as? IBanTangTransitionAnimation {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("Second deinit.")
    }

}
