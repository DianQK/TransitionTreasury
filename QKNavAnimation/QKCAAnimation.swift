//
//  QKCAAnimation.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/12/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import UIKit
// More safety Core Animation
public enum QKKeyPath: String {
    case position_x = "position.x"
    case position_y = "position.y"
}

//public extension CAPropertyAnimation {
//    public convenience init(qk_keyPath path: QKKeyPath) {
//        self.init(keyPath: path.rawValue)
//    }
//}

public extension CABasicAnimation {
    public convenience init(qk_keyPath path: QKKeyPath) {
        self.init(keyPath: path.rawValue)
    }
}



