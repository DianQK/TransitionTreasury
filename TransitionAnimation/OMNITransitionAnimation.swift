//
//  OMINTransition.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// OmniFocus app push transition implement.
public class OMNITransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {

    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?

    public var completion: (() -> Void)?

    public var bottomView: UIView = UIView()

    public var cancelPop: Bool = false

    public var interacting: Bool = false
    
    public private(set) var keyView: UIView
    
    public init(key: UIView, status: TransitionStatus = .Push) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        var topHeight: CGFloat = 0
        var bottomHeight = fromVC!.view.layer.bounds.size.height - topHeight
        
        if transitionStatus == .Pop {
            swap(&fromVC, &toVC)
            topHeight = fromVC!.view.bounds.height - bottomView.bounds.height
            bottomHeight = bottomView.bounds.height
        }
        
        if transitionStatus == .Push {
            
            topHeight = containView!.convertPoint(keyView.layer.position, fromView: keyView.superview).y + keyView.layer.bounds.size.height / 2
            bottomHeight = fromVC!.view.layer.bounds.size.height - topHeight
            
            bottomView.frame = CGRect(x: 0, y: topHeight, width: fromVC!.view.layer.bounds.size.width, height: bottomHeight)
            bottomView.layer.contents = {
                let scale = UIScreen.mainScreen().scale
                UIGraphicsBeginImageContextWithOptions(fromVC!.view.bounds.size, true, scale)
                fromVC!.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let inRect = CGRect(x: 0, y: topHeight * scale, width: fromVC!.view.layer.bounds.size.width * scale, height: bottomHeight * scale)
                let clip = CGImageCreateWithImageInRect(image.CGImage,inRect)
                return clip
                }()
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: fromVC!.view.layer.bounds.size.width, height: topHeight)).CGPath
            fromVC!.view.layer.mask = maskLayer
        } else {
            topHeight = -topHeight
            bottomHeight = -bottomHeight
        }
        containView?.addSubview(toVC!.view)
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(bottomView)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            fromVC!.view.layer.position.y -= topHeight
            self.bottomView.layer.position.y += bottomHeight
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                self.bottomView.removeFromSuperview()
                if !self.cancelPop {
                    if self.transitionStatus == .Pop {
                        transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
                        transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
                    }
                    if finished {
                        self.completion?()
                        self.completion = nil
                    }
                }
           self.cancelPop = false
        }
    }
}
