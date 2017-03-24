//
//  McPicker.swift
//  Pods
//
//  Created by Kevin McGill on 3/22/17.
//
//

import UIKit

open class McPicker: UIView {
    
    enum AnimationDirection {
        case `in`, out
    }
    
    fileprivate var pickerSelection:String = ""
    
    fileprivate var pickerData:[String:Any] = [:]
    
    fileprivate var numberOfComponents:Int {
        get {
            if let numOfComponents = pickerData["numberOfComponents"] as? Int {
                return numOfComponents
            }
            return 1
        }
    }
    
    fileprivate var displayData:[String] {
        get {
            if let strings = pickerData["displayData"] as? [String] {
                return strings
            }
            return []
        }
    }
    
    fileprivate var picker:UIPickerView = UIPickerView()
    fileprivate var toolbar:UIToolbar = UIToolbar()
    
    private let backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(done))
    
    private let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancel))
    
    private let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
    
    private var topViewController:UIViewController {
        get {
            return UIApplication.topViewController()!
        }
    }
    
    private let PICKER_HEIGHT:CGFloat = 216.0
    private let TOOLBAR_HEIGHT:CGFloat = 44.0
    private let BACKGROUND_ALPHA:CGFloat =  0.75

    private var doneHandler:(_ word:String) -> Void = {_ in }
    private var cancelHandler:() -> Void = {_ in }

    
    convenience public init(pickerData:[String:Any]) {
        self.init(frame: CGRect.zero)
        
        self.pickerData = pickerData

        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    private func setup() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
        
        setToolbarItems(items: [cancelBarButton, flexibleSpace, doneBarButton])
        
        self.backgroundColor = UIColor.black
        
        picker.delegate = self
        picker.dataSource = self
        
        sizeViews()
        
        // Default selection to first item
        //
        if let firstItem = displayData.first {
            pickerSelection = firstItem
        }
    }

    open func show(cancelHandler:@escaping () -> Void, doneHandler:@escaping (_ word:String) -> Void){
        
        self.doneHandler = doneHandler
        self.cancelHandler = cancelHandler
        
        animateViews(animationDirection: .in)
    }
    
    open class func show(cancelHandler:@escaping () -> Void, doneHandler:@escaping (_ word:String) -> Void) {
        // TODO: implement
    }
    
    open func setToolbarItems(items: [UIBarButtonItem]) {
        toolbar.items = items
    }
    
    func done() {
        self.doneHandler(self.pickerSelection)
        self.removeFromSuperview()
    }
    
    func cancel() {
        self.cancelHandler()
        self.removeFromSuperview()
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if let _ = newWindow {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(sizeViews),
                                                   name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                   object: nil)
        } else {
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                      object: nil)
        }
    }

    func animateViews(animationDirection:AnimationDirection){
        
        // Default to 'out' state
        //
        self.alpha = 0.0
        
        if animationDirection == .in {
            self.alpha = BACKGROUND_ALPHA

            
            self.addSubview(picker)
            self.addSubview(toolbar)
            topViewController.view.addSubview(self)
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            
        }, completion: { completed in
            
        })
        

    }

    func sizeViews() {
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: self.topViewController.view.bounds.size.width,
                            height: self.topViewController.view.bounds.size.height)
        
        backgroundView.frame = CGRect(x: 0,
                                      y: self.bounds.size.height,
                                      width: self.bounds.size.width,
                                      height: PICKER_HEIGHT + TOOLBAR_HEIGHT)

        toolbar.frame = CGRect(x: 0,
                               y: 0,
                               width: backgroundView.bounds.size.width,
                               height: TOOLBAR_HEIGHT)
        picker.frame = CGRect(x: 0,
                              y: toolbar.bounds.size.height,
                              width: backgroundView.bounds.size.width,
                              height: PICKER_HEIGHT)
    }
    
}


extension McPicker : UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.displayData.count
    }
}


extension McPicker : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.displayData[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelection = self.displayData[row]
    }
}


extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
