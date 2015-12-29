//
//  ViewController.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

class OMINViewController: UIViewController, TRTransition {
    
    var tr_transition: TRNavgationTransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let view = touches.first?.view {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OMINViewController")
            navigationController?.tr_pushViewController(vc, method: .Custom(OMINTransitionAnimation(key: view)), completion: {
                print("Push finished")
            })
            navigationController?.tr_pushViewController(vc, method: .OMIN(keyView: view), completion: {
                print("Push finish")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

