//
//  TransitionTreasury.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/**
 ViewController Push Methods
 
 - OMIN:        Like OmniFocus
 - Custom:      Custom you like
 */
public enum TRPushMethod {
    case OMIN(keyView: UIView)
    case BanTang(keyView: UIView)
    case Custom(TRViewControllerAnimatedTransitioning)
    
    func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case let .OMIN(key) :
            return OMINTransitionAnimation(key: key)
        case let .Custom(transition) :
            return transition
        case let .BanTang(key) :
            return BTTransitionAnimation(key: key)
        }
    }
}

/**
 ViewController Present Methods
 
 - Twitter:     Like Twitter
 - Custom:      Custom you like
 */
public enum TRPresentMethod {
    case Twitter
    case Custom(TRViewControllerAnimatedTransitioning)
    
    func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .Twitter :
            return TwitterTransitionAnimation()
        case let .Custom(transition) :
            return transition
        }
    }
}

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
}

// TODO
//public enum TransitionPresentStatus {
//    case Present
//    case Dismiss
//}

