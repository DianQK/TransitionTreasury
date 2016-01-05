//
//  TransitionAnimationHelper.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/**
 TransitionTreasury's CAAnimation Enum.
 
 - opacity: layer.opacity
 */
public enum TRKeyPath: String {
    case opacity = "opacity"
    case bounds = "bounds"
    case bounds_size = "bounds.size"
    case bounds_height = "bounds.height"
    case bounds_width = "bounds.width"
    case position = "position"
    case transform = "transform"
    case strokeEnd = "strokeEnd"
}
// MARK: - Safety CAAnimation
public extension CABasicAnimation {
    /**
     TransitionTreasury's CABasicAnimation Init Method.
     
     - parameter path: TRKeyPath
     
     - returns: CAAnimation
     */
    public convenience init(tr_keyPath path: TRKeyPath?) {
        self.init(keyPath: path?.rawValue)
    }
}

public extension CGSize {
    /**
     Fit width without shape change.
     */
    public func widthFit(width: CGFloat) -> CGSize {
        let widthPresent = width / self.width
        return CGSize(width: width, height: widthPresent * height)
    }
    /**
     Fit height without shape change.
     */
    public func heightFit(height: CGFloat) -> CGSize {
        let heightPresent = height / self.height
        return CGSize(width: heightPresent * width, height: height)
    }
    /**
     Fill width without shape change.
     */
    public func widthFill(width: CGFloat) -> CGSize {
        switch self.width >= width {
        case true :
            return self
        case false :
            return widthFit(width)
        }
    }
    /**
     Fit height without shape change.
     */
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
    /// Get screen center.
    public var center: CGPoint {
        get {
            return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        }
    }
}

public extension CGRect {
    /** 
     Return a rectangle that precent the source rectangle, with the same center point.
     */
    public func shape(precent precent: CGFloat) -> CGRect {
        return CGRectInset(self, width * (1 - precent), height * (1 - precent))
    }
}

public extension UIView {
    /**
     Create copy contents view.
     */
    public func copyWithContents() -> UIView {
        let view = UIView(frame: frame)
        view.layer.contents = layer.contents
        view.layer.contentsGravity = layer.contentsGravity
        view.layer.contentsScale = layer.contentsScale
        view.tag = tag
        return view
    }
    /**
     Create copy snapshot view.
     */
    public func copyWithSnapshot() -> UIView {
        let view = snapshotViewAfterScreenUpdates(false)
        view.frame = frame
        return view
    }
    /**
     Add view with convert point.
     */
    public func tr_addSubview(view: UIView, convertFrom fromView: UIView) {
        view.layer.position = convertPoint(fromView.layer.position, fromView: fromView.superview)
        addSubview(view)
    }
    
}
