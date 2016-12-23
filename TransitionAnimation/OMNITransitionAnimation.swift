//
//  OMINTransition.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/20/15.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// OmniFocus app push transition implement.
open class OMNITransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {

    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    open var percentTransition: UIPercentDrivenInteractiveTransition?

    open var completion: (() -> Void)?

    open var bottomView: UIView = UIView()

    open var cancelPop: Bool = false

    open var interacting: Bool = false
    
    open fileprivate(set) var keyView: UIView
    
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
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containView = transitionContext.containerView
        
        var topHeight: CGFloat = 0
        var bottomHeight = fromVC!.view.layer.bounds.size.height - topHeight
        
        if transitionStatus == .pop {
            swap(&fromVC, &toVC)
            topHeight = fromVC!.view.bounds.height - bottomView.bounds.height
            bottomHeight = bottomView.bounds.height
        }
        
        if transitionStatus == .push {
            
            topHeight = containView.convert(keyView.layer.position, from: keyView.superview).y + keyView.layer.bounds.size.height / 2
            bottomHeight = fromVC!.view.layer.bounds.size.height - topHeight
            
            bottomView.frame = CGRect(x: 0, y: topHeight, width: fromVC!.view.layer.bounds.size.width, height: bottomHeight)
            bottomView.layer.contents = {
                let scale = UIScreen.main.scale
                UIGraphicsBeginImageContextWithOptions(fromVC!.view.bounds.size, true, scale)
                fromVC!.view.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                let inRect = CGRect(x: 0, y: topHeight * scale, width: fromVC!.view.layer.bounds.size.width * scale, height: bottomHeight * scale)
                let clip = image.cgImage?.cropping(to: inRect)
                return clip
                }()
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: fromVC!.view.layer.bounds.size.width, height: topHeight)).cgPath
            fromVC!.view.layer.mask = maskLayer
        } else {
            topHeight = -topHeight
            bottomHeight = -bottomHeight
        }
        containView.addSubview(toVC!.view)
        containView.addSubview(fromVC!.view)
        containView.addSubview(bottomView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: {
            fromVC!.view.layer.position.y -= topHeight
            self.bottomView.layer.position.y += bottomHeight
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                self.bottomView.removeFromSuperview()
                if !self.cancelPop {
                    if self.transitionStatus == .pop {
                        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
                        transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil
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
