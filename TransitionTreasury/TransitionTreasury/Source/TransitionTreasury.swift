//
//  TransitionTreasury.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/20/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
// 枚举定义
public enum TRKeyPushMethod {
    case OMIN(UIView)
    case Custom(TRViewControllerAnimatedTransitioning)
    
    func TransitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case let .OMIN(key) :
            return OMINTransitionAnimation(key: key)
        case let .Custom(transition) :
            return transition
        }
    }
}

public enum TRPushMethod {
    case Default
    case Custom(TRViewControllerAnimatedTransitioning)
}

public enum TRPresentMethod {
    case Twitter
    case Custom(TRViewControllerAnimatedTransitioning)
    
    func TransitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .Twitter :
            return TwitterTransitionAnimation()
        case let .Custom(transition) :
            return transition
        }
    }
}

public enum TransitionStatus {
    case Push
    case Pop
    case Present
    case Dismiss
}

