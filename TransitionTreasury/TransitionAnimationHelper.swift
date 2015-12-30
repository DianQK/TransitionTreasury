
//
//  TransitionAnimationHelper.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public enum TRKeyPath: String {
    case opacity = "opacity"
}

//public extension CAPropertyAnimation {
//    public convenience init(tr_keyPath path: TRKeyPath?) {
//        self.init(keyPath: path?.rawValue)
//    }
//}

public extension CABasicAnimation {
    public convenience init(tr_keyPath path: TRKeyPath?) {
        self.init(keyPath: path?.rawValue)
    }
}
