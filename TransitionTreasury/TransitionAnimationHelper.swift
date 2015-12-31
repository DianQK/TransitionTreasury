//
//  TransitionAnimationHelper.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/**
 TransitionTreasury's CAAnimation Enum
 
 - opacity: layer.opacity
 */
public enum TRKeyPath: String {
    case opacity = "opacity"
}
// MARK: - Safety CAAnimation
public extension CABasicAnimation {
    /**
     TransitionTreasury's CABasicAnimation Init Method
     
     - parameter path: TRKeyPath
     
     - returns: CAAnimation
     */
    public convenience init(tr_keyPath path: TRKeyPath?) {
        self.init(keyPath: path?.rawValue)
    }
}

public extension CGSize {
    public func widthFit(width: CGFloat) -> CGSize {
        let widthPresent = width / self.width
        return CGSize(width: width, height: widthPresent * height)
    }
    
    public func heightFit(height: CGFloat) -> CGSize {
        let heightPresent = height / self.height
        return CGSize(width: heightPresent * width, height: height)
    }
    
    public func widthFill(width: CGFloat) -> CGSize {
        switch self.width >= width {
        case true :
            return self
        case false :
            return widthFit(width)
        }
    }
    
    public func heightFill(height: CGFloat) -> CGSize {
        switch self.height >= height {
        case true :
            return self
        case false :
            return heightFit(height)
        }
    }
}
