# EECellSwipeGestureRecognizer

A clean and easy way to implement swipe actions to UITableViewCell. You'll simply have to add a gesture recognizer to the cells that you want. That's all; you don't have to subclass anything.

This library is writen in Swift based on [https://github.com/DavdRoman/DRCellSlideGestureRecognizer](DRCellSlideGestureRecognizer) by [https://github.com/DavdRoman/](David Román).

# Features

* UITableView/UITableViewCell class agnostic.
* Setup multiple actions for multiple cell fractions.
* Fully customizable.
* Block-driven.

# Installation

## CocoaPods

pod 'EECellSwipeGestureRecognizer'

## Manual

Drag and copy all files in the `Source` folder into your project.

## At a glance

## Setting up actions

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

# Customizing actions

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

# License

EECellSwipeGestureRecognizer is available under the MIT license.
