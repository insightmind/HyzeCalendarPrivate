//
//  ViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController {
    
    var load = 1
    var darkModeTemp: Bool!
    var isAMPMTemp: Bool!

    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarview: CalendarView!
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
        
        
        if TMCalendar.isDateInToday(HSelection.selectedTime.conformToDate()) != true {
            if calendarview.visibleMonth == HTimeManagement.TMToday.conformToIndexPath().section {
                if informationMode {
                    print("jumpToToday todaysIndexPath:\(HTimeManagement.TMToday.conformToIndexPath())")
                }
                guard let todaysCell = calendarview.cellForItem(at: HTimeManagement.TMToday.conformToIndexPath()) as? CalendarViewCell else {
                    if failureMode {
                        print("[FAILURE] There is no cell for today")
                    }
                    return
                }
                calendarview.visualDeselectCell(calendarview)
                calendarview.visualSelectCell(todaysCell, isToday: true)
                HSelection.selectedTime = HTimeManagement.TMToday
            
            } else {
                HSelection.selectedTime = HTimeManagement.TMToday
            }
            eventTableView.reloadView()
        }
        navigationBar.title = TimeManagement.getMonthName(HSelection.selectedTime.conformToDate())
        
        calendarview.scrollToNextSection(calendarview, monthIndex: HSelection.selectedTime.conformToIndexPath().section, animated: true)
        
        updateSelectedDayIcon()
    }
    
    @IBAction func jumpToSelected(_ sender: UIBarButtonItem) {
        navigationBar.title = TimeManagement.getMonthName(HSelection.selectedTime.conformToDate())
        
        calendarview.scrollToNextSection(calendarview, monthIndex: HSelection.selectedTime.conformToIndexPath().section, animated: true)
        
        updateSelectedDayIcon()
    }

    @IBAction func scrollDown(_ sender: UISwipeGestureRecognizer) {
		HSelection.currentSection += 1
		updateScrolling(animated: true)
        navigationBar.title = TimeManagement.getMonthName(TimeManagement.calculateFirstDayInMonth(of: Date())!)
        updateSelectedDayIcon()
    }
    @IBAction func scrollUp(_ sender: UISwipeGestureRecognizer) {
		HSelection.currentSection -= 1
        updateScrolling(animated: true)
        navigationBar.title = TimeManagement.getMonthName(TimeManagement.calculateFirstDayInMonth(of: Date())!)
        updateSelectedDayIcon()
    }

    func updateSelectedDayIcon(){
        if calendarview.visibleMonth < HSelection.selectedTime.conformToIndexPath().section {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down")
        } else if calendarview.visibleMonth > HSelection.selectedTime.conformToIndexPath().section {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_up")
        } else {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_right")
        }
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
            eventTableView.reloadData()
            calendarview.reloadSections(IndexSet(integer: calendarview.visibleMonth))
            darkModeTemp = darkMode
        } else if isAMPMTemp != isAMPM || eventsChange == true {
            eventTableView.reloadData()
            eventTableView.reloadView()
            eventsChange = false
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        darkModeTemp = darkMode
		HSelection.selectedTime = TMTime(date: Date())
        navigationBar.title = TimeManagement.getMonthName(HSelection.selectedTime.conformToDate())
		
		calendarview.scrollsToTop = false
		
		HSelection.currentSection = HSelection.selectedTime.monthID
		
        calendarview.backgroundColor = UIColor.clear
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
	
	func updateScrolling(animated: Bool) {
		calendarview.scrollToNextSection(calendarview, monthIndex: HSelection.currentSection, animated: animated)
	}
}

