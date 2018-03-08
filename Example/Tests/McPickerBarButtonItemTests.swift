/*
 Copyright (c) 2017-2018 Kevin McGill <kevin@mcgilldevtech.com>

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
class McPickerBarButtonItemTests: XCTestCase {

    let mcPicker = McPicker(data: [["Bob", "Bill"]])

    func testInitDone_noTitleDefaultStyle() {
        let item = McPickerBarButtonItem.done(mcPicker: mcPicker)

        XCTAssertNil(item.title)
        XCTAssertTrue(item.style == .done)
        XCTAssertTrue(item.target as! McPicker == mcPicker)
        XCTAssertTrue(item.action == #selector(McPicker.done))
    }

    func testInitDone_noTitleCustomStyle() {
        let item = McPickerBarButtonItem.done(mcPicker: mcPicker, barButtonSystemItem: UIBarButtonSystemItem.save)

        XCTAssertNil(item.title)
        XCTAssertTrue(item.style == .plain)
        XCTAssertTrue(item.target as! McPicker == mcPicker)
        XCTAssertTrue(item.action == #selector(McPicker.done))
    }

    func testInitDone_withTitle() {
        let title = "My Custom Title"
        let item = McPickerBarButtonItem.done(mcPicker: mcPicker, title: title)

        XCTAssertTrue(item.title == title)
        XCTAssertTrue(item.style == .plain)
        XCTAssertTrue(item.target as! McPicker == mcPicker)
        XCTAssertTrue(item.action == #selector(McPicker.done))
    }

    func testInitCancel_noTitle() {
        let item = McPickerBarButtonItem.cancel(mcPicker: mcPicker)

        XCTAssertNil(item.title)
        XCTAssertTrue(item.style == .plain)
        XCTAssertTrue(item.target as! McPicker == mcPicker)
        XCTAssertTrue(item.action == #selector(McPicker.cancel))
    }

    func testInitCancel_noTitleCustomStyle() {
        let item = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: UIBarButtonSystemItem.save)

        XCTAssertNil(item.title)
        XCTAssertTrue(item.style == .plain)
        XCTAssertTrue(item.target as! McPicker == mcPicker)
        XCTAssertTrue(item.action == #selector(McPicker.cancel))
    }

    func testInitCancel_withTitle() {
        let title = "My Custom Title"
        let item = McPickerBarButtonItem.cancel(mcPicker: mcPicker, title: title)

        XCTAssertTrue(item.title == title)
        XCTAssertTrue(item.style == .plain)
        XCTAssertTrue(item.target as! McPicker == mcPicker)
        XCTAssertTrue(item.action == #selector(McPicker.cancel))
    }

    func testInitFlexibleSpace() {
        let item = McPickerBarButtonItem.flexibleSpace()

        XCTAssertTrue(item.style == .plain)
        XCTAssertNil(item.target)
        XCTAssertNil(item.action)
    }

    func testInitFixedSpace() {
        let expectedWidth: CGFloat = 2.0
        let item = McPickerBarButtonItem.fixedSpace(width: expectedWidth)

        XCTAssertTrue(item.width == expectedWidth)
        XCTAssertTrue(item.style == .plain)
        XCTAssertNil(item.title)
        XCTAssertNil(item.target)
        XCTAssertNil(item.action)
    }
}
