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
		eventInformations.startDate = dates[.startDate]!
		eventInformations.endDate = dates[.endDate]!
		if let presenter = presentingViewController as? EventEditorViewController {
			presenter.reloadTableViewCells(.dateSelection, onlyInformations: true)
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func setStartsPage(_ sender: UIButton) {
		didSelect(forState: .startDate, animated: true)
	}
	@IBAction func setEndsPage(_ sender: UIButton) {
		didSelect(forState: .endDate, animated: true)
	}
	
	@IBAction func changeDate(_ sender: UIDatePicker) {
		dates[currentState] = sender.date
		updateYearLabel(0)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.eventInformations = EventEditorViewController.getEventsInformations()
		
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
	
	func didSelect(forState: DateSpecification, animated isAnimated: Bool) {
		let duration = isAnimated ? 0.3 : 0
		currentState = forState
		switch forState {
		case .startDate:
			UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
				self.startsButton.backgroundColor = Theme.calendarLightBlue
				self.endsButton.backgroundColor = Theme.calendarBlue
			}, completion: nil)
		case .endDate:
			UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
				self.endsButton.backgroundColor = Theme.calendarLightBlue
				self.startsButton.backgroundColor = Theme.calendarBlue
			}, completion: nil)
		}
		updateYearLabel(duration)
		datePicker.setDate(dates[currentState]!, animated: isAnimated)
	}
	
	func updateYearLabel(_ duration: Double) {
		UIView.animate(withDuration: duration / 2, delay: 0, options: .curveEaseInOut, animations: {
			self.yearLabel.textColor = UIColor.clear
		}, completion: nil)
		yearLabel.text = String(TMCalendar.component(.year, from: dates[currentState]!))
		UIView.animate(withDuration: duration / 2, delay: 0, options: .curveEaseInOut, animations: {
			self.yearLabel.textColor = Theme.calendarWhite
		}, completion: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
