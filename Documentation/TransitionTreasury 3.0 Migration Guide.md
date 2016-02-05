# TransitionTreasury 3.0 Migration Guide

## Breaking changes:

* `tr_transition` has been replaced with `tr_pushTranstion` and `tr_presentTransition`.
* Case `custom(TRViewControllerAnimatedTransitioning)` has been remove from this framework.
* Update present method to `tr_presentViewController(viewControllerToPresent: UIViewController, method: TransitionAnimationable, statusBarStyle: TRStatusBarStyle = .Default, completion: (() -> Void)? = nil)`. Now we use protocol `TransitionAnimationable`,so if you need call like this:  
```swift
tr_presentViewController(nav, method: TRPresentTransitionMethod.Twitter, completion: {
    print("Present finished.")
})
```

> Now create your Transition struct or enum will be easier. Just conform `TransitionAnimationable`.

## Help

If you have any additional questions around migration, feel free to open a documentation issue on Github to get more clarity added to this guide.
