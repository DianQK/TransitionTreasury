//
//  SecondViewController.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/11/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, MainViewControllerDelegate {
    
    weak var modalDelegate: ModalViewControllerDelegate?
    
//    var qk_transition: QKTransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func pop(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: ["data":"back"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit")
    }
    
}
