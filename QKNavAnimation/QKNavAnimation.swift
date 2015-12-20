//
//  QKNavAnimation.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/11/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit
// 枚举定义
public enum QKKeyPushMethod {
    case OMIN
    case Default
    case Custom
    
    func TransitionAnimation(key: UIView?) -> QKViewControllerAnimatedTransitioning {
        switch self {
        case .OMIN :
            return OMINTransition(key: key)
        default :
            fatalError("No this key push method!!!")
        }
    }
}

public enum QKPushMethod {
    case Default
    case Custom
}

public enum QKPresentMethod {
    case Twitter
    case Default
    case Custom
    
    func TransitionAnimation() -> QKViewControllerAnimatedTransitioning {
        switch self {
        case .Twitter :
            return TwitterTransition()
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
