## Fade Animation   

Just let your Class conform `TRViewControllerAnimatedTransitioning`, I name the class is `FadeTransitionAnimation`. You should implement:       

```swift
/// Required implement.
var transitionStatus: TransitionStatus?{get set}
/// Rquired implement.
var transitionContext: UIViewControllerContextTransitioning?{get set}
```    

Just add:   

```swift
public var transitionStatus: TransitionStatus?
public var transitionContext: UIViewControllerContextTransitioning?
```

You can also add：   

```swift
var interacting: Bool{get set}
/// Rquired implement.
var transitionContext: UIViewControllerContextTransitioning?{get set}
    
var cancelPop: Bool{get set}
/// Option
var completion: (() -> Void)?{get set}
/// Option
var interactivePrecent: CGFloat{get}
/**
Option

- parameter index: index of navgationViewController.viewcontrollers
*/
func popToVCIndex(index: Int)
```       

> Note：   
> this property and method just use for `TRNavgationTransitionDelegate` and `TRViewControllerTransitionDelegate`. You should set `tansitionContext`.   

We need a `init` method, here we don't need other parameters.    

We also should implement this methods, due to `TRViewControllerAnimatedTransitioning` conform `UIViewControllerAnimatedTransitioning`:     

```swift
// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation. 
public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
public func animateTransition(transitionContext: UIViewControllerContextTransitioning)
```     

For `transitionDuration(_:)`, set return 0.3s:   

```swift
public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
```    

For `animateTransition(_:)`, here is `Present` code:    

```swift
public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    let containView = transitionContext.containerView()
    
    containView?.addSubview(fromVC!.view)
    containView?.addSubview(toVC!.view)
    toVC!.view.layer.opacity = 0
    
    UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
        toVC!.view.layer.opacity = 1
        }) { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
}
```    

Hey~ We have completed `Dismiss`, same to `Present`~     

> For more, we can swap `fromVC` and `toVC`, or rename to you like.     
> You can see Full code on [FadeTransitionAnimation](https://github.com/DianQK/TransitionTreasury/Source/FadeTransitionAnimation).   
> About more animation, you can read `[官方文档](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html)、[A GUIDE TO IOS ANIMATION](http://book.kittenyang.com)、[iOS Core Animation Advanced Techniques](http://www.amazon.com/iOS-Core-Animation-Advanced-Techniques-ebook/dp/B00EHJCORC)、[iOS Animations by Tutorials Second Edition](http://www.raywenderlich.com/store/ios-animations-by-tutorials)`. I just introduce how to write animation for this project.      

Try your code now~：   

```swift
tr_presentViewController(nav, method: .Custom(FadeTransitionAnimation()), completion: nil)
```    

> You can use `Fade` to show guide viewController for you app. ^_^

## Other Tips   

### Gesture   

I have write **Swipe Back**. For more gestures , you have to write your code on your file.    

> I have some troubles for `PhotoTransitionAnimation` that is following Apple's Photos. If you are intresting this, see `PhotoTransitionAnimation.swift`.
