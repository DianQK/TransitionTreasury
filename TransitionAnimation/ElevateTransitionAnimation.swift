//
//  ElevateTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/31/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Like Elevate
open class ElevateTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    open let maskView: UIView
    
    open let toPosition: CGPoint
    
    open fileprivate(set) lazy var maskViewCopy: UIView = self.maskView.tr_copyWithContents()
    
    fileprivate var animationCount: Int = 0
    
    public init(maskView view: UIView, toPosition position: CGPoint, status: TransitionStatus = .present) {
        maskView = view
        toPosition = position
        transitionStatus = status
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containView = transitionContext.containerView
        
        var startPosition = toVC!.view.convert(maskView.layer.position, from: maskView.superview)
        var endPosition = toPosition
        
        let maskLayer = CAShapeLayer()
        maskLayer.position = startPosition
        maskLayer.contents = maskView.layer.contents
        
        func distance(_ point: CGPoint, size: CGSize) -> CGFloat {
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
        
        if transitionStatus == .dismiss {
            swap(&fromVC, &toVC)
            swap(&startSize, &endSize)
            swap(&startPosition, &endPosition)
        }
        
        maskLayer.bounds.size = endSize
        maskViewCopy.layer.position = endPosition
        
        
        containView.addSubview(fromVC!.view)
        containView.addSubview(toVC!.view)
        toVC?.view.addSubview(maskViewCopy)
        toVC?.view.layer.mask = maskLayer

        let maskLayerAnimation = CABasicAnimation(tr_keyPath: .bounds_size)

        maskLayerAnimation.fromValue = NSValue(cgSize: startSize)
        maskLayerAnimation.toValue = NSValue(cgSize: endSize)
        maskLayerAnimation.duration = transitionDuration(using: transitionContext)
        maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimation.delegate = self
        
        maskLayer.add(maskLayerAnimation, forKey: "path")
        animationCount += 1
        
        let maskViewPositionAnimation = CABasicAnimation(tr_keyPath: .position)
        maskViewPositionAnimation.fromValue = NSValue(cgPoint: startPosition)
        maskViewPositionAnimation.toValue = NSValue(cgPoint: endPosition)
        maskViewPositionAnimation.duration = transitionDuration(using: transitionContext)
        maskViewPositionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskViewPositionAnimation.delegate = self
        
        maskViewCopy.layer.add(maskViewPositionAnimation, forKey: "position")
        animationCount += 1
    }
    
}

extension ElevateTransitionAnimation: CAAnimationDelegate {

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCount -= 1
        if animationCount == 0 {
            transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled)
            transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
            transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
        }
    }

}
