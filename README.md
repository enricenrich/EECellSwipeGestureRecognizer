# EECellSwipeGestureRecognizer

[![CocoaPods](https://img.shields.io/cocoapods/v/EECellSwipeGestureRecognizer.svg?maxAge=2592000)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Travis](https://img.shields.io/travis/enricenrich/EECellSwipeGestureRecognizer.svg?maxAge=2592000)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/AFNetworking.svg?maxAge=2592000)]()

A clean and easy way to implement swipe actions to UITableViewCell. You'll simply have to add a gesture recognizer to the cells that you want. That's all; you don't have to subclass anything.

This library is writen in Swift based on [DRCellSlideGestureRecognizer](https://github.com/DavdRoman/DRCellSlideGestureRecognizer) by [David Román](https://github.com/DavdRoman/).

## Features

* UITableView/UITableViewCell class agnostic.
* Setup multiple actions for multiple cell fractions.
* Fully customizable.
* Block-driven.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks (10.9).**

### CocoaPods

CocoaPods is a dependency manager for Objective-C and Swift projects. It has thousands of libraries and can help you scale your projects elegantly. You can install it with the following command:

`gem install cocoapods`

#### Podfile

To integrate EECellSwipeGestureRecognizer into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

platform :ios, '8.0'

target 'TargetName' do
pod 'EECellSwipeGestureRecognizer', '~> 1.0'
end
```

Then, run the following command:

`pod install`

### Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```
brew update
brew install carthage
```

To integrate EECellSwipeGestureRecognizer into your Xcode project using Carthage, specify it in your Cartfile:

`github "enricenrich/EECellSwipeGestureRecognizer" ~> 1.0`

Run `carthage` to build the framework and drag the built `EECellSwipeGestureRecognizer.framework` into your Xcode project.

### Manual

Drag and copy all files in the `Source` folder into your project.

## At a glance

### Setting up actions

First instatiate `EECellSwipeGestureRecognizer` to later add the actions:

```
let gestureRecognizer: EECellGestureRecognizer = EECellGestureRecognizer()
```

Then, simply instantiate `EECellSwipeAction` like this:

```
let action: EECellSwipeAction = EECellSwipeAction(fraction: 0.25)
action.behavior = .Push
action.icon = UIImage(named: "yourImage")
```

*Note: `fraction` determines the part of the cell to where the action will become active and ready to be triggered. It can go from 0 to 1 (swipe to the right), and from 0 to -1 (swipe to the left).*

And finally, add the action to the gesture recognizer, and the gesture recognizer to the cell:

```
gestureRecognizer.addActions([action])
cell.addGestureRecognizer(gestureRecognizer)
```

*Note: The given instructions should be performed inside tableView:cellForRowAtIndexPath: method or in the subclass if you created it.*

### Customizing actions

There are multiple `EECellSwipeAction` properties available for you to customize the appearence and interactivity of the cell:

* `behavior`: how the action will behave once triggered by the user. Possible values:
* `EECellSwipeActionBehavior.Pull`: the cell returns to its original position.
* `EECellSlideActionBehavior.Push`: the cell is pushed to the edge of the table.
* `icon`: the image to be displayed for the action.
* `iconMargin`: the margin for the icon.
* `activeColor`: the color of icon when the action is active.
* `inactiveColor`: the color of icon when the action is inactive.
* `activeBackgroundColor`: the background color when the action is active.
* `inactiveBackgroundColor`: the background color when the action is inactive.
* `willTrigger`: block that's triggered when the cell is about to behave accordingly to its behavior property.
* `didTrigger`: block that's triggered when the cell has already behaved accordingly to its behavior property. Here you should perform the main task for the cell action.
* `didChangeState`: block that's triggered then the action reaches its active/unactive state.

## License

EECellSwipeGestureRecognizer is available under the MIT license.

## Contact

You can find me on Twitter ([@enricenrich](https://twitter.com/enricenrich)) or on my [website](http://enric.co).
