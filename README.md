# McPicker

[![Version](https://img.shields.io/cocoapods/v/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)
[![License](https://img.shields.io/cocoapods/l/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)
[![Platform](https://img.shields.io/cocoapods/p/McPicker.svg?style=flat)](http://cocoapods.org/pods/McPicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
```swift
McPicker.show(data: [["Kevin", "Lauren", "Kibby", "Stella"]], doneHandler: { selections in
    if let name = selections[0] {
        self.label.text = name
    }
})
```

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
