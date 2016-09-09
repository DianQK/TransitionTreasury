//
//  ModalViewController.swift
//  Example
//
//  Created by DianQK on 16/3/24.
//  Copyright © 2016年 com.transitiontreasury. All rights reserved.
//

import UIKit
import TransitionTreasury
import TransitionAnimation

class ModalViewController: UIViewController {
    
    weak var modalDelegate: ModalViewControllerDelegate?

    @IBAction func dissmissClick(_ sender: UIButton) {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
    }
    
}
