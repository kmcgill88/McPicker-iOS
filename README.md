# McPicker

[![Version](https://img.shields.io/cocoapods/v/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)
[![License](https://img.shields.io/cocoapods/l/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)
[![Platform](https://img.shields.io/cocoapods/p/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)

## About
A simple picker view with animations that is rotation aware. The more string arrays you pass the more picker components you'll get. You can set custom label or use the default.

## Usage
To run the example project, clone the repo, and run `pod install` from the Example directory first.

![](https://media.giphy.com/media/3o7btPtqG1YMn2fP5S/giphy.gif)

#### Short Syntax
```swift
McPicker.show(data: [["Kevin", "Lauren", "Kibby", "Stella"]], doneHandler: { selections in
    if let name = selections[0] {
        self.label.text = name
    }
})
```
#### Customization
```swift
let customLabel = UILabel()
customLabel.textAlignment = .center
customLabel.textColor = UIColor.red
customLabel.font = UIFont(name:"American Typewriter", size: 30)!

let data:[[String]] = [
    ["Sir", "Mr", "Mrs", "Miss"],
    ["Kevin", "Lauren", "Kibby", "Stella"]
]

let picker = McPicker(data:data)
picker.label = customLabel // Set your custom label
picker.toolBarButtonsColor = UIColor.red
picker.show(doneHandler: { selections in

    if let prefix = selections[0], let name = selections[1] {
        self.label.text = "\(prefix) \(name)"
    }
})
```

## TODO
- [ ] Add iPad Support

## Requirements
- Swift 3+
- Xcode 8

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
