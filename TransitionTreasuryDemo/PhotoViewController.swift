//
//  PhotoViewController.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/28/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, ModalViewControllerDelegate {
    
    var tr_transition: TRViewControllerTransitionDelegate?

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ges = UITapGestureRecognizer(target: self, action: Selector("push:"))
        imageView.addGestureRecognizer(ges)
        
        // Do any additional setup after loading the view.
    }
    
    func push(sender: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
        vc.modalDelegate = self
        print(vc)
        let nav = UINavigationController(rootViewController: vc)
        tr_presentViewController(nav, method: .Custom(PhotoTransitionAnimation(key: imageView)), completion: {
            print("Present finish.")
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
