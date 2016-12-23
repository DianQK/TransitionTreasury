//
//  SlideTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/21.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import TransitionTreasury

open class SlideTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TabBarTransitionInteractiveable {
    
    open var transitionStatus: TransitionStatus
    
    open var transitionContext: UIViewControllerContextTransitioning?
    
    open var completion: (() -> Void)?
    
    open var gestureRecognizer: UIGestureRecognizer? {
        didSet {
            gestureRecognizer?.addTarget(self, action: #selector(SlideTransitionAnimation.interactiveTransition(_:)))
        }
    }
    
    open var percentTransition: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    
    open var interactivePrecent: CGFloat = 0.3
    
    open var interacting: Bool = false
    
    fileprivate var tabBarTransitionDirection: TabBarTransitionDirection = .right
    
    public init(status: TransitionStatus = .tabBar) {
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
        guard let tabBarController = fromVC?.tabBarController else { fatalError("No TabBarController.") }
        guard let fromVCIndex = tabBarController.viewControllers?.index(of: fromVC!)
            , let toVCIndex = tabBarController.viewControllers?.index(of: toVC!) else {
            fatalError("VC not in TabBarController.")
        }
        
        let fromVCStartOriginX: CGFloat = 0
        var fromVCEndOriginX: CGFloat = -UIScreen.main.bounds.width
        var toVCStartOriginX: CGFloat = UIScreen.main.bounds.width
        let toVCEndOriginX: CGFloat = 0
        
        tabBarTransitionDirection = TabBarTransitionDirection.TransitionDirection(fromVCIndex, toVCIndex: toVCIndex)
        
        if tabBarTransitionDirection == .left {
            swap(&fromVCEndOriginX, &toVCStartOriginX)
        }
        
        containView.addSubview(fromVC!.view)
        containView.addSubview(toVC!.view)
        
        fromVC?.view.frame.origin.x = fromVCStartOriginX
        toVC?.view.frame.origin.x = toVCStartOriginX
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromVC?.view.frame.origin.x = fromVCEndOriginX
            toVC?.view.frame.origin.x = toVCEndOriginX
            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !transitionContext.transitionWasCancelled && finished {
                    self.completion?()
                    self.completion = nil
                }
        }
    }
    
    open func interactiveTransition(_ sender: UIPanGestureRecognizer) {
        
        guard let view = sender.view else { return }
        
        let offsetX = tabBarTransitionDirection == .left ? sender.translation(in: view).x : -sender.translation(in: view).x
        
        var percent = offsetX / view.bounds.size.width
        
        percent = min(1.0, max(0, percent))
        
        switch sender.state {
        case .began :
            percentTransition.startInteractiveTransition(transitionContext!)
            interacting = true
        case .changed :
            interacting = true
            percentTransition.update(percent)
        default :
            interacting = false
            if percent > interactivePrecent {
                percentTransition.completionSpeed = 1.0 - percentTransition.percentComplete
                percentTransition.finish()
                gestureRecognizer?.removeTarget(self, action: #selector(SlideTransitionAnimation.interactiveTransition(_:)))
            } else {
                percentTransition.cancel()
            }
        }
    }
    
}

