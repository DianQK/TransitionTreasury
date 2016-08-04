//
//  TRViewControllerAnimatedTransitioning.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
/**
 *  TransitionTreasury's transition protocol. All transition animation must conform this protocol.
 */
public protocol TRViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    /// Required implement.
    var transitionStatus: TransitionStatus{get set}
    /// Rquired implement.
    var transitionContext: UIViewControllerContextTransitioning?{get set}
    /// Option
    var completion: (() -> Void)?{get set}
    /**
     Option
     
     - parameter index: index of navgationViewController.viewcontrollers
     */
    func popToVCIndex(_ index: Int)
}

public protocol TransitionInteractiveable {
    /// Option, if you implement, you must support your animation Push & Present interactive.
    var panGestureRecognizer: UIPanGestureRecognizer?{get set}
    /// Require
    var percentTransition: UIPercentDrivenInteractiveTransition?{get set}
    /// Option
    var interactivePrecent: CGFloat{get}
    /// Require
    var interacting: Bool{get set}
    /// Require
    var cancelPop: Bool{get set}
    /// Option
    var edgeSlidePop: Bool{get set}
}

public extension TRViewControllerAnimatedTransitioning {
    
    public var completion: (() -> Void)? {
        get {
            return nil
        }
        set {}
    }
    
    func popToVCIndex(_ index: Int) {}
    
}

public extension TransitionInteractiveable {
    public var panGestureRecognizer: UIPanGestureRecognizer? {
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

    public var edgeSlidePop: Bool {
        get {
            return true
        }
        set {}
    }
    
}
