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
    case omni(keyView: UIView)
    case iBanTang(keyView: UIView)
    case fade
    case page
    case blixt(keyView: UIView, to: CGRect)
    case `default`
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case let .omni(key) :
            return OMNITransitionAnimation(key: key)
        case let .iBanTang(key) :
            return IBanTangTransitionAnimation(key: key)
        case .fade :
            return FadeTransitionAnimation()
        case .page :
            return PageTransitionAnimation()
        case let .blixt(view, frame) :
            return BlixtTransitionAnimation(key: view, toFrame: frame)
        case .default :
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
    case twitter
    case fade
    case popTip(visibleHeight: CGFloat)
    case taaskyFlip(blurEffect: Bool)
    case elevate(maskView: UIView, to: CGPoint)
    case scanbot(present: UIPanGestureRecognizer?, dismiss: UIPanGestureRecognizer?)
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .twitter :
            return TwitterTransitionAnimation()
        case .fade :
            return FadeTransitionAnimation()
        case let .popTip(height) :
            return PopTipTransitionAnimation(visibleHeight: height)
        case let .taaskyFlip(blur) :
            return TaaskyFlipTransitionAnimation(blurEffect: blur)
        case let .elevate(view, position) :
            return ElevateTransitionAnimation(maskView: view, toPosition: position)
        case let .scanbot(presentGesture, dismissGesture) :
            return ScanbotTransitionAnimation(presentGesture: presentGesture, dismissGesture: dismissGesture)
        }
    }
}

public enum TRTabBarTransitionMethod: TransitionAnimationable {
    case fade
    case slide
    
    public func transitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .fade :
            return FadeTransitionAnimation(status: .tabBar)
        case .slide :
            return SlideTransitionAnimation()
        }
    }
}
