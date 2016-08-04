//
//  TransitionTreasury.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit
/**
 ViewController Transition Status
 
 - Push:    ViewController will push
 - Pop:     ViewController will pop
 - Present: ViewController will present
 - Dismiss: ViewController will dismiss
 */
public enum TransitionStatus {
    case push
    case pop
    case present
    case dismiss
    case tabBar
}

public protocol TransitionAnimationable {
    func transitionAnimation() -> TRViewControllerAnimatedTransitioning
}

public enum TabBarTransitionDirection {
    case left
    case right
    
    public static func TransitionDirection(_ fromVCindex: ViewControllerIndex, toVCIndex: ViewControllerIndex) -> TabBarTransitionDirection {
        if fromVCindex > toVCIndex {
            return .left
        } else {
            return .right
        }
    }
}

extension TabBarTransitionDirection : CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .left :
                return "Transition to Left"
            case .right :
                return "Transition to Right"
            }
        }
    }
}

public protocol TabBarTransitionInteractiveable : class, NSObjectProtocol{
    /// Option, if you implement, you must support your animation Push & Present interactive.
    var gestureRecognizer: UIGestureRecognizer?{get set}
    /// Require
    var percentTransition: UIPercentDrivenInteractiveTransition{get set}
    /// Option
    var interactivePrecent: CGFloat{get}
    /// Require
    var interacting: Bool{get set}
    /// Option
    var completion: (() -> Void)?{get set}
}

public extension TabBarTransitionInteractiveable {
    public var completion: (() -> Void)? {
        get {
            return nil
        }
        set {}
    }
}
