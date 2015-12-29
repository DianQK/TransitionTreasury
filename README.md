![TransitionTreasury](https://raw.githubusercontent.com/DianQK/TransitionTreasury/master/transitiontreasury.png)

[![Build Status](https://travis-ci.org/DianQK/TransitionTreasury.svg)](https://travis-ci.org/DianQK/TransitionTreasury)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/TransitionTreasury.svg)](https://img.shields.io/cocoapods/v/TransitionTreasury.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/TransitionTreasury.svg?style=flat)](http://cocoadocs.org/docsets/TransitionTreasury)
[![Twitter](https://img.shields.io/badge/twitter-@Songxut-blue.svg?style=flat)](http://twitter.com/Songxut)   

TransitionTreasury is a viewController transition framework in Swift.    

## Features    

* [x] Push & Present
* [x] Easy create transition & extension
* [x] Support completion callback
* [x] Support modal viewController data callback
* [x] Support Custom Transition
* [x] [Complete Documentation](https://github.com/DianQK/TransitionTreasury/wiki)

## Requirements   

* iOS 8.0+
* Xcode 7.1+

## Communication

* If you **need help or found a bug**, open an issue.
* If you **have a new transition animation** or *want to contribute*, submit a pull request. :]

## Installation

### CocoaPods    

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build TransitionTreasury.

To integrate TransitionTreasury into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'TransitionTreasury', '~> 0.9.0'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

## Usage    

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

> Note:      
> If you don't need callbackData, maybe you haven't implemented `func modalViewControllerDismiss(callbackData data:Dictionary<String,AnyObject>?)`.     
> You shouldn't use `tr_dismissViewController()` in your **ModalViewController**. Please use `delegate`. I have implented this, just use `modalDelegate?.modalViewControllerDismiss(callbackData: ["data":"back"])`. For more, you can read [Dismissing a Presented View Controller](http://stackoverflow.com/questions/14636891/dismissing-a-presented-view-controller).

## Advanced Usage

### Custom Animation   

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

## License

TransitionTreasury is released under the MIT license. See LICENSE for details.