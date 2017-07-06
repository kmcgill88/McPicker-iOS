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

class McPickerTest: XCTestCase {

    func testDefaultMcPickerOptionsAreSet() {
        // Given
        let data:[[String]] = [
            ["Bob", "Bill"]
        ]
        
        // When
        let mcPicker = McPicker(data:data)
        
        // Then
        XCTAssertEqual(data.count, mcPicker.pickerData.count)
        XCTAssertEqual(data[0][0], mcPicker.pickerData[0][0])
        XCTAssertEqual(data[0][1], mcPicker.pickerData[0][1])

        XCTAssertEqual(1, mcPicker.gestureRecognizers?.count)
        XCTAssertEqual(5, mcPicker.toolbar.items?.count)
    }

    
}
