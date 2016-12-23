//
//  FirstViewController.swift
//  TransitionTreasuryTabbarDemo
//
//  Created by DianQK on 16/1/16.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    lazy var gesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(FirstViewController.swipeTransition(_:)))
        return gesture
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(gesture)
    }
    
    func swipeTransition(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began :
            if sender.translation(in: sender.view).x < 0 {
                tabBarController?.tr_selected(1, gesture: sender)
            }
        default : break
        }
    }


}

