//
//  PhotoTransitionAnimation.swift
//  TransitionTreasury
//
//  Created by 宋宋 on 12/28/15.
//  Copyright © 2015 TransitionTreasury. All rights reserved.
//

import UIKit

public class PhotoTransitionAnimation: NSObject, TRViewControllerAnimatedTransitioning {
    
    public var keyView: UIView
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var interacting: Bool = false
    
    public var percentTransition: UIPercentDrivenInteractiveTransition?
    
    public var interactivePrecent: CGFloat = 0
    
    public var completion: (() -> Void)?
    
    private var frameBackup: CGRect?
    
    private var detailVC: UIViewController?
    
    private var showVC: UIViewController?
    
    lazy private var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))//UIScreenEdgePanGestureRecognizer(target: self, action: Selector("edgePan:"))
//        eanGestureRecognizer.edges = .Left
        return panGestureRecognizer
    }()
    
    init(key: UIView, status: TransitionStatus = .Present) {
        keyView = key
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containView = transitionContext.containerView()
        
//        if transitionStatus == .Dismiss {
//            swap(&fromVC, &toVC)
//        }
        
        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)
//        containView?.addSubview(keyView)
        toVC!.view.addSubview(keyView)
        
        
        if transitionStatus == .Present {
//            toVC!.view.addGestureRecognizer(panGestureRecognizer)
            frameBackup = keyView.frame
            showVC = fromVC
            if let toVC = toVC as? ModalViewControllerDelegate {
                detailVC = toVC as? UIViewController
            } else {
                detailVC = (toVC as? UINavigationController)?.viewControllers.first
            }
            detailVC?.view.addGestureRecognizer(panGestureRecognizer)
        } else if transitionStatus == .Dismiss {
            toVC?.view.layer.opacity = 0
        }
        

//        toVC!.view.layer.opacity = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
//            toVC!.view.layer.opacity = 1
            switch self.transitionStatus! {
            case .Present :
                self.keyView.center = toVC!.view.center
                self.keyView.layer.bounds.size = self.keyView.layer.bounds.size.widthFit(toVC!.view.bounds.width)
            case .Dismiss where self.interacting == false : //Error!!!!
                toVC!.view.layer.opacity = 1
                self.keyView.layer.frame = self.frameBackup!// ?? self.keyView.layer.frame
            case .Dismiss where self.interacting == true :
                toVC!.view.layer.opacity = 1
//                self.keyView.layer.frame = self.frameBackup!
            default :
                fatalError("Transition status error.")
            }
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//                toVC?.view.addSubview(self.keyView)
                if self.transitionStatus == .Dismiss {
                    UIView.animateWithDuration(3, animations: {
                        self.keyView.layer.frame = self.frameBackup!
                    })
                }
        }
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(keyView)
        keyView.center = CGPoint(x: keyView.center.x + translation.x, y: keyView.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: keyView)
        
        var percent: CGFloat = (keyView.center.y - detailVC!.view.center.y) / detailVC!.view.bounds.height

        switch recognizer.state {
        case .Began :
            transitionStatus = .Dismiss
            interacting = true
            percentTransition = UIPercentDrivenInteractiveTransition()
            percentTransition!.startInteractiveTransition(transitionContext!)
            if let detailVC = detailVC as? MainViewControllerDelegate {
                detailVC.modalDelegate?.modalViewControllerDismiss(callbackData: nil)
            }
        case .Changed :
            percentTransition?.updateInteractiveTransition(percent)
        default :
            interacting = false
            print(percent)
            if percent > interactivePrecent {
                cancelPop = false
                percentTransition!.completionSpeed = 200 // Trick
                percentTransition?.finishInteractiveTransition()
//                keyView.removeGestureRecognizer(recognizer)
                detailVC?.view.removeGestureRecognizer(recognizer)
                recognizer.removeTarget(self, action: Selector("handlePan:"))
            } else {
                cancelPop = true
                percentTransition?.cancelInteractiveTransition()
            }
            percentTransition = nil
        }
        
    }
    
    deinit {
        print("Photo deinit")
    }
    
}

extension CGSize {
    func widthFit(width: CGFloat) -> CGSize {
        let widthPresent = width / self.width
        return CGSize(width: width, height: widthPresent * height)
    }
}
