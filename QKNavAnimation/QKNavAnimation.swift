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
}

public enum QKPushMethod {
    case Default
    case Custom
}

public enum QKPresentMethod {
    case Twitter
    case Default
    case Custom
}

public enum TransitionStatus {
    case Push
    case Pop
    case Present
    case Dismiss
}

public func QKCreateKeyPushTransition(method: QKKeyPushMethod, key: UIView?, status: TransitionStatus) -> QKViewControllerAnimatedTransitioning {
    switch method {
    case .OMIN :
        return OMINTransition(key: key, status: status)
    default :
        fatalError("No this key push method!!!")
    }
}

//public func QKCreatePushTransition(method: QKPushMethod, status: TransitionStatus) -> QKViewControllerAnimatedTransitioning {
//    switch method {
//    case .Custom {
//        return nil
//        }
//    }
//}

public func QKCreatePresentTransition(method: QKPresentMethod, status: TransitionStatus) -> QKViewControllerAnimatedTransitioning {
    switch method {
    case .Twitter :
        return TwitterTransition(status: status)
    default :
        fatalError("No this present method!!!")
    }
}
