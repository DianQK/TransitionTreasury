//
//  StorehouseTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/4/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import UIKit

public class StorehouseTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public private(set) var keyView: UIView
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var completion: (() -> Void)?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    private var animationCount = 0
    
    lazy public private(set) var keyViewCopy: UIView = self.keyView.copyWithContents()
    
    init(key: UIView, status: TransitionStatus = .Push) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
//        maskLayer.frame = keyView.frame
//        maskLayer.bounds = UIScreen.mainScreen().bounds
        
        
        let startSize = CGSize(width: keyView.layer.bounds.width - 40, height: keyView.layer.bounds.height)// TODO
        let endSize = UIScreen.mainScreen().bounds.size
        
        let startPosition = keyView.layer.position
        let endPosition = UIScreen.mainScreen().center
        
        let maskLayer = CAShapeLayer()
        maskLayer.position = endPosition
        maskLayer.bounds.size = endSize
        maskLayer.contents = keyView.layer.contents

        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        
        toVC?.view.layer.mask = maskLayer
        
        let maskLayerSizeAnimation = CABasicAnimation(tr_keyPath: .bounds_size)
        maskLayerSizeAnimation.fromValue = NSValue(CGSize: startSize)
        maskLayerSizeAnimation.toValue = NSValue(CGSize: endSize)
        maskLayerSizeAnimation.duration = transitionDuration(transitionContext)
        maskLayerSizeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerSizeAnimation.delegate = self
        
//        maskLayer.addAnimation(maskLayerSizeAnimation, forKey: "size")
//        animationCount++
        toVC?.view.layer.addAnimation(maskLayerSizeAnimation, forKey: "view.size")
        animationCount++
        
        let maskLayerPositionAnimation = CABasicAnimation(tr_keyPath: .position)
        maskLayerPositionAnimation.fromValue = NSValue(CGPoint: startPosition)
        maskLayerPositionAnimation.toValue = NSValue(CGPoint: endPosition)
        maskLayerPositionAnimation.duration = transitionDuration(transitionContext)
        maskLayerPositionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerPositionAnimation.delegate = self
        
        //TODO 改 transform
        
//        maskLayer.addAnimation(maskLayerPositionAnimation, forKey: "position")
//        animationCount++
        toVC?.view.layer.addAnimation(maskLayerPositionAnimation, forKey: "view.position")
        animationCount++

    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animationCount--
        if animationCount == 0 {
        
        if !self.cancelPop {
//            if finished {
                self.completion?()
                self.completion = nil
//            }
        }
        
        self.cancelPop = false
        transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
        
        
            transitionContext?.completeTransition(!transitionContext!.transitionWasCancelled())
            transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
            transitionContext?.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
//        }
    }
    }
    
}

