//
//  SetTimePopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 7/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SetTimePopoverViewController: UIViewController {
	
	var dates: [DateSpecification: Date] = [:]
	var eventInformations: EventEditorEventInformations!
	var currentState: DateSpecification! = .startDate

	@IBOutlet var popover: UIView!
	@IBOutlet weak var blurLayer: UIVisualEffectView!
	@IBOutlet var startsButton: UIButton!
	@IBOutlet var endsButton: UIButton!
	@IBOutlet var yearLabel: UILabel!
	
	@IBOutlet weak var datePicker: UIDatePicker!
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		
		if TMCalendar.compare(dates[.startDate]!, to: dates[.endDate]!, toUnitGranularity: .minute) == ComparisonResult.orderedDescending {
			self.yearLabel.text = "Starts must be before Ends!"
			UIView.animate(withDuration: 0.7, animations: {
				self.startsButton.backgroundColor = Color.red
				self.endsButton.backgroundColor = Color.red
			}, completion: { (_) in
				self.didSelect(forState: self.currentState, animated: true, duration: 0.7)
			})
			
		} else {
			eventInformations.startDate = dates[.startDate]!
			eventInformations.endDate = dates[.endDate]!
			eventInformations.eventEditorTableViewController?.reloadCell(.dateSelection, onlyInformations: true)
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func setStartsPage(_ sender: UIButton) {
		didSelect(forState: .startDate, animated: true)
	}
	@IBAction func setEndsPage(_ sender: UIButton) {
		didSelect(forState: .endDate, animated: true)
	}
	
	@IBAction func changeDate(_ sender: UIDatePicker) {
		dates[currentState] = sender.date
		yearLabel.text = String(TMCalendar.component(.year, from: dates[currentState]!))
		if currentState == .startDate {
			if TMCalendar.compare(dates[.startDate]!, to: dates[.endDate]!, toUnitGranularity: .minute) == .orderedDescending {
				dates[.endDate] = dates[.startDate]?.addingTimeInterval(1800)
			}
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.eventInformations = EManagement.eventInformation
		
		dates = [.startDate: eventInformations.startDate,
		         .endDate: eventInformations.endDate]
		
		currentState = eventInformations.dateSelectionPopoverState

		datePicker.date = dates[currentState]!
		
		if isAMPM {
			datePicker.locale = Locale(identifier: "en_US")
		} else {
			datePicker.locale = Locale(identifier: "de_DE")
		}
		
		didSelect(forState: currentState, animated: false)
		
		popover.layer.cornerRadius = 20
		popover.layer.masksToBounds = true

        // Do any additional setup after loading the view.
		
    }
	
	func didSelect(forState: DateSpecification, animated isAnimated: Bool, duration: TimeInterval = 0.3) {
		let time = isAnimated ? duration : 0
		currentState = forState
		switch forState {
		case .startDate:
			UIView.animate(withDuration: time, delay: 0, options: .curveEaseInOut, animations: {
				self.startsButton.backgroundColor = Color.lightBlue
				self.endsButton.backgroundColor = Color.blue
			}, completion: { (_) in
				self.yearLabel.text = String(TMCalendar.component(.year, from: self.dates[self.currentState]!))
			})
		case .endDate:
			UIView.animate(withDuration: time, delay: 0, options: .curveEaseInOut, animations: {
				self.endsButton.backgroundColor = Color.lightBlue
				self.startsButton.backgroundColor = Color.blue
			}, completion: { (_) in
				self.yearLabel.text = String(TMCalendar.component(.year, from: self.dates[self.currentState]!))
			})
		}
		
		datePicker.setDate(dates[currentState]!, animated: isAnimated)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
