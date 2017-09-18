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
import McPicker

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    let data: [[String]] = [
        ["Kevin", "Lauren", "Kibby", "Stella"]
    ]

    @IBAction func showPressed(_ sender: Any) {
/*
        // Verbose Setup
        //
        let data:[[String]] = [
            ["Mr", "Mrs", "Miss"],
            ["Kevin", "Lauren", "Kibby", "Stella"]
        ]
        let picker = McPicker(data:data)
        picker.show(cancelHandler: {
            
            // Do something interesting
            //
            print("Picker canceled.")
            
        }, doneHandler: { selections in
            
            // Selection(s) Made
            //
            if let prefix = selections[0], let name = selections[1] {
                self.label.text = "\(prefix) \(name)"
            }
        })
*/

        // Short hand
        //
        McPicker.show(data: [["Kevin", "Lauren", "Kibby", "Stella"]]) {  (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self.label.text = name
            }
        }
    }

    @IBAction func styledPicker(_ sender: Any) {

        let customLabel = UILabel()
        customLabel.textAlignment = .center
        customLabel.textColor = .white
        customLabel.font = UIFont(name:"American Typewriter", size: 30)!

        let data: [[String]] = [
            ["Sir", "Mr", "Mrs", "Miss"],
            ["Kevin", "Lauren", "Kibby", "Stella"]
        ]

        let mcPicker = McPicker(data: data)
        mcPicker.label = customLabel // Set your custom label
        mcPicker.toolbarItemsFont = UIFont(name:"American Typewriter", size: 17)!

        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Fire!!!") // Set custom Text
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel) // or system items
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])

        mcPicker.toolbarButtonsColor = .white
        mcPicker.toolbarBarTintColor = .darkGray
        mcPicker.pickerBackgroundColor = .gray
        mcPicker.pickerSelectRowsForComponents = [
            0: [3: true],
            1: [2: true]
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
    }

    @IBAction func popOverPicker(_ sender: UIButton) {

        McPicker.showAsPopover(data:data, fromViewController: self, sourceView: sender, cancelHandler: { () -> Void in

            print("Canceled Popover")

        }, doneHandler: { (selections: [Int : String]) -> Void in

            print("Done with Popover")
            if let name = selections[0] {
                self.label.text = name
            }
        })
    }

    @IBAction func pressedBarButtonItem(_ sender: UIBarButtonItem) {

        McPicker.showAsPopover(data: data, fromViewController: self, barButtonItem: sender) { (selections: [Int : String]) -> Void in
            print("Done with Popover")
            if let name = selections[0] {
                self.label.text = name
            }
        }
    }
}
