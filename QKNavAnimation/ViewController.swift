//
//  ViewController.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/11/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QKTransition {
    
    var qk_transition: QKNavgationTransitionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func popToRootVC(sender: UIButton) {
//        navigationController?.qk_popViewController({
//            print("Pop finish")
//        })
        navigationController?.qk_popToRootViewController({
            print("Pop Root finish.")
        })
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let view = touches.first?.view {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController")
            navigationController?.qk_pushViewController(vc, key: view, method: .OMIN, completion: {
                print("Push finish")
            })
        }
    }
    
    deinit {
        print("deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

