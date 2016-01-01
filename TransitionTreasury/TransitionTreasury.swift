//
//  TransitionTreasury.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
 /**
 ViewController Push Methods
 
 - OMIN:          Like OmniFocus
 - IBanTang:      Like IBanTang
 - Fade:          Fade Out In
 - Page:          Page Motion
 - Custom:        Custom your animation
 */
public enum TRPushMethod {
    case OMIN(keyView: UIView)
    case IBanTang(keyView: UIView)
    case Fade
    case Page
    case Blixt(keyView: UIView, to: CGRect)
    case Custom(TRViewControllerAnimatedTransitioning)
    
    func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case let .OMIN(key) :
            return OMINTransitionAnimation(key: key)
        case let .IBanTang(key) :
            return IBanTangTransitionAnimation(key: key)
        case .Fade :
            return FadeTransitionAnimation()
        case .Page :
            return PageTransitionAnimation()
        case let .Blixt(view, frame) :
            return BlixtTransitionAnimation(key: view, toFrame: frame)
        case let .Custom(transition) :
            return transition
        }
    }
}

 /**
 ViewController Present Methods
 
 - Twitter:     Like Twitter
 - Fade:        Fade out in
 - PopTip:      Pop A Tip VC
 - Custom:      Custom your Animation
 */
public enum TRPresentMethod {
    case Twitter
    case Fade
    case PopTip(visibleHeight: CGFloat)
    case TaaskyFlip(blurEffect: Bool)
    case Elevate(maskView: UIView, to: CGPoint)
    case Custom(TRViewControllerAnimatedTransitioning)
    
    func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .Twitter :
            return TwitterTransitionAnimation()
        case .Fade :
            return FadeTransitionAnimation()
        case let .PopTip(height) :
            return PopTipTransitionAnimation(visibleHeight: height)
        case let .TaaskyFlip(blur) :
            return TaaskyFlipTransitionAnimation(blurEffect: blur)
        case let .Elevate(view, position) :
            return ElevateTransitionAnimation(maskView: view, toPosition: position)
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
    case Finish
}

// TODO
//public enum TransitionPresentStatus {
//    case Present
//    case Dismiss
//}

