//
//  ScanbotTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 1/14/16.
//  Copyright © 2016 TransitionTreasury. All rights reserved.
//

import TransitionTreasury
/// Like Scanbot present.
public class ScanbotTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TransitionInteractiveable {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition? = UIPercentDrivenInteractiveTransition()
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    public var edgeSlidePop: Bool = false
    
    public var completion: (() -> Void)?
    
    private let presentPanGesture: UIPanGestureRecognizer?
    
    private let dismissPanGesture: UIPanGestureRecognizer?
    
    private var shadowOpacityBackup: Float?
    private var shadowOffsetBackup: CGSize?
    private var shadowRadiusBackup: CGFloat?
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public init(presentGesture: UIPanGestureRecognizer?, dismissGesture: UIPanGestureRecognizer?, status: TransitionStatus = .Present) {
        presentPanGesture = presentGesture
        dismissPanGesture = dismissGesture
        transitionStatus = status
        super.init()
        if presentPanGesture != nil {
            presentPanGesture?.addTarget(self, action: #selector(ScanbotTransitionAnimation.slideTransition(_:)))
            interacting = true
        }
        dismissPanGesture?.addTarget(self, action: #selector(ScanbotTransitionAnimation.slideTransition(_:)))
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        var fromVCStartY: CGFloat = 0
        var fromVCEndY = UIScreen.mainScreen().bounds.height
        
        var toVCStartY = -UIScreen.mainScreen().bounds.height/3
        var toVCEndY: CGFloat = 0
        shadowOpacityBackup = shadowOpacityBackup ?? fromVC?.view.layer.shadowOpacity
        shadowOffsetBackup = shadowOffsetBackup ?? fromVC?.view.layer.shadowOffset
        shadowRadiusBackup = shadowRadiusBackup ?? fromVC?.view.layer.shadowRadius
        
        if transitionStatus == .Dismiss {
            swap(&fromVC, &toVC)
            swap(&fromVCStartY, &fromVCEndY)
            swap(&toVCStartY, &toVCEndY)
        }
        
        containView?.addSubview(toVC!.view)
        containView?.addSubview(fromVC!.view)
        toVC?.view.frame.origin.y =  toVCStartY
        fromVC?.view.frame.origin.y = fromVCStartY
        fromVC?.view.layer.shadowOpacity = 0.5
        fromVC?.view.layer.shadowOffset = CGSize(width: 0, height: -1)
        fromVC?.view.layer.shadowRadius = 3
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            toVC?.view.frame.origin.y = toVCEndY
            fromVC?.view.frame.origin.y = fromVCEndY
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if !self.cancelPop {
                    if finished {
                        self.completion?()
                        self.completion = nil
                    }
                }
                if self.transitionStatus == .Dismiss {
                    fromVC?.view.layer.shadowOpacity = self.shadowOpacityBackup ?? 0
                    fromVC?.view.layer.shadowOffset = self.shadowOffsetBackup ?? CGSize(width: 0, height: 0)
                    fromVC?.view.layer.shadowRadius = self.shadowRadiusBackup ?? 0
                }
        }
    }
    
    public func slideTransition(sender: UIPanGestureRecognizer) {

        let fromVC = transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)

        let view = fromVC!.view
        
        let offsetY: CGFloat = transitionStatus == .Present ? sender.translationInView(view).y : -sender.translationInView(view).y
        
        var percent = offsetY / view.bounds.size.height
        
        percent = min(1.0, max(0, percent))
        
        percentTransition = percentTransition ?? {
            let percentTransition = UIPercentDrivenInteractiveTransition()
            percentTransition.startInteractiveTransition(transitionContext!)
            return percentTransition
        }()
        
        switch sender.state {
        case .Began :
            interacting = true
        case .Changed :
            interacting = true
            percentTransition?.updateInteractiveTransition(percent)
        default :
            interacting = false
            if percent > interactivePrecent {
                cancelPop = false
                percentTransition?.completionSpeed = 1.0 - percentTransition!.percentComplete
                percentTransition?.finishInteractiveTransition()
                switch transitionStatus {
                case .Present :
                    presentPanGesture?.removeTarget(self, action: #selector(ScanbotTransitionAnimation.slideTransition(_:)))
                case .Dismiss :
                    dismissPanGesture?.removeTarget(self, action: #selector(ScanbotTransitionAnimation.slideTransition(_:)))
                    percentTransition = nil
                default : break
                }
            } else {
                cancelPop = true
                percentTransition?.cancelInteractiveTransition()
                percentTransition = UIPercentDrivenInteractiveTransition()
            }
        }

    }
    
}
