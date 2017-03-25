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
        let data:[String : Any] = [
            "numberOfComponents" : 1, // Defaults to 1 if omitted
            "displayData" : ["Kevin", "Lauren", "Kibby", "Stella"],
        ]
        
        let picker = McPicker(pickerData:data)
        picker.show(cancelHandler: {
            
            // Do something interesting
            //
            print("Picker canceled.")
            
        }, doneHandler: { selection in
            
            // Selection Made
            //
            self.label.text = selection
        })
*/
        
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

    }
    
}

