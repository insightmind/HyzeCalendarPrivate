//
//  DayViewUIViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DayViewUIVViewController: UIViewController {

    @IBOutlet weak var day: DayView!
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
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//day.addEventsSubViews()
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        viewIsDayView = true
        renDayView = nil
    }
    
    func setdarkMode(){
        if darkMode {
			toolbar.barTintColor = Theme.calendarGrey
			editButton.tintColor = Theme.calendarWhite
            view.backgroundColor = Theme.calendarGrey
			navigationController?.navigationBar.tintColor = Theme.calendarWhite
			addButton.tintColor = Theme.calendarWhite
        } else {
			toolbar.barTintColor = Theme.calendarWhite
			editButton.tintColor = Theme.calendarGrey
            view.backgroundColor = Theme.calendarWhite
			navigationController?.navigationBar.tintColor = Theme.calendarGrey
			addButton.tintColor = Theme.calendarGrey
        }
		if HSelection.selectedIsOnWeekend! {
			day.dayViewCenterButton.backgroundColor = Theme.calendarGreen
		} else {
			day.dayViewCenterButton.backgroundColor = Theme.calendarBlue
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
