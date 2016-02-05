//
//  SlideTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/21.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit

public class SlideTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning, TabBarTransitionInteractiveable {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var completion: (() -> Void)?
    
    public var gestureRecognizer: UIGestureRecognizer? {
        didSet {
            gestureRecognizer?.addTarget(self, action: Selector("interactiveTransition:"))
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
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        guard let tabBarController = fromVC?.tabBarController else { fatalError("No TabBarController.") }
        guard let fromVCIndex = tabBarController.viewControllers?.indexOf(fromVC!), toVCIndex = tabBarController.viewControllers?.indexOf(toVC!) else {
            fatalError("VC not in TabBarController.")
        }
        
        let fromVCStartPositionX: CGFloat = 0
        var fromVCEndPositionX: CGFloat = -UIScreen.mainScreen().bounds.width
        var toVCStartPositionX: CGFloat = UIScreen.mainScreen().bounds.width
        let toVCEndPositionX: CGFloat = 0
        
        tabBarTransitionDirection = TabBarTransitionDirection.TransitionDirection(fromVCIndex, toVCIndex: toVCIndex)
        print(tabBarTransitionDirection)
        
        if tabBarTransitionDirection == .Left {
            swap(&fromVCEndPositionX, &toVCStartPositionX)
        }
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        
        fromVC?.view.layer.position.x = fromVCStartPositionX + toVC!.view.layer.bounds.width / 2
        toVC?.view.layer.position.x = toVCStartPositionX + toVC!.view.layer.bounds.width / 2
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            fromVC?.view.layer.position.x = fromVCEndPositionX + toVC!.view.layer.bounds.width / 2
            toVC?.view.layer.position.x = toVCEndPositionX + toVC!.view.layer.bounds.width / 2
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if !transitionContext.transitionWasCancelled() && finished {
                    self.completion?()
                    self.completion = nil
                }
        }
    }
    
    public func interactiveTransition(sender: UIPanGestureRecognizer) {
        let fromVC = transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        let view = fromVC!.view
        
        let offsetX: CGFloat = tabBarTransitionDirection == .Left ? sender.translationInView(view).x : -sender.translationInView(view).x
        
        var percent = offsetX / view.bounds.size.width
        
        percent = min(1.0, max(0, percent))
        
        switch sender.state {
        case .Began :
            percentTransition.startInteractiveTransition(transitionContext!)
            interacting = true
        case .Changed :
            interacting = true
            percentTransition.updateInteractiveTransition(percent)
        default :
            interacting = false
            if percent > interactivePrecent {
                percentTransition.completionSpeed = 1.0 - percentTransition.percentComplete
                percentTransition.finishInteractiveTransition()
                gestureRecognizer?.removeTarget(self, action: Selector("interactiveTransition:"))
            } else {
                percentTransition.cancelInteractiveTransition()
            }
        }
    }
    
}

