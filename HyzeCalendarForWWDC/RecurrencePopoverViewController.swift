//
//  RecurrencePopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/27/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class RecurrencePopoverViewController: UIViewController {
	
	var eventInformations = EventManagement.shared.eventInformation
	
	var selectedFrequency: EKRecurrenceFrequency? = nil
	
	var tableView: RecurrenceTableViewController? = nil

	@IBOutlet weak var popover: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dailyButton: UIButton!
	@IBOutlet weak var dailyButtonView: UIView!
	@IBOutlet weak var dailyCircleButton: UIButton!
	@IBOutlet weak var dailyCircleButtonView: UIView!
	@IBOutlet weak var weeklyButton: UIButton!
	@IBOutlet weak var weeklyButtonView: UIView!
	@IBOutlet weak var weeklyCircleButton: UIButton!
	@IBOutlet weak var weeklyCircleButtonView: UIView!
	@IBOutlet weak var monthlyButton: UIButton!
	@IBOutlet weak var monthlyButtonView: UIView!
	@IBOutlet weak var monthlyCircleButton: UIButton!
	@IBOutlet weak var monthlyCircleButtonView: UIView!
	@IBOutlet weak var yearlyButton: UIButton!
	@IBOutlet weak var yearlyButtonView: UIView!
	@IBOutlet weak var yearlyCircleButton: UIButton!
	@IBOutlet weak var yearlyCircleButtonView: UIView!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var blurEffectView: UIVisualEffectView!
	@IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var containerView: UIView!
	
	@IBOutlet var popoverTopConstraint: NSLayoutConstraint!
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func save(_ sender: UIButton) {
		if saveRecurrenceRule() {
			self.dismiss(animated: true, completion: {
				guard let viewController = self.eventInformations.eventEditorTableViewController else { return }
				viewController.reloadCell(.recurrence, onlyInformations: true)
			})
		} else {
			let alert = UIAlertController(title: "Could not save rule!", message: nil, preferredStyle: .alert)
			let ok = UIAlertAction(title: "Continue", style: .destructive, handler: { (_) in
				self.dismiss(animated: true, completion: nil)
			})
			alert.addAction(ok)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func setContainerViewHeight() {
		if selectedFrequency != nil {
			mainViewHeightConstraint.constant = 56
			tableView?.tableView.isScrollEnabled = true
		} else {
			mainViewHeightConstraint.constant = 224
			tableView?.tableView.isScrollEnabled = false
		}
	}
	
	func frequencySelectionReset() {
		guard let table = tableView else { return }
		selectedFrequency = nil
		table.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
		setContainerViewHeight()
		dailyButtonView.isHidden = false
		weeklyButtonView.isHidden = false
		monthlyButtonView.isHidden = false
		yearlyButtonView.isHidden = false
		let image = #imageLiteral(resourceName: "ic_done").withRenderingMode(.alwaysTemplate)
		dailyCircleButton.setImage(image, for: .normal)
		weeklyCircleButton.setImage(image, for: .normal)
		monthlyCircleButton.setImage(image, for: .normal)
		yearlyCircleButton.setImage(image, for: .normal)
		UIView.animate(withDuration: 0.5) {
			self.view.layoutIfNeeded()
		}
		
	}
	
	@IBAction func selectDaily(_ sender: UIButton) {
		if eventInformations.state == .showDetail { return }
		if selectedFrequency != nil {
			frequencySelectionReset()
		} else {
			didSelect(.daily)
		}
	}
	@IBAction func selectWeekly(_ sender: UIButton) {
		if eventInformations.state == .showDetail { return }
		if selectedFrequency != nil {
			frequencySelectionReset()
		} else {
			didSelect(.weekly)
		}
	}
	@IBAction func selectMonthly(_ sender: UIButton) {
		if eventInformations.state == .showDetail { return }
		if selectedFrequency != nil {
			frequencySelectionReset()
		} else {
			didSelect(.monthly)
		}
	}
	@IBAction func selectYearly(_ sender: UIButton) {
		if eventInformations.state == .showDetail { return }
		if selectedFrequency != nil {
			frequencySelectionReset()
		} else {
			didSelect(.yearly)
		}
	}
	
	func didSelect(_ type: EKRecurrenceFrequency) {
		
		selectedFrequency = type
		guard let table = tableView else { return }
		table.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
		table.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
		setContainerViewHeight()
		let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
		
		switch type {
		case .daily:
			weeklyButtonView.isHidden = true
			monthlyButtonView.isHidden = true
			yearlyButtonView.isHidden = true
			dailyCircleButton.setImage(image, for: .normal)
		case .weekly:
			dailyButtonView.isHidden = true
			monthlyButtonView.isHidden = true
			yearlyButtonView.isHidden = true
			weeklyCircleButton.setImage(image, for: .normal)
		case .monthly:
			weeklyButtonView.isHidden = true
			dailyButtonView.isHidden = true
			yearlyButtonView.isHidden = true
			monthlyCircleButton.setImage(image, for: .normal)
		case .yearly:
			weeklyButtonView.isHidden = true
			monthlyButtonView.isHidden = true
			dailyButtonView.isHidden = true
			yearlyCircleButton.setImage(image, for: .normal)
		}
		UIView.animate(withDuration: 0.5) {
			self.view.layoutIfNeeded()
		}
		table.tableView.reloadData()
	}
	
	func setUpButton(_ view: UIView, button: UIButton, image: UIImage) {
		view.layer.cornerRadius = view.bounds.width / 2
		view.backgroundColor = Color.red
		button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
		button.tintColor = Color.white
		
		view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.bounds.width / 2).cgPath
		view.layer.shadowColor = view.backgroundColor?.cgColor
		view.layer.shadowRadius = 5
		view.layer.shadowOffset = CGSize(width: 1, height: 3)
		view.layer.shadowOpacity = 0.8
	}
	
	override func viewDidLayoutSubviews() {
		setContainerViewHeight()
		super.viewDidLayoutSubviews()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		popover.layer.cornerRadius = 20
		popover.layer.masksToBounds = true
		
		if Settings.shared.isDarkMode {
			blurEffectView.effect = UIBlurEffect(style: .dark)
			dailyButton.tintColor = Color.white
			weeklyButton.tintColor = Color.white
			monthlyButton.tintColor = Color.white
			yearlyButton.tintColor = Color.white
			popover.backgroundColor = Color.grey.withAlphaComponent(0.3)
		} else {
			blurEffectView.effect = UIBlurEffect(style: .light)
			dailyButton.tintColor = Color.grey
			weeklyButton.tintColor = Color.grey
			monthlyButton.tintColor = Color.grey
			yearlyButton.tintColor = Color.grey
			popover.backgroundColor = Color.white.withAlphaComponent(0.3)
		}
		
		setUpButton(dailyCircleButtonView, button: dailyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
		setUpButton(weeklyCircleButtonView, button: weeklyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
		setUpButton(monthlyCircleButtonView, button: monthlyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
		setUpButton(yearlyCircleButtonView, button: yearlyCircleButton, image: #imageLiteral(resourceName: "ic_done"))
		
		setUpInformations()
		
		if eventInformations.state == .showDetail {
			dailyCircleButtonView.isHidden = true
			weeklyCircleButtonView.isHidden = true
			monthlyCircleButtonView.isHidden = true
			yearlyCircleButtonView.isHidden = true
			dailyButton.isUserInteractionEnabled = false
			weeklyButton.isUserInteractionEnabled = false
			monthlyButton.isUserInteractionEnabled = false
			yearlyButton.isUserInteractionEnabled = false
			saveButton.isHidden = true
		}
		
    }
	
	func setUpInformations() {
		guard let rule = eventInformations.recurrenceRule else {
			frequencySelectionReset()
			return
		}
		if EventManagement.shared.analyseRule(eventInformations) == .custom {
			didSelect(rule.frequency)
		} else {
			frequencySelectionReset()
		}
		
	}
	
	func saveRecurrenceRule() -> Bool {
		
		guard let table = tableView else { return false }
		guard let frequency = selectedFrequency else {
			return true
		}
		
		guard let intervalCell = table.timeInterval else { return false }
		let interval = intervalCell.pickerView.selectedRow(inComponent: 0) + 1
		
		let end = getRecurrenceEnd(table)
		
		var daysOfTheWeek: [EKRecurrenceDayOfWeek]? = nil
		var daysOfTheMonth: [NSNumber]? = nil
		var monthsOfTheYear: [NSNumber]? = nil
		var setPositions: [NSNumber]? = nil
		
		switch frequency {
		case .weekly:
			daysOfTheWeek = getDaysOfTheWeek(table)
		case .monthly:
			if let daysOfTheMonthCell = table.daysOfMonth {
				if daysOfTheMonthCell.selectedType == .each {
					daysOfTheMonth = getDaysOfTheMonth(table)
				} else if daysOfTheMonthCell.selectedType == .on {
					guard let picker = daysOfTheMonthCell.pickerView else { return false }
					let type = getSelectedType(picker)
					guard let (dOTW, positions) = getDay(picker, type: type) else { return false }
					daysOfTheWeek = dOTW
					setPositions = positions
				}
			}
		case .yearly:
			monthsOfTheYear = getMonthsOfTheYear(table)
			if let daysOfTheMonthPickerCell = table.daysOfMonthPicker {
				guard let picker = daysOfTheMonthPickerCell.pickerView else { return false }
				let type = getSelectedType(picker)
				guard let (dOTW, positions) = getDay(picker, type: type) else { return false }
				daysOfTheWeek = dOTW
				setPositions = positions
			}
		default:
			break
		}
		
		eventInformations.recurrenceRule = EKRecurrenceRule(recurrenceWith: frequency, interval: interval, daysOfTheWeek: daysOfTheWeek, daysOfTheMonth: daysOfTheMonth, monthsOfTheYear: monthsOfTheYear, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: setPositions, end: end)

		return true
		
	}
	
	func getSelectedType(_ pickerView: UIPickerView) -> RecurrenceDaysOfMonthPickerViewSelectedType {
		let type = pickerView.selectedRow(inComponent: 1)
		switch type {
		case 0...6:
			return .specificWeekDay
		case 7:
			return .day
		case 8:
			return .weekDay
		case 9:
			return .weekendDay
		default:
			fatalError()
		}
	}
	
	func getDay(_ picker: UIPickerView, type: RecurrenceDaysOfMonthPickerViewSelectedType) -> ([EKRecurrenceDayOfWeek], [NSNumber]?)? {
		let which = picker.selectedRow(inComponent: 0)
		
		var dayOfWeek: [EKRecurrenceDayOfWeek] = []
		var range: CountableClosedRange<Int> = 0...0
		var shouldLoop: Bool = true
		switch type {
		case .specificWeekDay:
			let day = picker.selectedRow(inComponent: 1) + 1
			range = day...day
		case .day:
			range = 1...7
		case .weekDay:
			range = 2...6
		case .weekendDay:
			shouldLoop = false
			if let weekDay = EKWeekday(rawValue: 1 ) {
				let day = EKRecurrenceDayOfWeek(weekDay)
				dayOfWeek.append(day)
			}
			if let weekDay = EKWeekday(rawValue: 7 ) {
				let day = EKRecurrenceDayOfWeek(weekDay)
				dayOfWeek.append(day)
			}
		}
		if shouldLoop {
			for index in range {
				if let weekDay = EKWeekday(rawValue: index ) {
					let day = EKRecurrenceDayOfWeek(weekDay)
					dayOfWeek.append(day)
				}
			}
		}
		var position: NSNumber = 0
		switch which {
		case 0...4:
			position = NSNumber(integerLiteral: which + 1)
		case 5:
			position = -1
		default:
			return nil
		}
		return (dayOfWeek,[position])
	}
	
	func getMonthsOfTheYear(_ table: RecurrenceTableViewController) -> [NSNumber]? {
		if let monthsOfTheYearCell = table.monthsOfYear {
			return monthsOfTheYearCell.getSelectedMonths()
		}
		return nil
	}
	
	func getDaysOfTheMonth(_ table: RecurrenceTableViewController) -> [NSNumber]? {
		var numbers: [NSNumber] = []
		if let daysOfTheMonthCell = table.daysOfMonth {
			if daysOfTheMonthCell.selectedType != .each { return nil }
			guard let indexPaths = daysOfTheMonthCell.collectionView.indexPathsForSelectedItems else { return nil }
			for index in indexPaths {
				let number = NSNumber(integerLiteral: index.item + 1)
				numbers.append(number)
			}
		}
		return numbers.isEmpty ? nil : numbers
	}
	
	func getDaysOfTheWeek(_ table: RecurrenceTableViewController) -> [EKRecurrenceDayOfWeek]? {
		var weekdays: [EKRecurrenceDayOfWeek] = []
		if let daysOfTheWeekCell = table.weekDay {
			for day in daysOfTheWeekCell.selectedDays {
				weekdays.append(EKRecurrenceDayOfWeek(day))
			}
		}
		return weekdays.isEmpty ? nil : weekdays
	}
	
	func getRecurrenceEnd(_ table: RecurrenceTableViewController) -> EKRecurrenceEnd? {
		if let endCell = table.endDate {
			switch endCell.selectedType {
			case .date:
				return EKRecurrenceEnd(end: endCell.datePicker.date)
			case .occurrence:
				let count = endCell.picker.selectedRow(inComponent: 0) + 2
				return EKRecurrenceEnd(occurrenceCount: count)
			default:
				break
			}
		}
		return nil
	}
	
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "embed" {
			if let viewController = segue.destination as? RecurrenceTableViewController {
				self.tableView = viewController
				viewController.popover = self
			}
		}
    }
	
	
}


