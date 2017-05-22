//
//  ViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import CoreGraphics

enum ScrollDirection{
	case up
	case down
}

class ViewController: UIViewController {
    
    var load = 1
    var darkModeTemp: Bool!
    var isAMPMTemp: Bool!
	
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var selectedDayButton: UIBarButtonItem!
    @IBOutlet weak var eventTableView: EventTableView!
    @IBOutlet weak var toolbar: UIToolbar!

    //Outlets of DaysOfWeek
    @IBOutlet weak var FirstDayOfWeek: UILabel!
    @IBOutlet weak var SecondDayOfWeek: UILabel!
    @IBOutlet weak var ThirdDayOfWeek: UILabel!
    @IBOutlet weak var FourthDayOfWeek: UILabel!
    @IBOutlet weak var FivthDayOfWeek: UILabel!
    @IBOutlet weak var SixthDayOfWeek: UILabel!
    @IBOutlet weak var SeventhDayOfWeek: UILabel!
    let daysOfWeek: [UILabel]? = nil

    
    
    @IBAction func jumpToToday(_ sender: UIBarButtonItem) {

    }
    
    @IBAction func jumpToSelected(_ sender: UIBarButtonItem) {
		
    }

    @IBAction func scrollDown(_ sender: UISwipeGestureRecognizer) {

    }
    @IBAction func scrollUp(_ sender: UISwipeGestureRecognizer) {

    }

    func updateSelectedDayIcon(){

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if darkMode{
            view.backgroundColor = CALENDARGREY
            updateDaysOfWeek(color: CALENDARWHITE)
        } else {
            view.backgroundColor = CALENDARWHITE
            updateDaysOfWeek(color: CALENDARGREY)
        }
        if darkModeTemp != darkMode {
            darkModeTemp = darkMode
        } else if isAMPMTemp != isAMPM || eventsChange == true {
            eventsChange = false
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        darkModeTemp = darkMode
		HSelection.selectedTime = TMTime(date: Date())
        navigationBar.title = TimeManagement.getMonthName(HSelection.selectedTime.conformToDate())
		
    }

    func updateDaysOfWeek(color: UIColor) {
        FirstDayOfWeek.textColor = color
        SecondDayOfWeek.textColor = color
        ThirdDayOfWeek.textColor = color
        FourthDayOfWeek.textColor = color
        FivthDayOfWeek.textColor = color
        SixthDayOfWeek.textColor = color
        SeventhDayOfWeek.textColor = color
    }
    
    @IBAction func unwindToMonthView(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: Function
	
	func scrollToSection(yearID: Int, monthID: Int) {
		
	}
	
	func scrollToSection(direction: ScrollDirection) {
		
	}
}

