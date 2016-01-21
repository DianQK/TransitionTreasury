//
//  SwipeTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 16/1/21.
//  Copyright © 2016年 TransitionTreasury. All rights reserved.
//

import UIKit

public class SwipeTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var completion: (() -> Void)?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
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
        
        print(fromVCIndex,toVCIndex)
        
        let fromVCStartPositionX: CGFloat = 0
        var fromVCEndPositionX: CGFloat = -UIScreen.mainScreen().bounds.width
        var toVCStartPositionX: CGFloat = UIScreen.mainScreen().bounds.width
        let toVCEndPositionX: CGFloat = 0
        
        if fromVCIndex > toVCIndex {
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
        }
    }
    
}

