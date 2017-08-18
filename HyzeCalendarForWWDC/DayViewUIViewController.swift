//
//  DayViewUIViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DayViewUIVViewController: UIViewController {
	
	enum direction {
		case left
		case right
	}

    @IBOutlet weak var day: DayView!
	@IBOutlet weak var addButton: UIBarButtonItem!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var editButton: UIBarButtonItem!
	@IBOutlet var LeftSwipeRecognizer: UISwipeGestureRecognizer!
	@IBOutlet var RightSwipeRecognizer: UISwipeGestureRecognizer!
	@IBOutlet weak var eventTableView: ETView!
	
	@IBOutlet weak var dayViewNormal: NSLayoutConstraint!
	@IBOutlet weak var dayViewRight: NSLayoutConstraint!
	@IBOutlet weak var dayViewLeft: NSLayoutConstraint!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        viewIsDayView = true
        renDayView = day
        day.setUp()

		
        // Do any additional setup after loading the view.
		
		if isEEshowDetail {
			addButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: addButton.action)
		} else {
			addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: addButton.action)
		}
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewIsDayView = true
        renDayView = nil
    }
    
	func setDesign(animated: Bool = false) {
        if darkMode {
			toolbar.barTintColor = Color.grey
			editButton.tintColor = Color.white
            view.backgroundColor = Color.grey
			navigationController?.navigationBar.tintColor = Color.white
        } else {
			toolbar.barTintColor = Color.white
			editButton.tintColor = Color.grey
            view.backgroundColor = Color.white
			navigationController?.navigationBar.tintColor = Color.grey
        }
		
		UIView.animate(withDuration: animated ? 0.7 : 0, animations: {
			if HSelection.selectedIsToday!  {
				self.day.dayViewCenterButton.backgroundColor = Color.red
			} else if HSelection.selectedIsOnWeekend! {
				self.day.dayViewCenterButton.backgroundColor = Color.green
			} else {
				self.day.dayViewCenterButton.backgroundColor = Color.blue
			}
		})
		
		
    }
	//TODO: change if segues work again
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showEventEditor" {
			if let eventEditor = segue.destination as? EventEditorViewController {
				eventEditor.dayView = self
				if !isEEshowDetail {
					EManagement.eventInformation = EventEditorEventInformations()
				}
			}
			// TODO: When Storyboard Segue works again
//		} else if segue.identifier == "showDetail" {
//			if let eventEditor = segue.destination as? EventEditorViewController {
//				eventEditor.dayView = self
//				eventEditor.isOldEvent = true
//				eventEditor.oldEventIdentifier = day.selectedEventIdentifier
//			}
		}
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//PREVDAY
	@IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
		changeDay(.right)
	}
	
	//FUTDAY
	@IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
		changeDay(.left)
	}
	
	func changeDay(_ direction: direction) {
		
		let (year, month, dayIndexPath) = HSelection.selectedDayCellIndex
		
		guard let indexPath = dayIndexPath else {
			fatalError("There is no selected day")
		}
		
		let date = TimeManagement.convertToDate(yearID: year, monthID: month, dayID: indexPath.item)
		
		var nextDate: Date
		
		switch direction {
		case .right:
			guard let tempDate = TMCalendar.date(byAdding: .day, value: -1, to: date, options: .matchLast) else {
				fatalError("Could not find previous day")
			}
			nextDate = tempDate
			
		case .left:
			guard let tempDate = TMCalendar.date(byAdding: .day, value: 1, to: date, options: .matchLast) else {
				fatalError("Could not find future day")
			}
			nextDate = tempDate
		}
		
		let newYear = TMCalendar.component(.year, from: nextDate)
		let newMonth = TMCalendar.component(.month, from: nextDate)
		let newDayIndexPath = IndexPath(item: TMCalendar.component(.day, from: nextDate), section: 0)
		
		HSelection.selectedDayCellIndex = (newYear, newMonth, newDayIndexPath)
		
		let weekDay = TMCalendar.component(.weekday, from: nextDate)
		
		if weekDay == 1 || weekDay == 7 {
			HSelection.selectedIsOnWeekend = true
		} else {
			HSelection.selectedIsOnWeekend = false
		}
		
		HSelection.selectedIsToday = TimeManagement.isToday(yearID: newYear, monthID: newMonth, dayID: newDayIndexPath.item)
		
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
			NSLayoutConstraint.deactivate([self.dayViewNormal])
			switch direction {
			case .right:
				NSLayoutConstraint.activate([self.dayViewRight])
			case .left:
				NSLayoutConstraint.activate([self.dayViewLeft])
			}
			self.view.layoutIfNeeded()
		}) { (_) in
			
			switch direction {
			case .right:
				NSLayoutConstraint.activate([self.dayViewLeft])
				NSLayoutConstraint.deactivate([self.dayViewRight])
			case .left:
				NSLayoutConstraint.deactivate([self.dayViewLeft])
				NSLayoutConstraint.activate([self.dayViewRight])
			}
			self.view.layoutIfNeeded()
			
			self.day.reloadData()
			self.setDesign(animated: false)
			self.eventTableView.reloadView()
			
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
				NSLayoutConstraint.activate([self.dayViewNormal])
				switch direction {
				case .right:
					NSLayoutConstraint.deactivate([self.dayViewLeft])
				case .left:
					NSLayoutConstraint.deactivate([self.dayViewRight])
				}
				self.view.layoutIfNeeded()
			}, completion: nil)
			
		}
		
		needsDesignUpdate = true
	}
	
	/*
    // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            
        
    }
     */
}
