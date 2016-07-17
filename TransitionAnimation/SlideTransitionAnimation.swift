//
//  SlideTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/21.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import TransitionTreasury

public class SlideTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TabBarTransitionInteractiveable {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var completion: (() -> Void)?
    
    public var gestureRecognizer: UIGestureRecognizer? {
        didSet {
            gestureRecognizer?.addTarget(self, action: #selector(SlideTransitionAnimation.interactiveTransition(sender:)))
        }
    }
    
    public var percentTransition: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    
    public var interactivePrecent: CGFloat = 0.3
    
    public var interacting: Bool = false
    
    private var tabBarTransitionDirection: TabBarTransitionDirection = .Right
    
    public init(status: TransitionStatus = .TabBar) {
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        guard let tabBarController = fromVC?.tabBarController else { fatalError("No TabBarController.") }
        guard let fromVCIndex = tabBarController.viewControllers?.index(of: fromVC!), toVCIndex = tabBarController.viewControllers?.index(of: toVC!) else {
            fatalError("VC not in TabBarController.")
        }
        
        let fromVCStartOriginX: CGFloat = 0
        var fromVCEndOriginX: CGFloat = -UIScreen.main().bounds.width
        var toVCStartOriginX: CGFloat = UIScreen.main().bounds.width
        let toVCEndOriginX: CGFloat = 0
        
        tabBarTransitionDirection = TabBarTransitionDirection.TransitionDirection(fromVCindex: fromVCIndex, toVCIndex: toVCIndex)
        
        if tabBarTransitionDirection == .Left {
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
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if !transitionContext.transitionWasCancelled() && finished {
                    self.completion?()
                    self.completion = nil
                }
        }
    }
    
    public func interactiveTransition(sender: UIPanGestureRecognizer) {
        
        guard let view = sender.view else { return }
        
        let offsetX = tabBarTransitionDirection == .Left ? sender.translation(in: view).x : -sender.translation(in: view).x
        
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
                gestureRecognizer?.removeTarget(self, action: #selector(SlideTransitionAnimation.interactiveTransition(sender:)))
            } else {
                percentTransition.cancel()
            }
        }
    }
    
}

