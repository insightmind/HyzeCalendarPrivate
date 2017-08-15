//
//  EventEditorViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 3/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class EventEditorViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variables
    /// Variable to check if Event should be added to the Calendar
    var addEvent: Bool = false
	var tableViewController: EventEditorTableViewController?
	var eventInformations = EventEditorEventInformations()
	var dayView: DayViewUIVViewController? = nil
	var isOldEvent: Bool = false
	var oldEventIdentifier: String? = nil
	
    // MARK: - Outlets
    //All the visual Elements in the ViewController
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var blurEffectNavbarView: UIVisualEffectView!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBOutlet weak var tableView: UIView!
	@IBOutlet weak var newEventTextField: UITextField!
	
	// MARK: - Actions
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		saveTitle()
	}
	
	fileprivate func saveTitle() {
		if newEventTextField.text == "" {
			let alert = UIAlertController(title: "Your event has no title!", message: "Are you sure you want to save this Event as \"Untitled Event\" ", preferredStyle: .alert)
			let agree = UIAlertAction(title: "Save", style: .default, handler: { action in
				self.eventInformations.title = "Untitled Event"
				self.saveToEventInformations()
			})
			let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
				return
			})
			alert.addAction(cancel)
			alert.addAction(agree)
			present(alert, animated: true, completion: nil)
		} else {
			eventInformations.title = newEventTextField.text!
			saveToEventInformations()
		}
	}
	
	func saveToEventInformations() {
		//Notes are saved in NotesTableViewCell
		
		if informationMode {
			print("added Event")
		}
		EManagement.addEvent(eventInformations)
		
		self.dismiss(animated: true, completion: {
			self.dayView?.day.reloadData()
			self.dayView?.eventTableView.reloadView()
		})
	}
	
	// MARK: - Functions
	fileprivate func generalViewDidLoad() {
		hideKeyboardWhenTappedAround()
		self.newEventTextField.delegate = self
		self.newEventTextField.layer.masksToBounds = false
		if darkMode {
			newEventTextField.textColor = Color.white
			blurEffectView.effect = UIBlurEffect(style: .dark)
			blurEffectNavbarView.effect = blurEffectView.effect
		} else {
			blurEffectView.effect = UIBlurEffect(style: .light)
			blurEffectNavbarView.effect = blurEffectView.effect
			newEventTextField.textColor = Color.grey
		}
		setEventInformationDates()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
        // Do any additional setup after loading the view.
		
		if isOldEvent {
			showDetailViewDidLoad()
		} else {
			createViewDidLoad()
		}
		generalViewDidLoad()
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
