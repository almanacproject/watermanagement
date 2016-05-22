//
//  FirstViewController.swift
//  StorageManagerTester
//
//  Created by Thomas Gilbert on 18/05/16.
//  Copyright © 2016 Thomas Gilbert. All rights reserved.
//

import UIKit
import OGCSensorThings


class FirstViewController: UIViewController {

    @IBOutlet weak var debugWindow: UITextView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var urlStepper: UIStepper!
    
    var validUrls = ["http://almanac.alexandra.dk:8087",
                     "http://almanac-lab.alexandra.dk:8087",
                     "http://cnet006.cloudapp.net/SensorThings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlStepper.wraps = true
        urlStepper.autorepeat = true
        urlStepper.minimumValue = 0
        urlStepper.maximumValue = Double(validUrls.count - 1)
        
        urlTextField.text = validUrls.first
    }
    
    @IBAction func executeQuery() {
        SwaggerClientAPI.basePath = urlTextField.text!
        
        DefaultAPI.datastreamsGet(orderby: nil, top: nil, skip: nil, filter: nil) { (data, error) in
            if let _ = error {
                self.debugWindow.text = ("\(error.debugDescription)\n\(self.debugWindow.text)")
            } else {
                
                self.debugWindow.text = ("I actually counted: \(data?.value?.count)\n\(self.debugWindow.text)")
                self.debugWindow.text = ("Found in the metadata: \(data?.iotCount)\n\(self.debugWindow.text)")
            }
        }
    }
    
    @IBAction func changeUrl(sender: UIStepper) {
        urlTextField.text = validUrls[Int(sender.value)]
    }
    
}

