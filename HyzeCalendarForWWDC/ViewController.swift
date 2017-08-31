//
//  ViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import CoreGraphics

public enum ScrollDirection {
	case up
	case down
}

class ViewController: UIViewController {
    
    var load = 1
    var darkModeTemp: Bool!
    var isAMPMTemp: Bool!
	
	var calendarViewController: MainCollectionViewController? = nil
	
	@IBOutlet weak var calendarView: UIView!
    @IBOutlet public weak var navigationBar: UINavigationItem!
    @IBOutlet weak var selectedDayButton: UIBarButtonItem!
    @IBOutlet weak var ETView: ETView!
    @IBOutlet weak var toolbar: UIToolbar!

	//Outlets of DaysOfWeek
    @IBOutlet weak var FirstDayOfWeek: UILabel!
    @IBOutlet weak var SecondDayOfWeek: UILabel!
    @IBOutlet weak var ThirdDayOfWeek: UILabel!
    @IBOutlet weak var FourthDayOfWeek: UILabel!
    @IBOutlet weak var FivthDayOfWeek: UILabel!
    @IBOutlet weak var SixthDayOfWeek: UILabel!
    @IBOutlet weak var SeventhDayOfWeek: UILabel!
	@IBOutlet weak var ETViewTopLayoutConstraint: NSLayoutConstraint!
	
	var daysOfWeek: [WeekDay: UILabel] = [:]

	@IBOutlet weak var daysOfWeekBackgroundView: UIView!
	@IBOutlet weak var ETViewTopLayoutConstraintWithoutLastRow: NSLayoutConstraint!
	
    
    @IBAction func jumpToToday(_ sender: UIBarButtonItem) {
        let (yearID, monthID, _) = Selection.shared.todaysDayCellIndex
		Selection.shared.selectedDayCellIndex = Selection.shared.todaysDayCellIndex
		scrollToSection(yearID: yearID, monthID: monthID + 1, animated: true)
    }
    
    @IBAction func jumpToSelected(_ sender: UIBarButtonItem) {
        let (yearID, monthID, _ ) = Selection.shared.selectedDayCellIndex
        scrollToSection(yearID: yearID, monthID: monthID + 1, animated: true)
    }

    func updateSelectedDayIcon(){
        let (yearID, monthID, _ ) = Selection.shared.selectedDayCellIndex
        if yearID > Selection.shared.currentYearID || monthID > Selection.shared.currentMonthID - 1 {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down")
        } else if yearID < Selection.shared.currentYearID || monthID < Selection.shared.currentMonthID - 1 {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_up")
        } else {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_right")
        }
    }
	
    override func viewWillAppear(_ animated: Bool) {
		
		if EventManagement.shared.askForPermission() {
			calendarView.setNeedsDisplay()
			ETView.setNeedsDisplay()
		}
		
		self.calendarView.layer.masksToBounds = false
        if Settings.shared.isDarkMode{
            view.backgroundColor = Color.grey
			daysOfWeekBackgroundView.backgroundColor = Color.grey
			updateDaysOfWeek(color: Color.white, weekendColor: Color.green)
			navigationController?.navigationBar.barTintColor = Color.grey
			navigationController?.navigationBar.titleTextAttributes![NSAttributedStringKey.foregroundColor] = Color.white
			navigationBar.backBarButtonItem?.tintColor = Color.grey
			navigationBar.leftBarButtonItem?.tintColor = Color.white
			navigationBar.rightBarButtonItem?.tintColor = Color.white
			toolbar.barTintColor = Color.grey
			if toolbar.items != nil {
				for i in toolbar.items! {
					i.tintColor = Color.white
				}
			}
        } else {
            view.backgroundColor = Color.white
			daysOfWeekBackgroundView.backgroundColor = Color.white
			updateDaysOfWeek(color: Color.grey, weekendColor: Color.green)
			navigationController?.navigationBar.barTintColor = Color.white
			navigationController?.navigationBar.titleTextAttributes![NSAttributedStringKey.foregroundColor] = Color.grey
			navigationBar.backBarButtonItem?.tintColor = Color.grey
			navigationBar.leftBarButtonItem?.tintColor = Color.grey
			navigationBar.rightBarButtonItem?.tintColor = Color.grey
			toolbar.barTintColor = Color.white
			if toolbar.items != nil {
				for i in toolbar.items! {
					i.tintColor = Color.grey
				}
			}
        }
        if darkModeTemp != Settings.shared.isDarkMode {
            darkModeTemp = Settings.shared.isDarkMode
        } else if isAMPMTemp != Settings.shared.isAMPM || Settings.shared.eventsChange == true {
            Settings.shared.eventsChange = false
        }
        ETView.reloadView()
    }
	
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
		
