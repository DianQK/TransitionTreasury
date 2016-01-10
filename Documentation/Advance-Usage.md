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