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
public enum TRPushTransitionMethod: TransitionAnimationable {
    case OMIN(keyView: UIView)
    case IBanTang(keyView: UIView)
    case Fade
    case Page
    case Blixt(keyView: UIView, to: CGRect)
//    case Storehouse(keyView: UIView)
    case Custom(TRViewControllerAnimatedTransitioning)
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
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
//        case let .Storehouse(view) :
//            return StorehouseTransitionAnimation(key: view)
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
public enum TRPresentTransitionMethod: TransitionAnimationable {
    case Twitter
    case Fade
    case PopTip(visibleHeight: CGFloat)
    case TaaskyFlip(blurEffect: Bool)
    case Elevate(maskView: UIView, to: CGPoint)
    case Scanbot(present: UIPanGestureRecognizer?, dismiss: UIPanGestureRecognizer?)
    case Custom(TRViewControllerAnimatedTransitioning)
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
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
        case let .Scanbot(presentGesture, dismissGesture) :
            return ScanbotTransitionAnimation(presentGesture: presentGesture, dismissGesture: dismissGesture)
        case let .Custom(transition) :
            return transition
        }
    }
}

public enum TRTabBarTransitionMethod: TransitionAnimationable {
    case Fade
    case Custom(TRViewControllerAnimatedTransitioning)
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .Fade :
            return FadeTransitionAnimation(status: .TabBar)
        case .Custom(let transition) :
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
    case TabBar
}

public protocol TransitionAnimationable {
    func transitionAnimation() -> TRViewControllerAnimatedTransitioning
}