		if ContactManagement.shared.askForPermission() {
			print("Contacts access granted")
		}
		
        darkModeTemp = Settings.shared.isDarkMode
        navigationBar.title = TimeManagement.getMonthName(Date())
		
		setTodaysProperties()
		
		for i in childViewControllers {
			if i.title == "CalendarView" {
				self.calendarViewController = i as? MainCollectionViewController
			}
		}
        
        let (selectedYearID, selectedMonthID, _) = Selection.shared.selectedDayCellIndex
		
		scrollToSection(yearID: selectedYearID, monthID: selectedMonthID - 1)
    }
	
	func setTodaysProperties() {
		let date = Date()
		Selection.shared.todaysYearID = TimeManagement.calendar.component(.year, from: date)
		Selection.shared.todaysMonthID = TimeManagement.calendar.component(.month, from: date)
		Selection.shared.todaysDayID = TimeManagement.calendar.component(.day, from: date)
	}

	func updateDaysOfWeek(color: UIColor, weekendColor: UIColor) {
		
		let unconfiguredDaysOfWeek: [UILabel] = [FirstDayOfWeek,
		                              SecondDayOfWeek,
		                              ThirdDayOfWeek,
		                              FourthDayOfWeek,
		                              FivthDayOfWeek,
		                              SixthDayOfWeek,
		                              SeventhDayOfWeek]
		
		var state = Selection.shared.weekDayStart
		
		for i in unconfiguredDaysOfWeek {
			
			daysOfWeek[state] = i
			
			if state.rawValue != 6 {
				state = WeekDay(rawValue: state.rawValue + 1)!
			} else {
				state = WeekDay.sunday
			}
			
		}
		
		for i in daysOfWeek {
			switch i.key {
			case .sunday:
				i.value.text = "S"
				i.value.textColor = weekendColor
			case .monday:
				i.value.text = "M"
				i.value.textColor = color
			case .tuesday:
				i.value.text = "T"
				i.value.textColor = color
			case .wednesday:
				i.value.text = "W"
				i.value.textColor = color
			case .thursday:
				i.value.text = "T"
				i.value.textColor = color
			case .friday:
				i.value.text = "F"
				i.value.textColor = color
			case .saturday:
				i.value.text = "S"
				i.value.textColor = weekendColor
			}
		}
		
    }
    
    @IBAction func unwindToMonthView(segue: UIStoryboardSegue) {
    }
	
	//MARK: - Function
	
	func scrollToSection(yearID: Int, monthID: Int, animated anim: Bool = false) {
		
		calendarViewController?.scrollToSection(yearID: yearID, monthID: monthID, animated: anim)
		
	}
	
	func setMonthName() {
		let date = TimeManagement.calculateFirstDayInMonth(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID)
		let name = TimeManagement.getMonthName(date)
		navigationBar.title = name
	}
	
	func scrollToSection(direction: ScrollDirection, animated anim: Bool = false) {
		
		let monthID = Selection.shared.currentMonthID - 1
		let yearID = Selection.shared.currentYearID
		
		switch direction {
		case .up:
			if monthID == 0 {
				if yearID == 0 {
					break
				} else {
					scrollToSection(yearID: yearID - 1, monthID: 11, animated: anim)
				}
			} else {
				scrollToSection(yearID: yearID, monthID: monthID - 1, animated: anim)
			}
		case .down:
			if monthID == 11 {
				if yearID == 3999 {
					break
				} else {
					scrollToSection(yearID: yearID + 1, monthID: 0, animated: anim)
				}
			} else {
				scrollToSection(yearID: yearID, monthID: monthID + 1, animated: anim)
			}
		}
		self.setMonthName()
	}
}

