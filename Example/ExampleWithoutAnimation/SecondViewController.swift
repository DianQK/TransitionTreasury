//
//  SecondViewController.swift
//  Example
//
//  Created by DianQK on 16/3/24.
//  Copyright © 2016年 com.transitiontreasury. All rights reserved.
//

import UIKit
import TransitionTreasury

class SecondViewController: UIViewController, NavgationTransitionable {
    
    var tr_pushTransition: TRNavgationTransitionDelegate?

    @IBAction func popClick(sender: UIButton) {
        navigationController?.tr_popViewController()
    }
    
}
