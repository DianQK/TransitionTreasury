//
//  ElevateTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/31/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/// Like Elevate (No Bounce)
public class ElevateTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public let maskView: UIView
    
    public let toPosition: CGPoint
    
    private lazy var maskViewCopy: UIView = {
        let maskViewCopy = UIView(frame: self.maskView.frame)
        maskViewCopy.layer.contents = self.maskView.layer.contents
        maskViewCopy.layer.position = self.maskView.layer.position
        return maskViewCopy
    }()
    
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
        
        let maskLayer = CAShapeLayer()
        maskLayer.position = maskView.layer.position
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
        
        let distanceResult = distance(maskView.layer.position, size: toVC!.view.layer.bounds.size)
        
        var startSize = maskView.layer.bounds.size
        var endSize = maskView.layer.bounds.size.heightFill(distanceResult * 2).widthFill(distanceResult * 2)
        
        var startPosition = maskView.layer.position
        var endPosition = toPosition
        
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
        animationCount++
        
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
        
        let maskViewPositionAnimation = CABasicAnimation(tr_keyPath: .position)
        maskViewPositionAnimation.fromValue = NSValue(CGPoint: startPosition)
        maskViewPositionAnimation.toValue = NSValue(CGPoint: endPosition)
        maskViewPositionAnimation.duration = transitionDuration(transitionContext)
        maskViewPositionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskViewPositionAnimation.delegate = self
        animationCount++
        
        maskViewCopy.layer.addAnimation(maskViewPositionAnimation, forKey: "position")
        
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animationCount--
        if animationCount == 0 {
            transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
            transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
            transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
        }
    }
    
}
