![TransitionTreasury](https://raw.githubusercontent.com/DianQK/TransitionTreasury/master/Assets/transitiontreasury.png)

[![Build Status](https://travis-ci.org/DianQK/TransitionTreasury.svg)](https://travis-ci.org/DianQK/TransitionTreasury)
[![Twitter](https://img.shields.io/badge/twitter-@Songxut-blue.svg?style=flat)](http://twitter.com/Songxut)    

TransitionTreasury is a viewController transition framework in Swift.    

## Features    

* [x] Push & Present
* [x] Easy create transition & extension
* [x] Support completion callback
* [x] Support modal viewController data callback
* [x] Support Custom Transition
* [ ] [Complete Documentation]()

## Requirements   

* iOS 8.0+
* Xcode 7.1+

## Communication

* If you **need help or found a bug**, open an issue.
* If you **have a new transition animation** or *want to contribute*, submit a pull request. :]

## Installation

### CocoaPods

### Carthage

## Usage    

### Make a Push    

Your viewController must conform `TRTransition`. Code like this:     

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

### Make a Present

Your MainViewController must conform `ModalViewControllerDelegate`, and your ModalViewController must conform `MainViewControllerDelegate`. Code like this:     

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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func pop(sender: AnyObject) {
        modalDelegate?.modalViewControllerDismiss(callbackData: ["data":"back"])
    }
````

> Note:      
> If you don't need callbackData, maybe you haven't implemented `func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>?)`.     
> You shouldn't use `tr_dismissViewController()` in your **ModalViewController**. Please use `delegate`. I have implented this, just use `modalDelegate?.modalViewControllerDismiss(callbackData: ["data":"back"])`. For more, you can read [Dismissing a Presented View Controller](http://stackoverflow.com/questions/14636891/dismissing-a-presented-view-controller).

## Advanced Usage

### Custom Animation

## License

TransitionTreasury is released under the MIT license. See LICENSE for details.