/*
 Copyright (c) 2017-2020 Kevin McGill <kevin@mcgilldevtech.com>

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

internal class McPickerPopoverViewController: UIViewController {

    weak var mcPicker: McPicker?
    internal var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaInsets
        }
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    internal convenience init(mcPicker: McPicker) {
        self.init(nibName: nil, bundle: nil)
        self.mcPicker = mcPicker
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mcPicker!.sizeViews()
        mcPicker!.addAllSubviews()
        self.view.addSubview(mcPicker!)
        self.preferredContentSize = mcPicker!.popOverContentSize
    }

    override func viewSafeAreaInsetsDidChange() {
        let toolbarHeight = mcPicker?.toolbar.frame.height ?? 0
        let safeAreaToolbarHeight = toolbarHeight + safeArea.top
        mcPicker?.toolbar.frame = CGRect(x: 0, y: 0, width: mcPicker?.toolbar.frame.width ?? 0, height: safeAreaToolbarHeight)
        self.preferredContentSize = CGSize(width: self.preferredContentSize.width, height: self.preferredContentSize.height - safeArea.top)
    }
}
