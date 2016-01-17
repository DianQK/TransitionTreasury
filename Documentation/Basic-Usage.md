### Make a Push   

If we need to push `FirstViewController` to `SecondViewController`, `SecondViewController` should conform `NavgationTransitionable`, and add code `var tr_transition: TRNavgationTransitionDelegate?`, I need use this property to retain animation object. Of course, you can use this do more, but it is dangerous.   

When you need to push, just call `public func tr_pushViewController(viewController: UIViewController, method: TRPushTransitionMethod, completion: (() -> Void)?)`, like Apple method. About `method` parameter, see [transitiontreasury.com](http://transitiontreasury.com).

Example：   

```swift
/// FirstViewController.swift
class FirstViewController: UIViewController {

    func push() {
        let vc = SecondViewController()
        navigationController?.tr_pushViewController(vc, method: .Fade, completion: {
                print("Push finish")
            })
    }
}

/// SecondViewController.swift
class SecondViewController: UIViewController, TRTransition {
    
    var tr_transition: TRNavgationTransitionDelegate?

    func pop() {
        tr_popViewController()
    }
}
```    

When you need to pop, just call `public func tr_popViewController(completion: (() -> Void)? = nil) -> UIViewController?`.

### Make a Present   

If we present `MainViewController` to `ModalViewController`:     

* `MainViewController` should conform `ModalTransitionDelegate`, and add `var tr_transition: TRViewControllerTransitionDelegate?` 
* Add `weak var modalDelegate: ModalViewControllerDelegate?` for `ModalViewController`.

Example：       

```Swift
/// MainViewController.swift
class MainViewController: UIViewController, ModalTransitionDelegate {

    var tr_transition: TRViewControllerTransitionDelegate?

    func present() {
        let vc = ModalViewController()
        vc.modalDelegate = self // Don't forget to set modalDelegate
        tr_presentViewController(vc, method: .Fade, completion: {
                print("Present finished.")
            })
    }
}

/// ModalViewController.swift
class ModalViewController: UIViewController {
    
    weak var modalDelegate: ModalViewControllerDelegate?

    func dismiss() {
        modalDelegate?.modalViewControllerDismiss(callbackData: nil)
    }
}
```

if you need `callbackData` , your `MianViewController` should implement :

```swift
func modalViewControllerDismiss(interactive interactive: Bool, callbackData data:AnyObject?)

// or

func modalViewControllerDismiss(callbackData data:AnyObject?)
```

`interactive` just for interactive dismiss, for more see Advanced Usage.

> Note:      
> If you don't need callbackData, maybe you haven't implemented `func modalViewControllerDismiss(callbackData data:AnyObject?)`. 
> If you don't want to use `ModalTransitionDelegate`, you can use `ViewControllerTransitionable` which only for Animation.
> Warning:    
> You shouldn't use `tr_dismissViewController()` in your **ModalViewController**. Please use `delegate`. I have implented this, just use `modalDelegate?.modalViewControllerDismiss(callbackData: ["data":"back"])`. For more, you can read [Dismissing a Presented View Controller](http://stackoverflow.com/questions/14636891/dismissing-a-presented-view-controller).