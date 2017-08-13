//
//  EventEditorViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 3/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

enum DateSpecification {
	case startDate
	case endDate
}

class EventEditorEventInformations {
	var title: String = "Untitled Event"
	var isAllDay: Bool = false
	var startDate: Date = Date()
	var endDate: Date = Date().addingTimeInterval(1800)
	var color: UIColor = Theme.calendarWhite
	var notes: String? = nil
	
	//NOT IMPORTANT FOR EVENTCREATION
	var dateSelectionPopoverState: DateSpecification = .startDate
}

class EventEditorViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    /// Variable to check if Event should be added to the Calendar
    var addEvent: Bool = false
	var tableViewController: EventEditorTableViewController?
	var eventInformations = EventEditorEventInformations()
	var dayView: DayViewUIVViewController? = nil
	
    // MARK: - Outlets
    //All the visual Elements in the ViewController
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var blurEffectNavbarView: UIVisualEffectView!
	
	@IBOutlet weak var tableView: UIView!
	@IBOutlet weak var newEventTextField: UITextField!
	
	// MARK: - Actions
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		if newEventTextField.text == "" {
			eventInformations.title = "Untitled Event"
		} else {
			eventInformations.title = newEventTextField.text!
		}
		
		let notes = String(describing: self.tableViewController?.notes?.text)
		if notes != "Your Notes..." || notes != "" {
			eventInformations.notes = notes
		} else {
			eventInformations.notes = nil
		}
		
		if informationMode {
			print("added Event")
		}
		EManagement.addEvent(eventInformations)
		
		// TODO: - Get ViewController to reload dayView
//		if let presenter = presentingViewController as? UINavigationController {
//			print(String(describing: presenter))
//			if let dayViewController = presenter.visibleViewController as? DayViewUIVViewController {
//				dayViewController.day.reloadData()
//			}
//		}
		
		self.dismiss(animated: true, completion: {
			self.dayView?.day.reloadData()
		})
	}
	
	// MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
		hideKeyboardWhenTappedAround()
		self.newEventTextField.delegate = self
		self.newEventTextField.layer.masksToBounds = false
        // Do any additional setup after loading the view.
		
		if darkMode {
			newEventTextField.textColor = Theme.calendarWhite
			let color = Theme.calendarWhite.withAlphaComponent(0.5)
			let str = NSAttributedString(string: "Untitled Event", attributes: [NSAttributedStringKey.foregroundColor : color])
			newEventTextField.attributedPlaceholder = str
			blurEffectView.effect = UIBlurEffect(style: .dark)
			blurEffectNavbarView.effect = blurEffectView.effect
		} else {
			blurEffectView.effect = UIBlurEffect(style: .light)
			blurEffectNavbarView.effect = blurEffectView.effect
			let color = Theme.calendarGrey.withAlphaComponent(0.5)
			let str = NSAttributedString(string: "Untitled Event", attributes: [NSAttributedStringKey.foregroundColor : color])
			newEventTextField.attributedPlaceholder = str
			newEventTextField.textColor = Theme.calendarGrey
		}
		
		setEventInformationDates()
    }
	
	func setEventInformationDates() {
		let (year, month, indexPath) = HSelection.selectedDayCellIndex
		guard let day = indexPath else {
			return
		}
		let date = TimeManagement.convertToDate(yearID: year, monthID: month, dayID: day.item)
		let now = TMCalendar.components(in: TimeZone.autoupdatingCurrent, from: Date())
		
		eventInformations.startDate = TMCalendar.date(bySettingHour: now.hour!, minute: now.minute!, second: now.second!, of: date, options: .matchFirst)!
		eventInformations.endDate = eventInformations.startDate.addingTimeInterval(1800)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "embed") {
			tableViewController = (segue.destination as! EventEditorTableViewController)
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
	
	func textFieldShouldReturn(_ newEventTextField: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	
	class func getEventsInformations() -> EventEditorEventInformations {
		if let topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				guard let viewController = presentedViewController as? EventEditorViewController else {
					fatalError()
				}
				return viewController.eventInformations
			}
		}
		return EventEditorEventInformations()
	}
	
	func reloadTableViewCells(_ cellType: EventEditorCellType, onlyInformations: Bool){
	
	guard let checkedTableViewController = tableViewController else {
		fatalError()
	}
	checkedTableViewController.reloadCell(cellType, onlyInformations: onlyInformations)
	}
}
