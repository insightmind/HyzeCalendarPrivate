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
    
	@IBOutlet weak var divideTitle: UIView!
	
    // MARK: - Outlets
    //All the visual Elements in the ViewController
	
	
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
		divideTitle.layer.cornerRadius = divideTitle.frame.height / 2
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
            //EManagement.addEvent(title: titleTF.text ?? "NoEventTitle", from: startTimeDP.date, to: endTimeDP.date)
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
