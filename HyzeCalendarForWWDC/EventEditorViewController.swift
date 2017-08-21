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
	var eventInformations = EManagement.eventInformation
	var dayView: DayViewUIVViewController? = nil
	
    // MARK: - Outlets
    //All the visual Elements in the ViewController
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var blurEffectNavbarView: UIVisualEffectView!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBOutlet weak var tableView: UIView!
	@IBOutlet weak var titleTextField: UITextField!
	
	// MARK: - Actions
	@IBAction func cancel(_ sender: UIButton) {
		
		if eventInformations.state == .create && eventInformations.eventIdentifier != nil {
			let correctInformationsForEvent = EManagement.convertToEventEditorEventInformations(eventIdentifier: eventInformations.eventIdentifier!, state: .showDetail)
			eventInformations.setEventInformations(correctInformationsForEvent!)
			self.showDetailSetUpSaveButton()
			self.titleTextField.text = self.eventInformations.title
			self.titleTextField.isUserInteractionEnabled = false
			self.tableViewController?.updateCellsArray()
			self.tableViewController?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
		} else {
			self.dismiss(animated: true, completion: nil)
		}
		
	}
	
	fileprivate func reloadAllCells() {
		reloadTableViewCells(.dateSelection, onlyInformations: true)
		reloadTableViewCells(.calendar, onlyInformations: true)
		reloadTableViewCells(.notes, onlyInformations: true)
	}
	
	@IBAction func save(_ sender: UIButton) {
		if eventInformations.state == .create {
			saveTitle()
		} else {
			eventInformations.state = .create
			titleTextField.isUserInteractionEnabled = true
			createSetUpSaveButton()
			self.tableViewController?.updateCellsArray()
			self.tableViewController?.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
			reloadAllCells()
		}
		
	}
	
	fileprivate func saveTitle() {
		if titleTextField.text == "" {
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
			eventInformations.title = titleTextField.text!
			saveToEventInformations()
		}
	}
	
	func saveToEventInformations() {
		//Notes are saved in NotesTableViewCell
		
		if informationMode {
			print("added Event")
		}
		
		if eventInformations.eventIdentifier != nil {
			EManagement.updateEvent(eventInformations)
		} else {
			EManagement.addEvent(eventInformations)
		}
		EManagement.eventInformation.state = .showDetail
		endEditingWithReload()
	}
	
	func endEditingWithReload() {
		self.dismiss(animated: true, completion: {
			self.dayView?.day.reloadData()
			self.dayView?.eventTableView.reloadView()
		})
	}
	
	// MARK: - Functions
	fileprivate func generalViewDidLoad() {
		hideKeyboardWhenTappedAround()
		self.titleTextField.delegate = self
		self.titleTextField.layer.masksToBounds = false
		if darkMode {
			titleTextField.textColor = Color.white
			blurEffectView.effect = UIBlurEffect(style: .dark)
			blurEffectNavbarView.effect = blurEffectView.effect
		} else {
			blurEffectView.effect = UIBlurEffect(style: .light)
			blurEffectNavbarView.effect = blurEffectView.effect
			titleTextField.textColor = Color.grey
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		eventInformations = EManagement.eventInformation
		eventInformations.eventEditor = self
		setDates()
		switch eventInformations.state {
		case .showDetail:
			showDetailViewDidLoad()
		case .create:
			createViewDidLoad()
		}
		generalViewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "embed") {
			if let checkedViewController = segue.destination as? EventEditorTableViewController {
				self.tableViewController = checkedViewController
			}
		}
    }
	
	func setDates(by duration: TimeInterval = 1800) {
		if eventInformations.eventIdentifier == nil {
			eventInformations.startDate = Date()
			eventInformations.endDate = eventInformations.startDate.addingTimeInterval(duration)
		}
	}
	
	func textFieldShouldReturn(_ newEventTextField: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	
	func reloadTableViewCells(_ cellType: EventEditorCellType, onlyInformations: Bool){
	
		guard let checkedTableViewController = tableViewController else {
			fatalError()
		}
		checkedTableViewController.reloadCell(cellType, onlyInformations: onlyInformations)
	}
}
