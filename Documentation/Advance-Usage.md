## Custom Animation  

Now, there is just **Custom Animation**, other usages are coming after next version.

like **Basic-Usage**, just replace `method` paramters to `Custom(TRViewControllerAnimatedTransitioning)`, provide your animation object.  

> Note:   
> Thanks to Swift's Enum. I can write more concise code.   
> You also can use exist transition animation, just a joke~, here just be used to show an example.     

Example：    

```swift
navigationController?.tr_pushViewController(vc, method: .Custom(OMINTransitionAnimation(key: view)), completion: {
                print("Push finished")
            })
```     

> About write your animation, you can read [Animation-Guide](Animation-Guide), I happy to you will share your animation for this project.

## Status Bar Style     

> @Available >~ 1.1.0    

If you want to update status bar style, you should add key `View controller-based status bar appearance` in **info.plist**, and set value is `false`.   

Then like **Basic Usage**, just add param `statusBarStyle`:    

```swift
// Push & Pop
tr_pushViewController(viewController: UIViewController, method: TRPushMethod, statusBarStyle: UIStatusBarStyle = .Default)    
tr_pushViewController(viewController: UIViewController, method: TRPushMethod, statusBarStyle: UIStatusBarStyle = .Default, completion: (() -> Void)? = nil)

// Present & Dismiss
tr_presentViewController(viewControllerToPresent: UIViewController, method: TRPresentMethod, statusBarStyle: UIStatusBarStyle = .Default)
tr_presentViewController(viewControllerToPresent: UIViewController, method: TRPresentMethod, statusBarStyle: UIStatusBarStyle = .Default, completion: (() -> Void)? = nil)
```   