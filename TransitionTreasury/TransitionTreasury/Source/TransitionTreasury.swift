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
    case OMIN
    case Default
    case Custom
    
    func TransitionAnimation(key: UIView?) -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .OMIN :
            return OMINTransitionAnimation(key: key)
        default :
            fatalError("No this key push method!!!")
        }
    }
}

public enum TRPushMethod {
    case Default
    case Custom
}

public enum TRPresentMethod {
    case Twitter
    case Default
    case Custom
    
    func TransitionAnimation() -> TRViewControllerAnimatedTransitioning {
        switch self {
        case .Twitter :
            return TwitterTransitionAnimation()
        default :
            fatalError("No this present method.")
        }
    }
}

public enum TransitionStatus {
    case Push
    case Pop
    case Present
    case Dismiss
}

