//
//  TRTransitionAnimations.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 16/2/5.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/**
 ViewController Push Methods
 
 - OMIN:          Like OmniFocus
 - IBanTang:      Like IBanTang
 - Fade:          Fade Out In
 - Page:          Page Motion
 */
public enum TRPushTransitionMethod: TransitionAnimationable {
    case OMNI(keyView: UIView)
    case IBanTang(keyView: UIView)
    case Fade
    case Page
    case Blixt(keyView: UIView, to: CGRect)
    case Default
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case let .OMNI(key) :
            return OMNITransitionAnimation(key: key)
        case let .IBanTang(key) :
            return IBanTangTransitionAnimation(key: key)
        case .Fade :
            return FadeTransitionAnimation()
        case .Page :
            return PageTransitionAnimation()
        case let .Blixt(view, frame) :
            return BlixtTransitionAnimation(key: view, toFrame: frame)
        case .Default :
            return DefaultPushTransitionAnimation()
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
        }
    }
}

public enum TRTabBarTransitionMethod: TransitionAnimationable {
    case Fade
    case Slide
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .Fade :
            return FadeTransitionAnimation(status: .TabBar)
        case .Slide :
            return SlideTransitionAnimation()
        }
    }
}
