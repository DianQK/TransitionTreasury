//
//  ThirdViewController.swift
//  Demo
//
//  Created by 宋宋 on 16/3/7.
//  Copyright © 2016年 DianQK. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    lazy var gesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("swipeTransition:"))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addGestureRecognizer(gesture)
    }
    
    func swipeTransition(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            print("Began")
            if sender.translationInView(sender.view).x >= 0 {
                tabBarController?.tr_selected(1, gesture: sender)
            }
        default : break
        }
    }

}
