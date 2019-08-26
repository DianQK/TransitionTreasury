//
//  TransitionAnimationHelper.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/30/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
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
    case path = "path"
}
// MARK: - Safety CAAnimation
public extension CABasicAnimation {
    /**
     TransitionTreasury's CABasicAnimation Init Method.
     
     - parameter path: TRKeyPath
     
     - returns: CAAnimation
     */
    convenience init(tr_keyPath path: TRKeyPath?) {
        self.init(keyPath: path?.rawValue)
    }
}

public extension CGSize {
    /**
     Fit width without shape change.
     */
    func tr_widthFit(_ width: CGFloat) -> CGSize {
        let widthPresent = width / self.width
        return CGSize(width: width, height: widthPresent * height)
    }
    /**
     Fit height without shape change.
     */
    func tr_heightFit(_ height: CGFloat) -> CGSize {
        let heightPresent = height / self.height
        return CGSize(width: heightPresent * width, height: height)
    }
    /**
     Fill width without shape change.
     */
    func tr_widthFill(_ width: CGFloat) -> CGSize {
        switch self.width >= width {
        case true :
            return self
        case false :
            return tr_widthFit(width)
        }
    }
    /**
     Fit height without shape change.
     */
    func tr_heightFill(_ height: CGFloat) -> CGSize {
        switch self.height >= height {
        case true :
            return self
        case false :
            return tr_heightFit(height)
        }
    }
}

public extension UIScreen {
    /// Get screen center.
    var tr_center: CGPoint {
        get {
            return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        }
    }
}

public extension CGRect {
    /** 
     Return a rectangle that precent the source rectangle, with the same center point.
     */
    func tr_shape(_ precent: CGFloat) -> CGRect {
        return self.insetBy(dx: width * (1 - precent), dy: height * (1 - precent))
    }
    /**
     Just F**k Xcode.
     */
    var tr_ns_value: NSValue {
        get {
            return NSValue(cgRect: self)
        }
    }
}

public extension UIView {
    /**
     Create copy contents view.
     */
    func tr_copyWithContents() -> UIView {
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
    func tr_copyWithSnapshot() -> UIView {
        let view = snapshotView(afterScreenUpdates: false)
        view?.frame = frame
        return view!
    }
    /**
     Add view with convert point.
     */
    func tr_addSubview(_ view: UIView, convertFrom fromView: UIView) {
        view.layer.position = convert(fromView.layer.position, from: fromView.superview)
        addSubview(view)
    }
    
}

public extension CATransform3D {
    /**
     Just F**k Xcode.
     */
    var tr_ns_value: NSValue {
        get {
            return NSValue(caTransform3D: self)
        }
    }
}
