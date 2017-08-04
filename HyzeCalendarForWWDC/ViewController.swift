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
	let daysOfWeek: [UILabel]? = nil

	@IBOutlet weak var daysOfWeekBackgroundView: UIView!
	@IBOutlet weak var ETViewTopLayoutConstraintWithoutLastRow: NSLayoutConstraint!
	
    
    @IBAction func jumpToToday(_ sender: UIBarButtonItem) {
        let (yearID, monthID, _) = HSelection.todaysDayCellIndex
		HSelection.selectedDayCellIndex = HSelection.todaysDayCellIndex
		scrollToSection(yearID: yearID, monthID: monthID + 1, animated: true)
    }
    
    @IBAction func jumpToSelected(_ sender: UIBarButtonItem) {
        let (yearID, monthID, _ ) = HSelection.selectedDayCellIndex
        scrollToSection(yearID: yearID, monthID: monthID + 1, animated: true)
    }

    func updateSelectedDayIcon(){
        let (yearID, monthID, _ ) = HSelection.selectedDayCellIndex
        if yearID > HSelection.currentYearID || monthID > HSelection.currentMonthID - 1 {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down")
        } else if yearID < HSelection.currentYearID || monthID < HSelection.currentMonthID - 1 {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_up")
        } else {
            selectedDayButton.image = #imageLiteral(resourceName: "ic_keyboard_arrow_right")
        }
    }
    
    func reloadETView() {
        ETView.reloadView()
	}
	

    
    override func viewWillAppear(_ animated: Bool) {
		self.calendarView.layer.masksToBounds = false
        if darkMode{
            view.backgroundColor = calendarGrey
			daysOfWeekBackgroundView.backgroundColor = calendarGrey
			updateDaysOfWeek(color: calendarWhite, weekendColor: calendarGreen)
			navigationController?.navigationBar.barTintColor = calendarGrey
			navigationController?.navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = calendarWhite
			navigationBar.backBarButtonItem?.tintColor = calendarGrey
			navigationBar.leftBarButtonItem?.tintColor = calendarWhite
			navigationBar.rightBarButtonItem?.tintColor = calendarWhite
			toolbar.barTintColor = calendarGrey
			if toolbar.items != nil {
				for i in toolbar.items! {
					i.tintColor = calendarWhite
				}
			}
        } else {
            view.backgroundColor = calendarWhite
			daysOfWeekBackgroundView.backgroundColor = calendarWhite
			updateDaysOfWeek(color: calendarGrey, weekendColor: calendarGreen)
			navigationController?.navigationBar.barTintColor = calendarWhite
			navigationController?.navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = calendarGrey
			navigationBar.backBarButtonItem?.tintColor = calendarGrey
			navigationBar.leftBarButtonItem?.tintColor = calendarGrey
			navigationBar.rightBarButtonItem?.tintColor = calendarGrey
			toolbar.barTintColor = calendarWhite
			if toolbar.items != nil {
				for i in toolbar.items! {
					i.tintColor = calendarGrey
				}
			}
        }
        if darkModeTemp != darkMode {
            darkModeTemp = darkMode
        } else if isAMPMTemp != isAMPM || eventsChange == true {
            eventsChange = false
        }
        ETView.reloadView()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
		self.view.layoutIfNeeded()
		
        darkModeTemp = darkMode
        navigationBar.title = TimeManagement.getMonthName(Date())
		
		setTodaysProperties()
		
		for i in childViewControllers {
			if i.title == "CalendarView" {
				self.calendarViewController = i as? MainCollectionViewController
			}
		}
        
        let (selectedYearID, selectedMonthID, _) = HSelection.selectedDayCellIndex
		
		scrollToSection(yearID: selectedYearID, monthID: selectedMonthID - 1)
    }
	
	func setTodaysProperties() {
		let date = Date()
		HSelection.todaysYearID = TMCalendar.component(.year, from: date)
		HSelection.todaysMonthID = TMCalendar.component(.month, from: date)
		HSelection.todaysDayID = TMCalendar.component(.day, from: date)
	}

	func updateDaysOfWeek(color: UIColor, weekendColor: UIColor) {
		
		FirstDayOfWeek.textColor = color
		SecondDayOfWeek.textColor = color
		ThirdDayOfWeek.textColor = color
		FourthDayOfWeek.textColor = color
		FivthDayOfWeek.textColor = color
		SixthDayOfWeek.textColor = color
		SeventhDayOfWeek.textColor = color
		
		if isMondayFirstWeekday {
			FirstDayOfWeek.text = "M"
			SecondDayOfWeek.text = "T"
			ThirdDayOfWeek.text = "W"
			FourthDayOfWeek.text = "T"
			FivthDayOfWeek.text = "F"
			SixthDayOfWeek.text = "S"
			SeventhDayOfWeek.text = "S"
			SixthDayOfWeek.textColor = weekendColor
			SeventhDayOfWeek.textColor = weekendColor
		} else {
			FirstDayOfWeek.text = "S"
			SecondDayOfWeek.text = "M"
			ThirdDayOfWeek.text = "T"
			FourthDayOfWeek.text = "W"
			FivthDayOfWeek.text = "T"
			SixthDayOfWeek.text = "F"
			SeventhDayOfWeek.text = "S"
			FirstDayOfWeek.textColor = weekendColor
			SeventhDayOfWeek.textColor = weekendColor
		}
    }
    
    @IBAction func unwindToMonthView(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: Function
	
	func scrollToSection(yearID: Int, monthID: Int, animated anim: Bool = false) {
		
		calendarViewController?.scrollToSection(yearID: yearID, monthID: monthID, animated: anim)
		
	}
	
	func setMonthName() {
		let date = TimeManagement.calculateFirstDayInMonth(yearID: HSelection.currentYearID, monthID: HSelection.currentMonthID)
		let name = TimeManagement.getMonthName(date)
		navigationBar.title = name
	}
	
	func scrollToSection(direction: ScrollDirection, animated anim: Bool = false) {
		
		let monthID = HSelection.currentMonthID - 1
		let yearID = HSelection.currentYearID
		
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

