//
//  FirstViewController.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/13/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, MainPresentDelegate {

    var qk_transition: QKTransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func qk_presentVC(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
        vc.modalDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        qk_presentViewController(nav, method: .Twitter, completion: nil)
    }
    
    @IBAction func defaultDismissVC(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modalViewControllerDismiss(callbackData data: NSDictionary?) {
        print(data)
        self.qk_dismissViewController()
    }
    
    
    deinit {
        print("deinit")
    }
}
