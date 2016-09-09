//
//  SecondViewController.swift
//  TransitionTreasuryTabbarDemo
//
//  Created by DianQK on 16/1/16.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    lazy var gesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(SecondViewController.swipeTransition(_:)))
        return gesture
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addGestureRecognizer(gesture)
    }
    
    func swipeTransition(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began :
            print("Began")
            if sender.translation(in: sender.view).x >= 0 {
                tabBarController?.tr_selected(0, gesture: sender)
            } else if sender.translation(in: sender.view).x < 0 {
                tabBarController?.tr_selected(2, gesture: sender)
            }
            
        default : break
        }
    }


}

