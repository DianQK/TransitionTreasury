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
    case Push
    case Pop
    case Present
    case Dismiss
    case TabBar
}

public protocol TransitionAnimationable {
    func transitionAnimation() -> TRViewControllerAnimatedTransitioning
}

public enum TabBarTransitionDirection {
    case Left
    case Right
    
    public static func TransitionDirection(fromVCindex: ViewControllerIndex, toVCIndex: ViewControllerIndex) -> TabBarTransitionDirection {
        if fromVCindex > toVCIndex {
            return .Left
        } else {
            return .Right
        }
    }
}

extension TabBarTransitionDirection : CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .Left :
                return "Transition to Left"
            case .Right :
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