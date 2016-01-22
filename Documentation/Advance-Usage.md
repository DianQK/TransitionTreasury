### Custom Animation   

Now, there is just **Custom Animation**, other usages are coming after next version.

Like **Basic-Usage**, just replace `method` paramters to `Custom(TRViewControllerAnimatedTransitioning)`, provide your animation object.  

> Note:   
> Thanks to Swift's Enum. I can write more concise code.   
> You also can use exist transition animation, just a joke~, here just be used to show an example.     

Example：    

```swift
navigationController?.tr_pushViewController(vc, method: .Custom(OMINTransitionAnimation(key: view)), completion: {
                print("Push finished")
            })
```     

> About write your animation, you can read [Animation-Guide](https://github.com/DianQK/TransitionTreasury/wiki/Animation-Guide), I happy to you will share your animation for this project.   

### Status Bar Style     

If you want to update status bar style, you should add key `View controller-based status bar appearance` in **info.plist**, and set value is `false`.   

Then like **Basic Usage**, just add param `statusBarStyle`:       

```swift
// Push & Pop
tr_pushViewController(viewController: UIViewController, method: TRPushTransitionMethod, statusBarStyle: UIStatusBarStyle = .Default)    

// Present & Dismiss
tr_presentViewController(viewControllerToPresent: UIViewController, method: TRPresentTransitionMethod, statusBarStyle: UIStatusBarStyle = .Default)
```    

### Interactive Transition Animation

See TransitionTreasuryDemo Scheme:   

```swift
func interactiveTransition(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began :
            guard sender.translationInView(view).y > 0 else {
                break
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
            vc.modalDelegate = self
            tr_presentViewController(vc, method: .Scanbot(present: sender, dismiss: vc.dismissGestureRecognizer), completion: {
                print("Present finished")
            })
        default : break
        }
    }
```
> Warning:
> Make sure you just call `tr_presentViewController(_:_:_:)` once.

### TabBar Transition Animation

Just Add this code:

```swift
tabBarController.tr_transitionDelegate = TRTabBarTransitionDelegate(method: .Swipe)
```

> Note:
> If you need `delegate`, please use `tr_delegate`.

You can see TransitionTreasuryTabBarDemo Scheme.