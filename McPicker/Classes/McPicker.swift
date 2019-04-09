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

open class McPicker: UIView {

    open var fontSize: CGFloat = 25.0
    open var backgroundColorAlpha: CGFloat?

    /**
        The custom label to use with the picker.
     
        ```
             let customLabel = UILabel()
             customLabel.textAlignment = .center
             customLabel.textColor = .white
             customLabel.font = UIFont(name:"American Typewriter", size: 30)!
     
             mcPicker.label = customLabel // Set your custom label
         ```
     */
    open var label: UILabel?

    public var toolbarButtonsColor: UIColor? {
        didSet {
            applyToolbarButtonItemsSettings { (barButtonItem) in
                barButtonItem.tintColor = toolbarButtonsColor
            }
        }
    }
    public var toolbarDoneButtonColor: UIColor? {
        didSet {
            applyToolbarButtonItemsSettings(withAction: #selector(McPicker.done)) { (barButtonItem) in
                barButtonItem.tintColor = toolbarDoneButtonColor
            }
        }
    }
    public var toolbarCancelButtonColor: UIColor? {
        didSet {
            applyToolbarButtonItemsSettings(withAction: #selector(McPicker.cancel)) { (barButtonItem) in
                barButtonItem.tintColor = toolbarCancelButtonColor
            }
        }
    }
    public var toolbarItemsFont: UIFont? {
        didSet {
            applyToolbarButtonItemsSettings { (barButtonItem) in
                barButtonItem.setTitleTextAttributes([.font: toolbarItemsFont!], for: .normal)
                barButtonItem.setTitleTextAttributes([.font: toolbarItemsFont!], for: .selected)
            }
        }
    }
    public var toolbarBarTintColor: UIColor? {
        didSet { toolbar.barTintColor = toolbarBarTintColor }
    }
    public var pickerBackgroundColor: UIColor? {
        didSet { picker.backgroundColor = pickerBackgroundColor }
    }
    /**
        Sets the picker's components row position and picker selections to those String values.

        [Int:[Int:Bool]] equates to [Component: [Row: isAnimated]
    */
    public var pickerSelectRowsForComponents: [Int: [Int: Bool]]? {
        didSet {
            for component in pickerSelectRowsForComponents!.keys {
                if let row = pickerSelectRowsForComponents![component]?.keys.first,
                    let isAnimated = pickerSelectRowsForComponents![component]?.values.first {
                    pickerSelection[component] = pickerData[component][row]
                    picker.selectRow(row, inComponent: component, animated: isAnimated)
                }
            }
        }
    }
    public var showsSelectionIndicator: Bool? {
        didSet { picker.showsSelectionIndicator = showsSelectionIndicator ?? false }
    }

    public typealias DoneHandler = (_ selections: [Int:String]) -> Void
    public typealias CancelHandler = (() -> Void)
    public typealias SelectionChangedHandler = ((_ selections: [Int:String], _ componentThatChanged: Int) -> Void)

    internal var popOverContentSize: CGSize {
        return CGSize(width: Constant.pickerHeight + Constant.toolBarHeight, height: Constant.pickerHeight + Constant.toolBarHeight)
    }
    internal var _backgroundColorAlpha: CGFloat {
        return self.backgroundColorAlpha ?? Constant.backgroundColorAlpha
    }
    internal var pickerSelection: [Int:String] = [:]
    internal var pickerData: [[String]] = []
    internal var numberOfComponents: Int {
        return pickerData.count
    }
    internal let picker: UIPickerView = UIPickerView()
    internal let backgroundView: UIView = UIView()
    internal let toolbar: UIToolbar = UIToolbar()
    internal var isPopoverMode = false
    internal var mcPickerPopoverViewController: McPickerPopoverViewController?
    internal enum AnimationDirection {
        case `in`, out // swiftlint:disable:this identifier_name
    }
    internal enum Constant {
        static let backgroundColorAlpha: CGFloat =  0.75
        static let pickerHeight: CGFloat = 216.0
        static let toolBarHeight: CGFloat = 44.0
        static let animationSpeed: TimeInterval = 0.25
        static let barButtonFixedSpacePadding: CGFloat = 0.02
    }

    fileprivate var doneHandler: DoneHandler = {_ in }
    fileprivate var cancelHandler: CancelHandler?
    fileprivate var selectionChangedHandler: SelectionChangedHandler?

    private var appWindow: UIWindow {
        guard let window = UIApplication.shared.keyWindow else {
            debugPrint("KeyWindow not set. Returning a default window for unit testing.")
            return UIWindow()
        }
        return window
    }

