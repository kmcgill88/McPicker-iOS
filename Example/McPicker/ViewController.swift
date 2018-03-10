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
import McPicker

class ViewController: UIViewController {

    @IBOutlet weak var textField: McTextField!
    @IBOutlet weak var label: UILabel!
    let data: [[String]] = [
        ["Kevin", "Lauren", "Kibby", "Stella"]
    ]

    override func viewDidLoad() {
        let mcInputView = McPicker(data: data)
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        textField.inputViewMcPicker = mcInputView
        textField.doneHandler = { [weak textField] (selections) in
            textField?.text = selections[0]!
        }
        textField.selectionChangedHandler = { [weak textField] (selections, componentThatChanged) in
            textField?.text = selections[componentThatChanged]!
        }
        textField.cancelHandler = { [weak textField] in
            textField?.text = "Cancelled."
        }
        textField.textFieldWillBeginEditingHandler = { [weak textField] (selections) in
            if textField?.text == "" {
                // Selections always default to the first value per component
                textField?.text = selections[0]
            }
        }
    }

    @IBAction func showPressed(_ sender: Any) {
        /*
            McPicker.show(data: data) { [weak self] (selections:[Int: String]) in
                if let name = selections[0] {
                    self?.label.text = name
                }
            }
        */
        /*
            McPicker.show(data: data, doneHandler: { [weak self] (selections) in
                if let name = selections[0] {
                    self?.label.text = name
                }
            }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) in
                let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
                print("Component \(componentThatChanged) changed value to \(newSelection)")
            })
         */
        McPicker.show(data: data, doneHandler: { [weak self] (selections: [Int:String]) in
            if let name = selections[0] {
                self?.label.text = name
            }
        }, cancelHandler: {
            print("Canceled Default Picker")
        }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) in
            let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
            print("Component \(componentThatChanged) changed value to \(newSelection)")
        })
    }

    @IBAction func styledPicker(_ sender: Any) {
        let data: [[String]] = [
            ["Sir", "Mr", "Mrs", "Miss"],
            ["Kevin", "Lauren", "Kibby", "Stella"]
        ]
        let mcPicker = McPicker(data: data)

        let customLabel = UILabel()
        customLabel.textAlignment = .center
        customLabel.textColor = .white
        customLabel.font = UIFont(name:"American Typewriter", size: 30)!
        mcPicker.label = customLabel // Set your custom label

        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Fire!!!") // Set custom Text
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel) // or system items
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])

        mcPicker.toolbarItemsFont = UIFont(name:"American Typewriter", size: 17)!

        mcPicker.toolbarButtonsColor = .white
        mcPicker.toolbarBarTintColor = .darkGray
        mcPicker.pickerBackgroundColor = .gray
        mcPicker.backgroundColor = .gray
        mcPicker.backgroundColorAlpha = 0.50

        mcPicker.pickerSelectRowsForComponents = [
            0: [3: true],
            1: [2: true]
        ]

        if let barButton = sender as? UIBarButtonItem {
            // Show as Popover
            //
            mcPicker.showAsPopover(fromViewController: self, barButtonItem: barButton) { [weak self] (selections: [Int : String]) -> Void in
                if let prefix = selections[0], let name = selections[1] {
                    self?.label.text = "\(prefix) \(name)"
                }
            }
        } else {
            // Show Normal
            //
            /*
                mcPicker.show { [weak self] selections in
                    if let prefix = selections[0], let name = selections[1] {
                        self?.label.text = "\(prefix) \(name)"
                    }
                }
             */
            mcPicker.show(doneHandler: { [weak self] (selections: [Int : String]) -> Void in
                if let prefix = selections[0], let name = selections[1] {
                    self?.label.text = "\(prefix) \(name)"
                }
            }, cancelHandler: {
                print("Canceled Styled Picker")
            }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
                let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
                print("Component \(componentThatChanged) changed value to \(newSelection)")
            })
        }
    }

    @IBAction func popOverPicker(_ sender: UIButton) {
        McPicker.showAsPopover(data:data, fromViewController: self, sourceView: sender, doneHandler: { [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self?.label.text = name
            }
        }, cancelHandler: { () -> Void in
            print("Canceled Popover")
        }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
            let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
            print("Component \(componentThatChanged) changed value to \(newSelection)")
        })
    }

    @IBAction func pressedBarButtonItem(_ sender: UIBarButtonItem) {
        McPicker.showAsPopover(data: data, fromViewController: self, barButtonItem: sender) { [weak self] (selections: [Int : String]) -> Void in
            print("Done with Popover")
            if let name = selections[0] {
                self?.label.text = name
            }
        }
    }
}
