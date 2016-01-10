### Make a Push   

if we need to push `FirstViewController` to `SecondViewController`, `SecondViewController` should conform `TRTransition`, and add code `var tr_transition: TRNavgationTransitionDelegate?`, I need use this property to retain animation object. Of course, you can use this do more, but it is dangerous.   

when you need to push, just call `public func tr_pushViewController(viewcontroller: UIViewController, method: TRPushMethod, completion: (() -> Void)?)`, like Apple method. About `method` parameter, see [transitiontreasury.com](http://transitiontreasury.com).

Example：   

```swift
class OMINViewController: UIViewController, TRTransition {
    
    var tr_transition: TRNavgationTransitionDelegate?

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let view = touches.first?.view {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OMINViewController")
            navigationController?.tr_pushViewController(vc, method: .OMIN(keyView: view), completion: {
                print("Push finish")
            })
        }
    }
}
```    

when you need to pop, just call `public func tr_popViewController(completion: (() -> Void)? = nil) -> UIViewController?`.

### Make a Present   

if we present `MainViewController` to `ModalViewController`:     

* `MainViewController` should conform `ModalViewControllerDelegate`, and add `var tr_transition: TRViewControllerTransitionDelegate?` 
* `ModalViewController` should conform `ModalViewControllerDelegate`, and add `weak var modalDelegate: ModalViewControllerDelegate?`  

if you confuse why use **delegate**, you can see [Dismissing a Presented View Controller](http://stackoverflow.com/questions/14636891/dismissing-a-presented-view-controller).

Example：       

```Swift
/// MainViewController.swift
var tr_transition: TRViewControllerTransitionDelegate?

@IBAction func tr_presentVC(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalViewController") as! ModalViewController
        vc.modalDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        tr_presentViewController(nav, method: .Twitter, completion: nil)
    }

/// ModalViewController.swift
weak var modalDelegate: ModalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func pop(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: ["data":"back"])
    }
````