    convenience public init(data: [[String]]) {
        self.init(frame: CGRect.zero)
        self.pickerData = data
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: Show
    //
    open class func show(data: [[String]],
                         doneHandler: @escaping DoneHandler,
                         cancelHandler: CancelHandler? = nil,
                         selectionChangedHandler: SelectionChangedHandler? = nil) {
        McPicker(data:data).show(doneHandler: doneHandler, cancelHandler: cancelHandler, selectionChangedHandler: selectionChangedHandler)
    }

    open class func show(data: [[String]], doneHandler: @escaping DoneHandler) {
        McPicker(data:data).show(doneHandler: doneHandler)
    }

    open func show(doneHandler: @escaping DoneHandler) {
        show(doneHandler: doneHandler, cancelHandler: nil, selectionChangedHandler: nil)
    }

    open func show(doneHandler: @escaping DoneHandler,
                   cancelHandler: CancelHandler? = nil,
                   selectionChangedHandler: SelectionChangedHandler? = nil) {
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
        self.selectionChangedHandler = selectionChangedHandler
        animateViews(direction: .in)
    }

    // MARK: Show As Popover
    //
    open class func showAsPopover(data: [[String]],
                                  fromViewController: UIViewController,
                                  sourceView: UIView? = nil,
                                  sourceRect: CGRect? = nil,
                                  barButtonItem: UIBarButtonItem? = nil,
                                  doneHandler: @escaping DoneHandler,
                                  cancelHandler: CancelHandler? = nil,
                                  selectionChangedHandler: SelectionChangedHandler? = nil) {
        McPicker(data: data).showAsPopover(fromViewController: fromViewController,
                                           sourceView: sourceView,
                                           sourceRect: sourceRect,
                                           barButtonItem: barButtonItem,
                                           doneHandler: doneHandler,
                                           cancelHandler: cancelHandler,
                                           selectionChangedHandler: selectionChangedHandler)
    }

    open class func showAsPopover(data: [[String]],
                                  fromViewController: UIViewController,
                                  sourceView: UIView? = nil,
                                  sourceRect: CGRect? = nil,
                                  barButtonItem: UIBarButtonItem? = nil,
                                  doneHandler: @escaping DoneHandler) {
        McPicker(data: data).showAsPopover(fromViewController: fromViewController,
                                           sourceView: sourceView,
                                           sourceRect: sourceRect,
                                           barButtonItem: barButtonItem,
                                           doneHandler: doneHandler,
                                           cancelHandler: nil,
                                           selectionChangedHandler: nil)
    }

    open func showAsPopover(fromViewController: UIViewController,
                            sourceView: UIView? = nil,
                            sourceRect: CGRect? = nil,
                            barButtonItem: UIBarButtonItem? = nil,
                            doneHandler: @escaping DoneHandler) {
        self.showAsPopover(fromViewController: fromViewController,
                           sourceView: sourceView,
                           sourceRect: sourceRect,
                           barButtonItem: barButtonItem,
                           doneHandler: doneHandler,
                           cancelHandler: nil,
                           selectionChangedHandler: nil)
    }

    open func showAsPopover(fromViewController: UIViewController,
                            sourceView: UIView? = nil,
                            sourceRect: CGRect? = nil,
                            barButtonItem: UIBarButtonItem? = nil,
                            doneHandler: @escaping DoneHandler,
                            cancelHandler: CancelHandler? = nil,
                            selectionChangedHandler: SelectionChangedHandler? = nil) {

        if sourceView == nil && barButtonItem == nil {
            fatalError("You must set at least 'sourceView' or 'barButtonItem'")
        }

        self.isPopoverMode = true
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
        self.selectionChangedHandler = selectionChangedHandler

        mcPickerPopoverViewController = McPickerPopoverViewController(mcPicker: self)
        mcPickerPopoverViewController?.modalPresentationStyle = UIModalPresentationStyle.popover

        let popover = mcPickerPopoverViewController?.popoverPresentationController
        popover?.delegate = self

        if let sView = sourceView {
            popover?.sourceView = sView
            popover?.sourceRect = sourceRect ?? sView.bounds
        } else {
            popover?.barButtonItem = barButtonItem
        }

        fromViewController.present(mcPickerPopoverViewController!, animated: true)
    }

    open func setToolbarItems(items: [McPickerBarButtonItem]) {
        toolbar.items = items

        setToolbarProperties()
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        if newWindow != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(McPicker.sizeViews), name: UIDevice.orientationDidChangeNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }

    @objc internal func sizeViews() {
        let size = isPopoverMode ? popOverContentSize : self.appWindow.bounds.size
        self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        let backgroundViewY = isPopoverMode ? 0 : self.bounds.size.height - (Constant.pickerHeight + Constant.toolBarHeight)
        backgroundView.frame = CGRect(x: 0, y: backgroundViewY, width: self.bounds.size.width, height: Constant.pickerHeight + Constant.toolBarHeight)
        toolbar.frame = CGRect(x: 0, y: 0, width: backgroundView.bounds.size.width, height: Constant.toolBarHeight)
        picker.frame = CGRect(x: 0, y: toolbar.bounds.size.height, width: backgroundView.bounds.size.width, height: Constant.pickerHeight)
    }

    internal func addAllSubviews() {
        backgroundView.addSubview(picker)
        backgroundView.addSubview(toolbar)
        self.addSubview(backgroundView)
    }

    internal func dismissViews() {
        if isPopoverMode {
            mcPickerPopoverViewController?.dismiss(animated: true, completion: nil)
            mcPickerPopoverViewController = nil // Release, as to not create a retain cycle.
        } else {
            animateViews(direction: .out)
        }
    }

    internal func animateViews(direction: AnimationDirection) {
        var backgroundFrame = backgroundView.frame
        let animateColor = self.backgroundColor ?? .black

        if direction == .in {
            // Start transparent
            //
            self.backgroundColor = animateColor.withAlphaComponent(0)

            // Start picker off the bottom of the screen
            //
            backgroundFrame.origin.y = self.appWindow.bounds.size.height
            backgroundView.frame = backgroundFrame

            // Add views
            //
            addAllSubviews()
            appWindow.addSubview(self)

            // Animate things on screen
            //
            UIView.animate(withDuration: Constant.animationSpeed, animations: {
                self.backgroundColor = animateColor.withAlphaComponent(self._backgroundColorAlpha)
                backgroundFrame.origin.y = self.appWindow.bounds.size.height - self.backgroundView.bounds.height
                self.backgroundView.frame = backgroundFrame
            })
        } else {
            // Animate things off screen
            //
            UIView.animate(withDuration: Constant.animationSpeed, animations: {
                self.backgroundColor = animateColor.withAlphaComponent(0)
                backgroundFrame.origin.y = self.appWindow.bounds.size.height
                self.backgroundView.frame = backgroundFrame
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }

    @objc internal func done() {
        self.doneHandler(self.pickerSelection)
        self.dismissViews()
    }

    @objc internal func cancel() {
        self.cancelHandler?()
        self.dismissViews()
    }

    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(McPicker.cancel))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)

        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: appWindow.bounds.size.width * Constant.barButtonFixedSpacePadding)
        setToolbarItems(items: [fixedSpace, McPickerBarButtonItem.cancel(mcPicker: self),
                                McPickerBarButtonItem.flexibleSpace(), McPickerBarButtonItem.done(mcPicker: self), fixedSpace])

        backgroundView.backgroundColor = UIColor.white

        picker.delegate = self
        picker.dataSource = self

        sizeViews()

        // Default selection to first item per component
        //
        for (index, element) in pickerData.enumerated() {
            pickerSelection[index] = element.first
        }
    }

