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
        XCTAssertEqual(mcPicker.fixedSpace.style, mcPicker.toolbar.items?[0].style)
        XCTAssertEqual(mcPicker.cancelBarButton, mcPicker.toolbar.items?[1])
        XCTAssertEqual(mcPicker.flexibleSpace.style, mcPicker.toolbar.items?[2].style)
        XCTAssertEqual(mcPicker.doneBarButton, mcPicker.toolbar.items?[3])
        XCTAssertEqual(mcPicker.fixedSpace.style, mcPicker.toolbar.items?[0].style)

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

        // When
        //
        mcPicker.toolbarButtonsColor = UIColor.purple

        // Then
        //
        XCTAssertEqual(UIColor.purple, mcPicker.cancelBarButton.tintColor)
        XCTAssertEqual(UIColor.purple, mcPicker.doneBarButton.tintColor)
    }

    func testSetToolbarDoneButtonsColorSetsDone() {
        // Given
        //
        let mcPicker = McPicker(data: data)

        // When
        //
        mcPicker.toolbarDoneButtonColor = UIColor.purple

        // Then
        //
        XCTAssertNil(mcPicker.cancelBarButton.tintColor)
        XCTAssertEqual(UIColor.purple, mcPicker.doneBarButton.tintColor)
    }

    func testSetToolbarCancelButtonsColorSetsCancel() {
        // Given
        //
        let mcPicker = McPicker(data: data)

        // When
        //
        mcPicker.toolbarCancelButtonColor = UIColor.purple

        // Then
        //
        XCTAssertEqual(UIColor.purple, mcPicker.cancelBarButton.tintColor)
        XCTAssertNil(mcPicker.doneBarButton.tintColor)
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
        let expectedFont = UIFont(name:"American Typewriter", size: 17)!

        // When
        //
        mcPicker.toolbarItemsFont = expectedFont

        // Then
        //
        XCTAssertEqual(expectedFont, mcPicker.cancelBarButton.titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont)
        XCTAssertEqual(expectedFont, mcPicker.doneBarButton.titleTextAttributes(for: .normal)?[NSFontAttributeName] as! UIFont)
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

    func testInitShowAsPopover() {
        class TestVC: UIViewController {
            var presentWasCalled = false
            override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
                presentWasCalled = true
            }
        }
    }
}
