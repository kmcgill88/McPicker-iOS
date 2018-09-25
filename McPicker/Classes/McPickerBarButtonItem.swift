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

open class McPickerBarButtonItem: UIBarButtonItem {

    /**
        A bar button to close McPicker with selections.
     
        - parameter mcPicker: Target instance
        - parameter title: Optionally set a custom title
        - parameter barButtonSystemItem: Optionally set UIBarButtonSystemItem or omit for default: .done. NOTE: This option is ignored when title is non-nil.
     
        - returns: McPickerBarButtonItem
     */
    public class func done(mcPicker: McPicker, title: String? = nil, barButtonSystemItem: UIBarButtonItem.SystemItem = .done) -> McPickerBarButtonItem {

        if let buttonTitle = title {
            return self.init(title: buttonTitle, style: .plain, target: mcPicker, action: #selector(McPicker.done))
        }

        return self.init(barButtonSystemItem: barButtonSystemItem, target: mcPicker, action: #selector(McPicker.done))
    }

    /**
         A bar button to close McPicker with out selections.
         
         - parameter mcPicker: Target instance
         - parameter title: Optionally set a custom title
         - parameter barButtonSystemItem: Optionally set UIBarButtonSystemItem or omit for default: .done. NOTE: This option is ignored when title is non-nil.
         
         - returns: McPickerBarButtonItem
     */
    public class func cancel(mcPicker: McPicker, title: String? = nil, barButtonSystemItem: UIBarButtonItem.SystemItem = .cancel) -> McPickerBarButtonItem {

        if let buttonTitle = title {
            return self.init(title: buttonTitle, style: .plain, target: mcPicker, action: #selector(McPicker.cancel))
        }

        return self.init(barButtonSystemItem: barButtonSystemItem, target: mcPicker, action: #selector(McPicker.cancel))
    }

    public class func flexibleSpace() -> McPickerBarButtonItem {
        return self.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }

    public class func fixedSpace(width: CGFloat) -> McPickerBarButtonItem {
        let fixedSpace =  self.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = width
        return fixedSpace
    }
}
