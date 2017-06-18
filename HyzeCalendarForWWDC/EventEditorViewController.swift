//
//  EventEditorViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 3/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class EventEditorViewController: UIViewController {
    
    // MARK: - Variables
    /// Variable to check if Event should be added to the Calendar
    var addEvent: Bool = false
    
    
    // MARK: - Outlets
    //All the visual Elements in the ViewController
    
    /// Outlet for the navigationBar used through the App
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    /// Outlet for the "done" Button
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    /// Outlet for the textField for the Input of the EventTitle
    @IBOutlet weak var titleTF: UITextField!
    
    /// Outlet for the datePicker for the Input of the EventStartTime
    @IBOutlet weak var startTimeDP: UIDatePicker!
    
    /// Outlet for the datePicker for the Input of the EventStartTime
    @IBOutlet weak var endTimeDP: UIDatePicker!
    
    // MARK: - Actions
    @IBAction func donepressed(_ sender: UIBarButtonItem) {
        addEvent = true
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sd = sender as? UIBarButtonItem else{
            print("sender not found")
            return
        }
        if sd.tag == 2 {
            if informationMode {
            print("added Event")
            }
            EManagement.addEvent(title: titleTF.text ?? "NoEventTitle", from: startTimeDP.date, to: endTimeDP.date)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
