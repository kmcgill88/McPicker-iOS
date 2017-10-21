# McPicker
[![Build Status](https://travis-ci.org/kmcgill88/McPicker-iOS.svg?branch=master)](https://travis-ci.org/kmcgill88/McPicker-iOS)
[![Version](https://img.shields.io/cocoapods/v/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)
[![License](https://img.shields.io/cocoapods/l/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)
[![Platform](https://img.shields.io/cocoapods/p/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)

## About
McPicker is a UIPickerView drop-in solution with animations that is rotation ready. The more string arrays you pass, the more picker components you'll get. You can set custom label or use the defaults. McPicker can be presented as a Popover on iPhone or iPad using `showAsPopover` or use the default slide up and down style `show`.

`showAsPopover` can be used to display from a `UIView` or `UIBarButtonItem`. `showAsPopover` will always be presented as a Popover, even when used on an iPhone.

## Usage
To run the example project, clone the repo, and run `pod install` from the Example directory first.

![](http://mcgilldevtech.com/img/github/mcpicker/mcpicker-0.3.0-ios.gif)

#### Short Syntax
- Normal - (Slide up from bottom)
```swift
McPicker.show(data: [["Kevin", "Lauren", "Kibby", "Stella"]]) {  (selections: [Int : String]) -> Void in
    if let name = selections[0] {
        self.label.text = name
    }
}
```
- As Popover
```swift
let data: [[String]] = [["Kevin", "Lauren", "Kibby", "Stella"]]
McPicker.showAsPopover(data: data, fromViewController: self, barButtonItem: sender) { (selections: [Int : String]) -> Void in
    if let name = selections[0] {
        self.label.text = name
    }
}
```

#### Customization
```swift
let data: [[String]] = [
  ["Sir", "Mr", "Mrs", "Miss"],
  ["Kevin", "Lauren", "Kibby", "Stella"]
]

let customLabel = UILabel()
customLabel.textAlignment = .center
customLabel.textColor = .white
customLabel.font = UIFont(name:"American Typewriter", size: 30)!

let mcPicker = McPicker(data: data)

let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Fire!!!")
let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])

mcPicker.label = customLabel // Set your custom label
mcPicker.toolbarItemsFont = UIFont(name:"American Typewriter", size: 17)!

mcPicker.toolbarButtonsColor = .white
mcPicker.toolbarBarTintColor = .darkGray
mcPicker.pickerBackgroundColor = .gray
mcPicker.pickerSelectRowsForComponents = [
    0: [3: true],
    1: [2: true] // [Component: [Row: isAnimated]
]

if let barButton = sender as? UIBarButtonItem {
    // Show as Popover
    //
    mcPicker.showAsPopover(fromViewController: self, barButtonItem: barButton) { (selections: [Int : String]) -> Void in
        if let prefix = selections[0], let name = selections[1] {
            self.label.text = "\(prefix) \(name)"
        }
    }
} else {
    // Show Normal
    //
    mcPicker.show { selections in
        if let prefix = selections[0], let name = selections[1] {
            self.label.text = "\(prefix) \(name)"
        }
    }
}
```

##### The `selections`
McPicker's `doneHandler` passes back `selections: [Int : String]` as an argument. This is as simple as `[<Component Index>: <String of Selection>]` from the `data` you've passed in.

## Requirements
- iOS 8+
- Swift 4.0
- Xcode 9

> __Note__: Starting in 0.5.1 McPicker uses the Swift 4 Compiler. [Ensure the correct compiler is set in your project.](https://github.com/kmcgill88/McPicker-iOS/issues/23). If you'd like to use Swift 3 use version <=0.5.0.

## Installation

McPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "McPicker"
```

## Author

Kevin McGill, kevin@mcgilldevtech.com

## License

McPicker is available under the MIT license. See the LICENSE file for more info.
