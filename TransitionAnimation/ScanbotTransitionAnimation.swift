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
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public init(presentGesture: UIPanGestureRecognizer?, dismissGesture: UIPanGestureRecognizer?, status: TransitionStatus = .present) {
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
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containView = transitionContext.containerView
        
        var fromVCStartY: CGFloat = 0
        var fromVCEndY = UIScreen.main.bounds.height
        
        var toVCStartY = -UIScreen.main.bounds.height/3
        var toVCEndY: CGFloat = 0
        shadowOpacityBackup = shadowOpacityBackup ?? fromVC?.view.layer.shadowOpacity
        shadowOffsetBackup = shadowOffsetBackup ?? fromVC?.view.layer.shadowOffset
        shadowRadiusBackup = shadowRadiusBackup ?? fromVC?.view.layer.shadowRadius
        
        if transitionStatus == .dismiss {
            swap(&fromVC, &toVC)
            swap(&fromVCStartY, &fromVCEndY)
            swap(&toVCStartY, &toVCEndY)
        }
        
        containView.addSubview(toVC!.view)
        containView.addSubview(fromVC!.view)
        toVC?.view.frame.origin.y =  toVCStartY
        fromVC?.view.frame.origin.y = fromVCStartY
        fromVC?.view.layer.shadowOpacity = 0.5
        fromVC?.view.layer.shadowOffset = CGSize(width: 0, height: -1)
        fromVC?.view.layer.shadowRadius = 3
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            toVC?.view.frame.origin.y = toVCEndY
            fromVC?.view.frame.origin.y = fromVCEndY
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !self.cancelPop {
                    if finished {
                        self.completion?()
                        self.completion = nil
                    }
                }
                if self.transitionStatus == .dismiss {
                    fromVC?.view.layer.shadowOpacity = self.shadowOpacityBackup ?? 0
                    fromVC?.view.layer.shadowOffset = self.shadowOffsetBackup ?? CGSize(width: 0, height: 0)
                    fromVC?.view.layer.shadowRadius = self.shadowRadiusBackup ?? 0
                }
        }
    }
    
    public func slideTransition(_ sender: UIPanGestureRecognizer) {

        let fromVC = transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)

        let view = fromVC!.view
        
        let offsetY: CGFloat = transitionStatus == .present ? sender.translation(in: view).y : -sender.translation(in: view).y
        
        var percent = offsetY / (view?.bounds.size.height)!
        
        percent = min(1.0, max(0, percent))
        
        percentTransition = percentTransition ?? {
            let percentTransition = UIPercentDrivenInteractiveTransition()
            percentTransition.startInteractiveTransition(transitionContext!)
            return percentTransition
        }()
        
        switch sender.state {
        case .began :
            interacting = true
        case .changed :
            interacting = true
            percentTransition?.update(percent)
        default :
            interacting = false
            if percent > interactivePrecent {
                cancelPop = false
                percentTransition?.completionSpeed = 1.0 - percentTransition!.percentComplete
                percentTransition?.finish()
                switch transitionStatus {
                case .present :
                    presentPanGesture?.removeTarget(self, action: #selector(ScanbotTransitionAnimation.slideTransition(_:)))
                case .dismiss :
                    dismissPanGesture?.removeTarget(self, action: #selector(ScanbotTransitionAnimation.slideTransition(_:)))
                    percentTransition = nil
                default : break
                }
            } else {
                cancelPop = true
                percentTransition?.cancel()
                percentTransition = UIPercentDrivenInteractiveTransition()
            }
        }

    }
    
}
