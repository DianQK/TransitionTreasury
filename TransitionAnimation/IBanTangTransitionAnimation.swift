//
//  BTTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/22/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Like IBanTang, View Move
public class IBanTangTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    public private(set) var keyView: UIView
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var completion: (() -> Void)?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    lazy public private(set) var keyViewCopy: UIView = self.keyView.tr_copyWithSnapshot()
    
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
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        let lightMaskLayer: CALayer = {
            let layer =  CALayer()
            layer.frame = CGRect(origin: CGPointZero, size: toVC!.view.bounds.size)
            layer.backgroundColor = toVC!.view.backgroundColor?.CGColor
            let maskAnimation = CABasicAnimation(tr_keyPath: .opacity)
            maskAnimation.fromValue = 0
            maskAnimation.toValue = 1
            maskAnimation.duration = transitionDuration(transitionContext)
            layer.addAnimation(maskAnimation, forKey: "")
            return layer
        }()
        
        containView?.addSubview(toVC!.view)
        containView?.addSubview(fromVC!.view)

        if transitionStatus == .Push {
            containView?.layer.addSublayer(lightMaskLayer)
            keyViewCopy.layer.position = containView!.convertPoint(keyView.layer.position, fromView: keyView.superview)
            containView?.addSubview(keyViewCopy)
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            switch self.transitionStatus {
            case .Push :
                self.keyViewCopy.layer.position.y = self.keyViewCopy.layer.bounds.height / 2
            case .Pop where self.interacting == true :
                fromVC!.view.layer.position.x = fromVC!.view.layer.bounds.width * 1.5
            case .Pop where self.interacting == false :
                fromVC!.view.layer.opacity = 0
                self.keyViewCopy.layer.position = containView!.convertPoint(self.keyView.layer.position, fromView: self.keyView.superview)
            default :
                fatalError("You set false status.")
            }
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if !self.cancelPop {
                    if finished {
                        self.completion?()
                        self.completion = nil
                    }
                }
                if self.transitionStatus == .Push {
                    toVC?.view.addSubview(self.keyViewCopy)
                    lightMaskLayer.removeFromSuperlayer()
                }
                self.cancelPop = false
                
        }
    }

}
