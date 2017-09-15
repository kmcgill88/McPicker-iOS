/*
 Copyright (c) 2017 Kevin McGill <kevin@mcgilldevtech.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit
import XCTest
@testable import McPicker

// swiftlint:disable nesting
// swiftlint:disable force_cast
class McPickerTests: XCTestCase {

    let data: [[String]] = [
        ["Bob", "Bill"]
    ]

    func testInitDefaultOptionsAreSet() {
        // Given
        //
        class TestMcPicker: McPicker {
            var sizeViewsCalled = false
            override func sizeViews() {
                sizeViewsCalled = true
            }
        }

        // When
        //
        let mcPicker = TestMcPicker(data:data)

        // Then
        //
        XCTAssertEqual(data.count, mcPicker.pickerData.count)
        XCTAssertEqual(data[0][0], mcPicker.pickerData[0][0])
        XCTAssertEqual(data[0][1], mcPicker.pickerData[0][1])

        XCTAssertEqual(1, mcPicker.gestureRecognizers?.count)
        XCTAssertEqual(5, mcPicker.toolbar.items?.count)

        let fixedSpace = mcPicker.toolbar.items?[0] as! McPickerBarButtonItem
        XCTAssertNil(fixedSpace.target)
        XCTAssertNil(fixedSpace.action)

        let cancelBarButton = mcPicker.toolbar.items?[1] as! McPickerBarButtonItem
        XCTAssertEqual(cancelBarButton.target as! TestMcPicker, mcPicker)
        XCTAssertEqual(cancelBarButton.action!, #selector(TestMcPicker.cancel))

        let flexibleSpace = mcPicker.toolbar.items?[2] as! McPickerBarButtonItem
        XCTAssertNil(flexibleSpace.target)
        XCTAssertNil(flexibleSpace.action)

        let doneBarButton = mcPicker.toolbar.items?[3] as! McPickerBarButtonItem
        XCTAssertEqual(doneBarButton.target as! TestMcPicker, mcPicker)
        XCTAssertEqual(doneBarButton.action!, #selector(TestMcPicker.done))

        XCTAssertEqual(mcPicker.backgroundColor, UIColor.black.withAlphaComponent(0.75))
        XCTAssertEqual(mcPicker.backgroundView.backgroundColor, UIColor.white)

        XCTAssertEqual(mcPicker, mcPicker.picker.delegate as! McPicker)
        XCTAssertEqual(mcPicker, mcPicker.picker.dataSource as! McPicker)

        XCTAssertEqual(data.count, mcPicker.picker.numberOfComponents)
        XCTAssertEqual(data.count, mcPicker.numberOfComponents)

        XCTAssertEqual(true, mcPicker.sizeViewsCalled)

        XCTAssertEqual(data.first?.first, mcPicker.pickerSelection[0])

        XCTAssertNil(mcPicker.mcPickerPopoverViewController)
    }

    func testSetToolbarButtonsColorSetsCancelAndDone() {
        // Given
        //
        let mcPicker = McPicker(data: data)
        let cancelBarButton = mcPicker.toolbar.items?[1] as! McPickerBarButtonItem
        let doneBarButton = mcPicker.toolbar.items?[3] as! McPickerBarButtonItem

        // When
        //
        mcPicker.toolbarButtonsColor = UIColor.purple

        // Then
        //
        XCTAssertEqual(UIColor.purple, cancelBarButton.tintColor)
        XCTAssertEqual(UIColor.purple, doneBarButton.tintColor)
    }

    func testSetToolbarDoneButtonsColorSetsDone() {
        // Given
        //
        let mcPicker = McPicker(data: data)
        let cancelBarButton = mcPicker.toolbar.items?[1] as! McPickerBarButtonItem
        let doneBarButton = mcPicker.toolbar.items?[3] as! McPickerBarButtonItem

        // When
        //
        mcPicker.toolbarDoneButtonColor = UIColor.purple

        // Then
        //
        XCTAssertNil(cancelBarButton.tintColor)
        XCTAssertEqual(UIColor.purple, doneBarButton.tintColor)
    }

    func testSetToolbarCancelButtonsColorSetsCancel() {
        // Given
        //
        let mcPicker = McPicker(data: data)
        let cancelBarButton = mcPicker.toolbar.items?[1] as! McPickerBarButtonItem
        let doneBarButton = mcPicker.toolbar.items?[3] as! McPickerBarButtonItem

        // When
        //
        mcPicker.toolbarCancelButtonColor = UIColor.purple

        // Then
        //
        XCTAssertEqual(UIColor.purple, cancelBarButton.tintColor)
        XCTAssertNil(doneBarButton.tintColor)
    }

    func testSetToolbarCancelButtonColor() {
        // Given
        //
        let mcPicker = McPicker(data: data)

        // When
        //
        XCTAssertNil(mcPicker.toolbar.barTintColor)
        mcPicker.toolbarBarTintColor = UIColor.purple

        // Then
        //
        XCTAssertEqual(UIColor.purple, mcPicker.toolbar.barTintColor)
    }

    func testSetToolbarItemsFont() {
        // Given
        //
        let mcPicker = McPicker(data: data)
        let cancelBarButton = mcPicker.toolbar.items?[1] as! McPickerBarButtonItem
        let doneBarButton = mcPicker.toolbar.items?[3] as! McPickerBarButtonItem
        let expectedFont = UIFont(name:"American Typewriter", size: 17)!

        // When
        //
        mcPicker.toolbarItemsFont = expectedFont

        // Then
        //
        XCTAssertEqual(expectedFont, cancelBarButton.titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont)
        XCTAssertEqual(expectedFont, doneBarButton.titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont)
    }

    func testSetPickerBackgroundColor() {
        // Given
        //
        let mcPicker = McPicker(data: data)

        // When
        //
        mcPicker.pickerBackgroundColor = UIColor.purple

        // Then
        //
        XCTAssertEqual(UIColor.purple, mcPicker.picker.backgroundColor)
    }

    func testDimissViews_callsAnimateViewsWhenShow() {
        // Given
        //
        class TestMcPicker: McPicker {
            var direction: McPicker.AnimationDirection?
            var calledShow = false
            override func animateViews(direction: McPicker.AnimationDirection) {
                self.direction = direction
            }

            override func show(cancelHandler: @escaping () -> Void, doneHandler: @escaping ([Int : String]) -> Void) {
                animateViews(direction: .in)
                calledShow = true
            }
        }
        let mcPicker = TestMcPicker(data: data)

        // When
        //
        mcPicker.show(cancelHandler: {}) { (_: [Int : String]) in }
        XCTAssertFalse(mcPicker.isPopoverMode)
        XCTAssertEqual(McPicker.AnimationDirection.in, mcPicker.direction)
        mcPicker.dismissViews()

        // Then
        //
        XCTAssertTrue(mcPicker.calledShow)
        XCTAssertEqual(McPicker.AnimationDirection.out, mcPicker.direction)
    }

    func testDimissViews_doesNotCallAnimateViewsWhenShowAsPopover() {
        // Given
        //
        class TestVC: UIViewController {
            var presented = false
            override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
                presented = true
            }
        }
        class TestMcPicker: McPicker {
            var calledAnimateViews = false
            override func animateViews(direction: McPicker.AnimationDirection) {
                calledAnimateViews = true
            }
        }
        let testVC = TestVC()
        let mcPicker = TestMcPicker(data: data)

        // When
        //
        mcPicker.showAsPopover(fromViewController: testVC, sourceView: UIView()) { (_: [Int : String]) -> Void in }
        XCTAssertTrue(mcPicker.mcPickerPopoverViewController != nil)
        XCTAssertTrue(mcPicker.isPopoverMode)

        mcPicker.dismissViews()

        // Then
        //
        XCTAssertNil(mcPicker.mcPickerPopoverViewController)
        XCTAssertFalse(mcPicker.calledAnimateViews)
    }

    func testPickerSelectRowsForComponents() {
        // Given
        //
        let data: [[String]] = [
            ["Sir", "Mr", "Mrs", "Miss"],
            ["Kevin", "Lauren", "Kibby", "Stella"]
        ]
        let mcPicker = McPicker(data: data)

        // When
        //
        mcPicker.pickerSelectRowsForComponents = [
            0: [3: true],
            1: [2: true]
        ]

        // Then
        //
        XCTAssertEqual(3, mcPicker.picker.selectedRow(inComponent: 0))
        XCTAssertEqual(2, mcPicker.picker.selectedRow(inComponent: 1))
        XCTAssertEqual("Miss", mcPicker.pickerSelection[0]!)
        XCTAssertEqual("Kibby", mcPicker.pickerSelection[1]!)
    }
}
