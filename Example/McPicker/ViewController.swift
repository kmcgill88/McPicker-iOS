//
//  ViewController.swift
//  McPicker
//
//  Created by Kevin McGill on 03/22/2017.
//  Copyright (c) 2017 Kevin McGill. All rights reserved.
//

import UIKit
import McPicker

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
        McPicker.show(data: [["Kevin", "Lauren", "Kibby", "Stella"]], doneHandler: { selections in
            // Selection(s) Made
            //
            if let name = selections[0] {
                self.label.text = name
            }
        })
    }
    
    @IBAction func styledPicker(_ sender: Any) {

        let customLabel = UILabel()
        customLabel.textAlignment = .center
        customLabel.textColor = UIColor.white
        customLabel.font = UIFont(name:"American Typewriter", size: 30)!

        let data:[[String]] = [
            ["Sir", "Mr", "Mrs", "Miss"],
            ["Kevin", "Lauren", "Kibby", "Stella"]
        ]

        let picker = McPicker(data:data)
        picker.label = customLabel // Set your custom label
        picker.toolBarButtonsColor = .white
        picker.toolbarBarTintColor = .darkGray
        picker.pickerBackgroundColor = .gray
        
        picker.show(doneHandler: { selections in
            
            if let prefix = selections[0], let name = selections[1] {
                self.label.text = "\(prefix) \(name)"
            }
        })
        
    }
    
}
