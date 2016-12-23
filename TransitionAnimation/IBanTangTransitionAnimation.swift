//
//  BTTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/22/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Like IBanTang, View Move
open class IBanTangTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    open fileprivate(set) var keyView: UIView
    
    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    open var percentTransition: UIPercentDrivenInteractiveTransition?
    
    open var completion: (() -> Void)?
    
    open var cancelPop: Bool = false
    
    open var interacting: Bool = false
    
    lazy open fileprivate(set) var keyViewCopy: UIView = self.keyView.tr_copyWithSnapshot()
    
    public init(key: UIView, status: TransitionStatus = .push) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containView = transitionContext.containerView
        
        let lightMaskLayer: CALayer = {
            let layer =  CALayer()
            layer.frame = CGRect(origin: CGPoint.zero, size: toVC!.view.bounds.size)
            layer.backgroundColor = toVC!.view.backgroundColor?.cgColor
            let maskAnimation = CABasicAnimation(tr_keyPath: .opacity)
            maskAnimation.fromValue = 0
            maskAnimation.toValue = 1
            maskAnimation.duration = transitionDuration(using: transitionContext)
            layer.add(maskAnimation, forKey: "")
            return layer
        }()
        
        containView.addSubview(toVC!.view)
        containView.addSubview(fromVC!.view)

        if transitionStatus == .push {
            containView.layer.addSublayer(lightMaskLayer)
            keyViewCopy.layer.position = containView.convert(keyView.layer.position, from: keyView.superview)
            containView.addSubview(keyViewCopy)
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            switch self.transitionStatus {
            case .push :
                self.keyViewCopy.layer.position.y = self.keyViewCopy.layer.bounds.height / 2
            case .pop where self.interacting == true :
                fromVC!.view.layer.position.x = fromVC!.view.layer.bounds.width * 1.5
            case .pop where self.interacting == false :
                fromVC!.view.layer.opacity = 0
                self.keyViewCopy.layer.position = containView.convert(self.keyView.layer.position, from: self.keyView.superview)
            default :
                fatalError("You set false status.")
            }
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !self.cancelPop {
                    if finished {
                        self.completion?()
                        self.completion = nil
                    }
                }
                if self.transitionStatus == .push {
                    toVC?.view.addSubview(self.keyViewCopy)
                    lightMaskLayer.removeFromSuperlayer()
                }
                self.cancelPop = false
                
        }
    }

}
