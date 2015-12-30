//
//  BTViewController.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/22/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

class IBTViewController: UIViewController, TRTransition {
    
    var tr_transition: TRNavgationTransitionDelegate?

    @IBOutlet weak var keyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ges = UITapGestureRecognizer(target: self, action: Selector("push:"))
        keyImageView.addGestureRecognizer(ges)

        // Do any additional setup after loading the view.
    }
    
    func push(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("IBTViewController")
        navigationController?.tr_pushViewController(vc, method: .IBanTang(keyView: sender.view!), completion: {
            print("Push finish")
        })
    }
    
    @IBAction func pop(sender: UIButton) {
        navigationController?.tr_popViewController({
            print("Pop finish")
        })
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("BT VC deinit")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
