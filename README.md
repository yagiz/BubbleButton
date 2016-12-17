# BubbleButton
![N|Solid](http://146.185.160.107/wp-content/uploads/2016/12/bubbleButtonHeader.png)

BubbleButton is Swift 3 button wihch does producuse bubbles.

### Installation

#### CocoaPods
```sh
pod 'BubbleButton', '~> 0.1.0'
```
#### Manually
Just download or clone the repo and move BubbleButton.swift file to your project.

### Customize
You can customize these properties in Interface Builder or by code:
  - titleForProgress 
  - titleForCompletion
  - endAnimationDuration
  - fadeOutAnimationDelay
  - fadeOutAnimationDuration
  - bubbleColor
  - bubbleCount
  - bubbleSpeedMin
  - bubbleSpeedMax
  - bubbleRadiusMin
  - bubbleRadiusMax

### Example

You can start animating button after it's tapped. After your propgress is completed you can call "endAnimationWith" to reset button state.
```swift
@IBAction func buttonAction(_ sender: AnyObject)
    {
        bubbleButton.startBubbleAnimationWith(direction: .TopRight)
        print("startingAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            print("endingAnimation")
            self.bubbleButton.endAnimationWith {
                print("animationIsEnded")
            }
        }
    }
```

License
----
MIT

**Free Software, Hell Yeah!**