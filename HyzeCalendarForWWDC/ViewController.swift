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
		let date = Date()
		let year = TMCalendar.component(.year, from: date)
		let month = TMCalendar.component(.month, from: date)
		scrollToSection(yearID: year, monthID: month, animated: true)
    }
    
    @IBAction func jumpToSelected(_ sender: UIBarButtonItem) {
		
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
		self.view.layoutIfNeeded()
		
        darkModeTemp = darkMode
        navigationBar.title = TimeManagement.getMonthName(Date())
		
		
		let date = Date()
		let year = TMCalendar.component(.year, from: date)
		let month = TMCalendar.component(.month, from: date)
		
		
		for i in childViewControllers {
			if i.title == "CalendarView" {
				self.calendarViewController = i as? MainCollectionViewController
			}
		}
		
		scrollToSection(yearID: year, monthID: month)
		
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
	
	func scrollToSection(yearID: Int, monthID: Int, animated anim: Bool = false) {
		
		let indexPath = IndexPath(item: monthID, section: yearID)
		
		HSelection.currentMonthID = monthID
		HSelection.currentYearID = yearID
		
		calendarViewController?.collectionView!.scrollToItem(at: indexPath, at: .centeredVertically, animated: anim)
		
	}
	
	func scrollToSection(direction: ScrollDirection, animated anim: Bool = false) {
		
		let monthID = HSelection.currentMonthID
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
	}
}

