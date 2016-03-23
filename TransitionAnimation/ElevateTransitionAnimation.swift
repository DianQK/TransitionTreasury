//
//  ElevateTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/31/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Like Elevate
public class ElevateTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public let maskView: UIView
    
    public let toPosition: CGPoint
    
    public private(set) lazy var maskViewCopy: UIView = self.maskView.tr_copyWithContents()
    
    private var animationCount: Int = 0
    
    public init(maskView view: UIView, toPosition position: CGPoint, status: TransitionStatus = .Present) {
        maskView = view
        toPosition = position
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        var startPosition = toVC!.view.convertPoint(maskView.layer.position, fromView: maskView.superview)
        var endPosition = toPosition
        
        let maskLayer = CAShapeLayer()
        maskLayer.position = startPosition
        maskLayer.contents = maskView.layer.contents
        
        func distance(point: CGPoint, size: CGSize) -> CGFloat {
            switch (point.x < size.width / 2, point.y < size.height / 2) {
            case (true, true) :
                return sqrt((point.x - size.width)*(point.x - size.width) + (point.y - size.height)*(point.y - size.height))
            case (true, false) :
                return sqrt((point.x - size.width)*(point.x - size.width) + point.y*point.y)
            case (false, true) :
                return sqrt(point.x*point.x + (point.y - size.height)*(point.y - size.height))
            case (false, false) :
                return sqrt(point.x*point.x + point.y*point.y)
            }
        }
        
        let distanceResult = distance(startPosition, size: toVC!.view.layer.bounds.size)
        
        var startSize = maskView.layer.bounds.size
        var endSize = maskView.layer.bounds.size.tr_heightFill(distanceResult * 2).tr_widthFill(distanceResult * 2)
        
        if transitionStatus == .Dismiss {
            swap(&fromVC, &toVC)
            swap(&startSize, &endSize)
            swap(&startPosition, &endPosition)
        }
        
        maskLayer.bounds.size = endSize
        maskViewCopy.layer.position = endPosition
        
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        toVC?.view.addSubview(maskViewCopy)
        toVC?.view.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(tr_keyPath: .bounds_size)

        maskLayerAnimation.fromValue = NSValue(CGSize: startSize)
        maskLayerAnimation.toValue = NSValue(CGSize: endSize)
        maskLayerAnimation.duration = transitionDuration(transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.delegate = self
        
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
        animationCount += 1
        
        let maskViewPositionAnimation = CABasicAnimation(tr_keyPath: .position)
        maskViewPositionAnimation.fromValue = NSValue(CGPoint: startPosition)
        maskViewPositionAnimation.toValue = NSValue(CGPoint: endPosition)
        maskViewPositionAnimation.duration = transitionDuration(transitionContext)
        maskViewPositionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskViewPositionAnimation.delegate = self
        
        maskViewCopy.layer.addAnimation(maskViewPositionAnimation, forKey: "position")
        animationCount += 1
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animationCount -= 1
        if animationCount == 0 {
            transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
            transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
            transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        }
    }
    
}
