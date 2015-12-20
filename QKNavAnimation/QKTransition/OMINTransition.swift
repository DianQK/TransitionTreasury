//
//  OMINTransition.swift
//  QKNavAnimation
//
//  Created by 宋宋 on 12/11/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

/*   支持横屏。但不支持实时旋转
*/

import UIKit
/// OMIN 转场的实现
public class OMINTransition: NSObject, QKViewControllerAnimatedTransitioning {
    /// 分割的边界视图
    public var keyView: UIView?
    /// 转场状态
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    /// 动画结束执行的闭包
    public var completion: (() -> Void)?
    /// 分割的下半部分视图
    public var bottomView: UIView = UIView()
    /// 判断是否取消了 Pop
    public var cancelPop: Bool = false
    /// 判断是否在交互中
    public var interacting: Bool = false
    
    init(key: UIView?, status: TransitionStatus = .Push) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        var topHeight: CGFloat = 0// = keyView!.layer.position.y + keyView!.layer.bounds.size.height / 2
        var bottomHeight = fromVC!.view.layer.bounds.size.height - topHeight
        
        if transitionStatus == .Pop {
            swap(&fromVC, &toVC)
            topHeight = fromVC!.view.bounds.height - bottomView.bounds.height
            bottomHeight = bottomView.bounds.height
        }
        
        if transitionStatus == .Push {
            
            topHeight = keyView!.layer.position.y + keyView!.layer.bounds.size.height / 2
            bottomHeight = fromVC!.view.layer.bounds.size.height - topHeight
            
            bottomView.frame = CGRect(x: 0, y: topHeight, width: fromVC!.view.layer.bounds.size.width, height: bottomHeight)
            bottomView.layer.contents = {
                let scale = UIScreen.mainScreen().scale
                UIGraphicsBeginImageContextWithOptions(fromVC!.view.bounds.size, true, scale)
                fromVC!.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let inRect = CGRect(x: 0, y: topHeight * scale, width: fromVC!.view.layer.bounds.size.width * scale, height: bottomHeight * scale)
                let clip = CGImageCreateWithImageInRect(image.CGImage,inRect)
                return clip
                }()
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: fromVC!.view.layer.bounds.size.width, height: keyView!.layer.position.y + keyView!.layer.bounds.size.height / 2)).CGPath
            fromVC!.view.layer.mask = maskLayer
        } else {
            topHeight = -topHeight
            bottomHeight = -bottomHeight
        }
        containView?.addSubview(toVC!.view)
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(bottomView)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            fromVC!.view.layer.position.y -= topHeight
            self.bottomView.layer.position.y += bottomHeight
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                self.bottomView.removeFromSuperview() // 只要动画结束，该图层都应该移除
                if !self.cancelPop {
                    if self.transitionStatus == .Pop {
                        transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
                        transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
                    }
                    if finished {
                        self.completion?()
                        self.completion = nil
                    }
                }
           self.cancelPop = false
        }
    }
    
    deinit {
        print("OMIN deinit")
    }
}
