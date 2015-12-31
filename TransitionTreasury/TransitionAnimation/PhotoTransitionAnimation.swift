//
//  PhotoTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by DianQK on 12/28/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit
/// Beta
public class PhotoTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var keyView: UIView
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var interacting: Bool = false
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var interactivePrecent: CGFloat = 0
    
    public var completion: (() -> Void)?
    
    private var frameBackup: CGRect?
    
    private var gesturesBackup: [UIGestureRecognizer]?
    
    private var detailVC: UIViewController?
    
    private var showVC: UIViewController?
    
    lazy private var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        return panGestureRecognizer
    }()
    
    init(key: UIView, status: TransitionStatus = .Present) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
        toVC?.view.addSubview(keyView)
        
        
        if transitionStatus == .Present {
            frameBackup = keyView.frame
            showVC = fromVC
            if let toVC = toVC as? ModalViewControllerDelegate {
                detailVC = toVC as? UIViewController
            } else {
                detailVC = (toVC as? UINavigationController)?.viewControllers.first
            }
            detailVC?.view.addGestureRecognizer(panGestureRecognizer)
            gesturesBackup = keyView.gestureRecognizers?.flatMap({ (gesture) -> UIGestureRecognizer? in
                self.keyView.removeGestureRecognizer(gesture)
                return gesture
            })
        } else if transitionStatus == .Dismiss {
            toVC?.view.layer.opacity = 0
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .CurveEaseInOut, animations: {
            switch self.transitionStatus! {
            case .Present :
                self.keyView.center = toVC!.view.center
                self.keyView.layer.bounds.size = self.keyView.layer.bounds.size.widthFit(toVC!.view.bounds.width)
            case .Dismiss where self.interacting == false :
                toVC!.view.layer.opacity = 1
                self.keyView.layer.frame = self.frameBackup!
            case .Dismiss where self.interacting == true :
                toVC!.view.layer.opacity = 1
            default :
                fatalError("Transition status error.")
            }
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if self.transitionStatus == .Dismiss {
                    UIView.animateWithDuration(3, animations: {
                        self.keyView.layer.frame = self.frameBackup!
                    })
                }
                if finished {
                    if self.transitionStatus == .Dismiss {
                        self.gesturesBackup?.forEach({ (gesture) -> () in
                            self.keyView.addGestureRecognizer(gesture)
                        })
                        self.gesturesBackup = nil
                    }
                    self.completion?()
                    self.completion = nil
                }
                
        }
        
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(keyView)
        keyView.center = CGPoint(x: keyView.center.x + translation.x, y: keyView.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: keyView)
        
        let percent: CGFloat = min(1.0, max(0, (keyView.center.y - detailVC!.view.center.y) / detailVC!.view.bounds.height))
        
        switch recognizer.state {
        case .Began :
            if translation.y > 0 {
                transitionStatus = .Dismiss
                interacting = true
                percentTransition = UIPercentDrivenInteractiveTransition()
                percentTransition!.startInteractiveTransition(transitionContext!)
                if let detailVC = detailVC as? MainViewControllerDelegate {
                    detailVC.modalDelegate?.modalViewControllerDismiss(callbackData: nil)
                }
            } else {
                interacting = false
            }
        case .Changed :
            percentTransition?.updateInteractiveTransition(percent)
        default :
            if interacting == true {
                interacting = false
                if translation.y >= 0 {
                    cancelPop = false
                    percentTransition?.completionSpeed = 200
                    percentTransition?.finishInteractiveTransition()
                } else {
                    cancelPop = true
                    percentTransition?.cancelInteractiveTransition()
                }
                percentTransition = nil
            } else {
                UIView.animateWithDuration(0.3, animations: {
                    self.keyView.center = self.detailVC!.view.center
                })
            }
        }
        
    }
    
}
