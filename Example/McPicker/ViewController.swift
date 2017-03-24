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
        
        // Setup data
        //
        let data:[String : Any] = [
            "numberOfComponents" : 1,
            "displayData" : ["Kevin", "Lauren", "Kibby", "Stella"],
        ]
        
        // Init picker
        //
        let picker = McPicker(pickerData:data)
        
        // Show Picker
        //
        picker.show(cancelHandler: {
            print("Picker canceled.")
        }, doneHandler: { selection in
           self.label.text = selection
        })

    }
    
}

