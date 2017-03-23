//
//  McPicker.swift
//  Pods
//
//  Created by Kevin McGill on 3/22/17.
//
//

import UIKit

open class McPicker: UIView {
    
    fileprivate var pickerData:[String:Any] {
        get {
            if pickerData.isEmpty {
                return [
                    "numberOfComponents" : 1,
                    "displayData" : [],
                ]
            }
            
            return pickerData
        }
        
        set {
            if newValue["displayData"] == nil {
                fatalError("Missing required 'displayData' (an array of strings) in data dictionary!")
            }
        }
    }
    
    private var topViewController:UIViewController {
        get {
            return UIApplication.topViewController()!
        }
    }
    
    fileprivate var numberOfComponents:Int {
        get {
            if let numOfComponents = self.pickerData["numberOfComponents"] as? Int {
                return numOfComponents
            }
            
            return 1
        }
    }
    
    fileprivate var displayData:[String] {
        get {
            if let strings = self.pickerData["displayData"] as? [String] {
                return strings
            }
            
            return []
        }
    }
    
    
    
    convenience public init(pickerData:[String:Any]) {
        self.init(frame: CGRect.zero)
        self.pickerData = pickerData

        self.frame = CGRect(x: 0,
                            y: self.topViewController.view.bounds.size.width - 50,
                            width: self.topViewController.view.bounds.size.width,
                            height: 50)
        
        self.backgroundColor = UIColor.blue
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    open func show(){

        topViewController.view.addSubview(self)
    }
    
    open class func show(done:(_ word:String) -> String) {
        
        let result = done("Kevin")
        print(result)
    }
}


extension McPicker : UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.displayData.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: self.displayData[row], attributes: nil)
    }
}


extension McPicker : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Picked: \(row)")
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
