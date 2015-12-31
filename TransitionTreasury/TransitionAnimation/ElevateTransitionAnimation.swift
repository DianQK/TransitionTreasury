//
//  ElevateTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/31/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public class ElevateTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public let maskView: UIView
    
    public init(maskView view: UIView, status: TransitionStatus = .Present) {
        maskView = view
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
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
        
        if transitionStatus == .Dismiss {
            swap(&fromVC, &toVC)
            swap(&startSize, &endSize)
        }
        
        maskLayer.bounds.size = endSize
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        toVC?.view.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(keyPath: "bounds.size")

        maskLayerAnimation.fromValue = NSValue(CGSize: startSize)
        maskLayerAnimation.toValue = NSValue(CGSize: endSize)
        maskLayerAnimation.duration = transitionDuration(transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.delegate = self
        
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
        
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //告诉 iOS 这个 transition 完成
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
        //清除 fromVC 的 mask
        transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
        transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
    }
    
}
