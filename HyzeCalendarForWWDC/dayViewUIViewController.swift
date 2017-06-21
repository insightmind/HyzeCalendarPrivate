//
//  dayViewUIViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class dayViewUIVViewController: UIViewController {

    @IBOutlet weak var day: dayView!
	@IBOutlet weak var addButton: UIBarButtonItem!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var editButton: UIBarButtonItem!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setdarkMode()
        viewIsDayView = true
        renDayView = day
        day.setUp()


        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewIsDayView = true
        renDayView = nil
    }
    
    func setdarkMode(){
        if darkMode {
			toolbar.barTintColor = calendarWhite
			editButton.tintColor = calendarGrey
            view.backgroundColor = calendarGrey
			navigationController?.navigationBar.tintColor = calendarWhite
			addButton.tintColor = calendarWhite
        } else {
			toolbar.barTintColor = calendarGrey
			editButton.tintColor = calendarWhite
            view.backgroundColor = calendarWhite
			navigationController?.navigationBar.tintColor = calendarGrey
			addButton.tintColor = calendarGrey
        }
		if HSelection.selectedIsOnWeekend! {
			day.dayViewCenterButton.backgroundColor = calendarGreen
		} else {
			day.dayViewCenterButton.backgroundColor = calendarBlue
		}
		
    }
    
    @IBAction func unwindToRed(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            
        
    }
     */
}
