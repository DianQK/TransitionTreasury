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
    case bounds_size = "bounds.size"
    case position = "position"
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

public extension UIScreen {
    public var center: CGPoint {
        get {
            return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        }
    }
}

public extension CGRect {
    public func shape(precent precent: CGFloat) -> CGRect {
        return CGRectInset(self, width * (1 - precent), height * (1 - precent))
    }
}
