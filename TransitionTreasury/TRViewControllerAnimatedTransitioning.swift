//
//  TRViewControllerAnimatedTransitioning.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/**
 *  TransitionTreasury's transition protocol. All transition animation must conform this protocol.
 */
public protocol TRViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    /// Required implement.
    var transitionStatus: TransitionStatus?{get set}
    /// Option implement.
    var previousStatusBarStyle: UIStatusBarStyle?{get set}
    /// Option implement.
    var interacting: Bool{get set}
    /// Rquired implement.
    var transitionContext: UIViewControllerContextTransitioning?{get set}
    /// Option
    var completion: (() -> Void)?{get set}
    /// Option, For Interaction
    var cancelPop: Bool{get set}
    /// Option, For Interaction
    var interactivePrecent: CGFloat{get}
    /// Option, For Interaction
    var percentTransition: UIPercentDrivenInteractiveTransition?{set get}
    /// Option, set false, if you don't need edge slide, default is true
    var edgeSlidePop: Bool{get set}
    /**
     Option
     
     - parameter index: index of navgationViewController.viewcontrollers
     */
    func popToVCIndex(index: Int)
}

public extension TRViewControllerAnimatedTransitioning {
    
    public var interacting: Bool {
        get {
            return false
        }
        set {}
    }
    
    public var completion: (() -> Void)? {
        get {
            return nil
        }
        set {}
    }
    
    public var interactivePrecent: CGFloat {
        get {
            return 0.3
        }
    }
    
    public var cancelPop: Bool {
        get {
            return false
        }
        set {}
    }
    
    public var percentTransition: UIPercentDrivenInteractiveTransition? {
        get {
            return nil
        }
        set {}
    }
    
    public var edgeSlidePop: Bool {
        get {
            return true
        }
        set {}
    }
    
    public var previousStatusBarStyle: UIStatusBarStyle? {
        get {
            return nil
        }
        set {}
    }
    
    func popToVCIndex(index: Int) {}
    
}
