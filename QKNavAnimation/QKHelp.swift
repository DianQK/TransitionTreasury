//
//  QKHelp.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/13/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

import CoreGraphics

public func CGSizeCreate(multiple multiple: CGFloat, size: CGSize) -> CGSize {
    return CGSize(width: size.width * multiple,height: size.height * multiple)
}
