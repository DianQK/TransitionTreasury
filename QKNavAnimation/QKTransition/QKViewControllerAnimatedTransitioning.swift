//
//  QKViewControllerAnimatedTransitioning.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/13/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit

public protocol QKViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    var keyView: UIView?{get set}
    
    var transitionStatus: TransitionStatus?{get set}
    
    var interacting: Bool{get set}
    
    var transitionContext: UIViewControllerContextTransitioning?{get set}
    
    var cancelPop: Bool{get set}
    
    var completion: (() -> Void)?{get set}
    
    func popToVCIndex(index: Int)
}

public extension QKViewControllerAnimatedTransitioning {
    public var interacting: Bool {
        get {
            return false
        }
        set {
            
        }
    }
    
    public var keyView: UIView? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    public var completion: (() -> Void)? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    func popToVCIndex(index: Int) {
        
    }
}