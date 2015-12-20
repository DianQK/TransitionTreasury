//
//  TRViewControllerAnimatedTransitioning.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public protocol TRViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    var keyView: UIView?{get set}
    
    var transitionStatus: TransitionStatus?{get set}
    
    var interacting: Bool{get set}
    
    var transitionContext: UIViewControllerContextTransitioning?{get set}
    
    var cancelPop: Bool{get set}
    
    var completion: (() -> Void)?{get set}
    
    var interactivePrecent: CGFloat{get}
    
    func popToVCIndex(index: Int)
}

public extension TRViewControllerAnimatedTransitioning {
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
    
    var interactivePrecent: CGFloat {
        get {
            return 0.3
        }
    }
    
    func popToVCIndex(index: Int) {
        
    }
    
}
