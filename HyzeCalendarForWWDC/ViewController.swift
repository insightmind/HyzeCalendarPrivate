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
    var eventListViewController: ETViewController? = nil
	
	@IBOutlet weak var calendarView: UIView!
    @IBOutlet public weak var navigationBar: UINavigationItem!

	//Outlets of DaysOfWeek
    @IBOutlet weak var FirstDayOfWeek: UILabel!
    @IBOutlet weak var SecondDayOfWeek: UILabel!
    @IBOutlet weak var ThirdDayOfWeek: UILabel!
    @IBOutlet weak var FourthDayOfWeek: UILabel!
    @IBOutlet weak var FivthDayOfWeek: UILabel!
    @IBOutlet weak var SixthDayOfWeek: UILabel!
    @IBOutlet weak var SeventhDayOfWeek: UILabel!
	
	var daysOfWeek: [WeekDay: UILabel] = [:]

	@IBOutlet weak var daysOfWeekBackgroundView: UIView!
    @IBOutlet weak var eventListHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewToETListConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarViewAspectRatio: NSLayoutConstraint!
    
    var loadedViewControllerToBottomConstant: CGFloat?
    
    lazy var topChange: UIViewPropertyAnimator = {
        let cubicParameters = UICubicTimingParameters(animationCurve: .easeInOut)
        let springParameters = UISpringTimingParameters(dampingRatio: 0.6)
        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springParameters)
        animator.isInterruptible = true
        return animator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
		
		if EventManagement.shared.askForPermission() {
			calendarView.setNeedsDisplay()
		}
		
		self.calendarView.layer.masksToBounds = false
        if Settings.shared.isDarkMode{
            view.backgroundColor = Color.black
			daysOfWeekBackgroundView.backgroundColor = Color.black
			updateDaysOfWeek(color: Color.white, weekendColor: Color.green)
			navigationController?.navigationBar.barTintColor = Color.black
			navigationController?.navigationBar.titleTextAttributes![NSAttributedStringKey.foregroundColor] = Color.white
			navigationBar.backBarButtonItem?.tintColor = Color.black
			navigationBar.leftBarButtonItem?.tintColor = Color.white
			navigationBar.rightBarButtonItem?.tintColor = Color.white
        } else {
            view.backgroundColor = Color.white
			daysOfWeekBackgroundView.backgroundColor = Color.white
			updateDaysOfWeek(color: Color.black, weekendColor: Color.green)
			navigationController?.navigationBar.barTintColor = Color.white
			navigationController?.navigationBar.titleTextAttributes![NSAttributedStringKey.foregroundColor] = Color.black
			navigationBar.backBarButtonItem?.tintColor = Color.black
			navigationBar.leftBarButtonItem?.tintColor = Color.black
			navigationBar.rightBarButtonItem?.tintColor = Color.black
        }
        if darkModeTemp != Settings.shared.isDarkMode {
            darkModeTemp = Settings.shared.isDarkMode
        } else if isAMPMTemp != Settings.shared.isAMPM || Settings.shared.eventsChange == true {
            Settings.shared.eventsChange = false
        }
    }
	
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadedViewControllerToBottomConstant = calendarViewToETListConstraint.constant
		
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
        self.eventListHeightConstraint.constant = calendarViewToTopConstraint.constant + calendarView.frame.height
        self.view.layoutIfNeeded()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedETView" {
            if let viewController = segue.destination as? ETViewController {
                self.eventListViewController = viewController
                viewController.calendarViewController = self
            }
        }
    }
    
    @IBAction func unwindToMonthView(segue: UIStoryboardSegue) {
    }
}