    private func setToolbarProperties() {
        if let _toolbarButtonsColor = toolbarButtonsColor {
            toolbarButtonsColor = _toolbarButtonsColor
        }

        if let _toolbarDoneButtonColor = toolbarDoneButtonColor {
            toolbarDoneButtonColor = _toolbarDoneButtonColor
        }

        if let _toolbarCancelButtonColor = toolbarCancelButtonColor {
            toolbarCancelButtonColor = _toolbarCancelButtonColor
        }

        if let _toolbarItemsFont = toolbarItemsFont {
            toolbarItemsFont = _toolbarItemsFont
        }
    }

    private func applyToolbarButtonItemsSettings(withAction: Selector? = nil, settings: (_ barButton: UIBarButtonItem) -> Void) {
        for item in toolbar.items ?? [] {
            if let action = withAction, action == item.action {
                settings(item)
            }

            if withAction == nil {
                settings(item)
            }
        }
    }
}

extension McPicker : UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
}

extension McPicker : UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()

            if let goodLabel = label {
                pickerLabel?.textAlignment = goodLabel.textAlignment
                pickerLabel?.font = goodLabel.font
                pickerLabel?.textColor = goodLabel.textColor
                pickerLabel?.backgroundColor = goodLabel.backgroundColor
                pickerLabel?.numberOfLines = goodLabel.numberOfLines
            } else {
                pickerLabel?.textAlignment = .center
                pickerLabel?.font = UIFont.systemFont(ofSize: self.fontSize)
            }
        }

        pickerLabel?.text = pickerData[component][row]

        return pickerLabel!
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if !pickerData[component].isEmpty {
            self.pickerSelection[component] = pickerData[component][row]
            self.selectionChangedHandler?(self.pickerSelection, component)
        }
    }
}

extension McPicker : UIPopoverPresentationControllerDelegate {
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.cancelHandler?()
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .none
    }

    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone X Plus
        return .none
    }
}

extension McPicker : UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let goodView = touch.view {
            return goodView == self
        }
        return false
    }
}

extension McPicker : UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let mcTextField = textField as? McTextField {
            mcTextField.textFieldWillBeginEditingHandler?(self.pickerSelection)
            self.show(doneHandler: mcTextField.doneHandler,
                      cancelHandler: mcTextField.cancelHandler,
                      selectionChangedHandler: mcTextField.selectionChangedHandler)
            return false
        }
        return true
    }
}
