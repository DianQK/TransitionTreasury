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
/// OMIN 具体实现
public class OMINTransition: NSObject, QKViewControllerAnimatedTransitioning {
    
    public var keyView: UIView?
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var bottomViews: [UIView] = []
    
    public var completion: (() -> Void)?
    
    public var lastbottomView: UIView = UIView()//{
//        get {
//            return bottomViews.last ?? {
//                bottomViews.append(UIView())
//                return bottomViews.last!
//            }()
//        }
//    }
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    init(key: UIView?, status: TransitionStatus) {
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
            lastbottomView = (fromVC as! QKTransitionData).qk_transition_data as! UIView
            topHeight = fromVC!.view.bounds.height - lastbottomView.bounds.height
            bottomHeight = lastbottomView.bounds.height
        }
        
        if transitionStatus == .Push {
            bottomViews.append(UIView()) //新加一个保存的图层
            
            topHeight = keyView!.layer.position.y + keyView!.layer.bounds.size.height / 2
            bottomHeight = fromVC!.view.layer.bounds.size.height - topHeight
            
            lastbottomView.frame = CGRect(x: 0, y: topHeight, width: fromVC!.view.layer.bounds.size.width, height: bottomHeight)
            lastbottomView.layer.contents = {
                let scale = UIScreen.mainScreen().scale
                UIGraphicsBeginImageContextWithOptions(fromVC!.view.bounds.size, true, scale)
                fromVC!.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let inRect = CGRect(x: 0, y: topHeight * scale, width: fromVC!.view.layer.bounds.size.width * scale, height: bottomHeight * scale)
                let clip = CGImageCreateWithImageInRect(image.CGImage,inRect)
                return clip
                }()
            
            (fromVC as! QKTransitionData).qk_transition_data = lastbottomView
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: fromVC!.view.layer.bounds.size.width, height: keyView!.layer.position.y + keyView!.layer.bounds.size.height / 2)).CGPath
            fromVC!.view.layer.mask = maskLayer
        } else {
            topHeight = -topHeight
            bottomHeight = -bottomHeight
        }
        containView?.addSubview(toVC!.view)
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(lastbottomView)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            fromVC!.view.layer.position.y -= topHeight
            self.lastbottomView.layer.position.y += bottomHeight
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                self.lastbottomView.removeFromSuperview() // 只要动画结束，该图层都应该删除 //先除去图层
                if !self.cancelPop {
                    if self.transitionStatus == .Pop {
                        transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
                        transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.layer.mask = nil
//                        self.bottomViews.removeLast() // Pop 完成，不再需要图层，移除 // 这步一定要后执行啊
                    }
                }
           self.cancelPop = false
                if finished {
                    self.completion?()
                    self.completion = nil
                }
        }
    }
    
    // MARK: QK
    public func popToVCIndex(index: Int) {
        let lastIndex = bottomViews.count - 1
        let firstIndex = index + 1
        if firstIndex == lastIndex {
            bottomViews.removeAtIndex(lastIndex)
        } else if lastIndex > firstIndex {
            bottomViews.removeRange(firstIndex...lastIndex)
        }
    }
}
