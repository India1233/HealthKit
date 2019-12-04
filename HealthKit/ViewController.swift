//
//  ViewController.swift
//  HealthKit
//
//  Created by shiga on 05/12/19.
//  Copyright © 2019 Shigas. All rights reserved.
//
//https://medium.com/better-programming/how-to-save-data-to-apple-health-in-swift-1a5982a4e8f3

import UIKit
import HealthKit

class ViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        HealthKitAssistant.authorizeHealthKit { (result, error) in
            if result {
                print("Auth ok")
            } else {
                print("Auth denied")
            }
            
        }
    }

    @IBAction func save(_ sender: Any) {
        guard let value = textField.text else {
            return
        }
        
        HealthKitAssistant.saveSteps(stepsCountValue: Int(value)!, date: datePicker.date) { (error) in
            print(error ?? "")
        }
    }
    
}

