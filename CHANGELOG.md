# Change Log

### Transition List

#### Push & Pop    
* OmniFocus     
* IBanTang    
* Fade    
* Page     
* Blixt
* Default

#### Present & Dismiss    
* Twitter     
* Fade    
* PopTip   
* TaaskyFlip    
* Elevate  
* Scanbot

#### TabBar
* Fade
* Slide

## [3.0.4](https://github.com/DianQK/TransitionTreasury/releases/tag/3.0.4)
#### Fixed
* Fix name `ONMI` to `OMNI`
* Fix Demo BuildFailed

## [3.0.3](https://github.com/DianQK/TransitionTreasury/releases/tag/3.0.3)
#### Fixed
* Support Swift 2.2 & Xcode 7.3

#### Other
* Add TransitionAnimation.podspec
* Cancel support of Carthage

## [3.0.2](https://github.com/DianQK/TransitionTreasury/releases/tag/3.0.2)
#### Fixed
* Fix `Slide` aniamtion crash

## [3.0.1](https://github.com/DianQK/TransitionTreasury/releases/tag/3.0.1)
#### Fixed
* Remove unused code from `TRStatusBarStyle.swift`

## [3.0.0](https://github.com/DianQK/TransitionTreasury/releases/tag/3.0.0)

#### Added
* Update podspec, you can only use TransitionFramework without Animation.

#### Fixed
* Fix can't use Push and Present at the same time. Update tr_transition into tr_presentTransition & tr_pushTranstion.

## [2.2.1](https://github.com/DianQK/TransitionTreasury/releases/tag/2.2.1)

#### Fixed
* Add type restriction on ViewControllerTransitionable and NavgationTransitionable methods([Pull 6](https://github.com/DianQK/TransitionTreasury/pull/6))

## [2.2.0](https://github.com/DianQK/TransitionTreasury/releases/tag/2.2.0)

#### Added
* Add **Default** transition animation for Push.

#### Fixed
* Improve **Page** animation performance.

## [2.1.0](https://github.com/DianQK/TransitionTreasury/releases/tag/2.1.0)

#### Added
* Support Gesture for TabBar Transition.
* Add **Slide** for TabBar Transition.

## [2.0.1](https://github.com/DianQK/TransitionTreasury/releases/tag/2.0.1)

#### Fixed
* Fix no interactive animation, after click present for **Scanbot**.

## [2.0.0](https://github.com/DianQK/TransitionTreasury/releases/tag/2.0.0)

#### Added
* Support Gesture for Present & Push.
* Add **Scanbot** Present transition animation(Scanbot support interactive animation).
* Support TabBar Transition Animation.

#### Fixed
* Fix **Fade** and **Page** not use `completion` block.
* Fix **Twitter** shake bug.
  * For more, see [Autolayout: Add constraint to superview and not Top Layout Guide?](http://stackoverflow.com/questions/28766210/autolayout-add-constraint-to-superview-and-not-top-layout-guide).

#### Other
* Update protocol to `TransitionInteractiveable`, `ViewControllerTransitionable`, `ModalTransitionDelegate`, `NavgationTransitionable`.
* Update enum to `TRPushTransitionMethod`, `TRPresentTransitionMethod`, `TRTabBarTransitionMethod`.

## [1.1.3](https://github.com/DianQK/TransitionTreasury/releases/tag/1.1.3)

#### Fixed
* Fix Present delay bug(****Apple)
  * Updated by leizh007 in Issues [#3](https://github.com/DianQK/TransitionTreasury/issues/3)
  * For more, see [presentViewController:animated:YES view will not appear until user taps again](http://stackoverflow.com/questions/21075540/presentviewcontrolleranimatedyes-view-will-not-appear-until-user-taps-again) or [UITableView and presentViewController takes 2 clicks to display](http://stackoverflow.com/questions/20320591/uitableview-and-presentviewcontroller-takes-2-clicks-to-display)

## [1.1.2](https://github.com/DianQK/TransitionTreasury/releases/tag/1.1.2)

#### Fixed
* Fix cancel pop & dismiss status bar style change
* Fix not support custom gesture for Pop  

## [1.1.1](https://github.com/DianQK/TransitionTreasury/releases/tag/1.1.1)   

#### Fixed   
* Fix no `Hide` status bar style.   

#### Other
* Separate status bar style module.

## [1.1.0](https://github.com/DianQK/TransitionTreasury/releases/tag/1.1.0)   

#### Add    

* Add New Feature: Update Status Bar Style

## [1.0.3](https://github.com/DianQK/TransitionTreasury/releases/tag/1.0.3)

#### Fixed   

* Fix some transition convert point.(Fix Transition keyView on Cell)   

---

## [1.0.2](https://github.com/DianQK/TransitionTreasury/releases/tag/1.0.2)

#### Fixed   
* Fix can't get `keyView` for some animation.
  * Updated by dingge1991 in Issues [#1](https://github.com/DianQK/TransitionTreasury/issues/1)
* Remove `keyView` from `TRViewControllerTransitionDelegate` extension

---

## [1.0.1](https://github.com/DianQK/TransitionTreasury/releases/tag/1.0.1)

#### Added   
* Add **Blixt** transition animation.       

#### Fixed   
* Fix Page cancelPop transform    
* Fix target build version

---

## [1.0.0](https://github.com/DianQK/TransitionTreasury/releases/tag/1.0.0)

#### Added   
* Add **Elevate** & **TaaskyFlip** transition animation.       

#### Fixed   
* Fix Twitter & Page `transform` backup.  
