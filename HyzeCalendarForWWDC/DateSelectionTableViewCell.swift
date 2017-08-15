//
//  DateSelectionTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DateSelectionTableViewCell: UITableViewCell {

	// - MARK: Variables
	
	var eventInformations: EventEditorEventInformations!
	
	var startDateGestureRecognizer: UITapGestureRecognizer!
	var endDateGestureRecognizer: UITapGestureRecognizer!
	
	var previousIsAllDaySwitchFontStyle: UIFont!
	
	var isAllDayConstraints: [NSLayoutConstraint]!
	var isNotAllDayConstraints: [NSLayoutConstraint]!
	
	
	// - MARK: Outlets
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var startDateView: UIButton!
	@IBOutlet weak var endDateView: UIButton!
	@IBOutlet weak var allDaySwitch: UIButton!
	
	// MARK: - DateLabels
	@IBOutlet weak var startDateHourLabel: UILabel!
	@IBOutlet weak var startDateDayLabel: UILabel!
	@IBOutlet weak var endDateHourLabel: UILabel!
	@IBOutlet weak var endDateDayLabel: UILabel!
	

	// - MARK: isAllDayConstraints
	@IBOutlet weak var isAllDayLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var isAllDayBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var isAllDayTrailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var isAllDayTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var isAllDayHeightConstraint: NSLayoutConstraint!
	
	// - MARK: isNotAllDayConstraints
	@IBOutlet weak var isNotAllDayBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var isNotAllDayTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var isNotAllDayAspectConstraint: NSLayoutConstraint!

	// - MARK: Actions
	fileprivate func toggleIsAllDaySwitchFont() {
		let prevFont = self.allDaySwitch.titleLabel?.font
		self.allDaySwitch.titleLabel?.font = self.previousIsAllDaySwitchFontStyle
		self.previousIsAllDaySwitchFontStyle = prevFont
	}
	
	fileprivate func setAllDaySwitchDesign() {
		if self.eventInformations.isAllDay {
			NSLayoutConstraint.deactivate(self.isNotAllDayConstraints)
			NSLayoutConstraint.activate(self.isAllDayConstraints)
			self.allDaySwitch.backgroundColor = Color.green
		} else {
			NSLayoutConstraint.deactivate(self.isAllDayConstraints)
			NSLayoutConstraint.activate(self.isNotAllDayConstraints)
			self.allDaySwitch.backgroundColor = Color.red
		}
		
		//TODO: not working
		if eventInformations.state == .showDetail {
			if !eventInformations.isAllDay {
				self.allDaySwitch.backgroundColor = UIColor.clear
				self.allDaySwitch.tintColor = UIColor.clear
				self.allDaySwitch.isEnabled = false
			}
		}
		
		toggleIsAllDaySwitchFont()
		self.layoutIfNeeded()
	}
	
	@IBAction func toggleAllDay(_ sender: UIButton) {
		if eventInformations.state == .showDetail {
			return
		}
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
			self.eventInformations.isAllDay = !self.eventInformations.isAllDay
			self.setAllDaySwitchDesign()
			self.allDaySwitch.layer.cornerRadius = self.allDaySwitch.frame.height / 2
		}, completion: nil)
	}

	fileprivate func presentDateSelectionPopover() {
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			let storyBoard = UIStoryboard(name: "DateSelection", bundle: nil)
			guard let startDateViewController = storyBoard.instantiateInitialViewController() else {
				return
			}
			startDateViewController.modalTransitionStyle = .coverVertical
			topController.present(startDateViewController, animated: true, completion: nil)
		}
	}
	
	@IBAction func startButtonTap(_ sender: UIButton) {
		if eventInformations.state == .showDetail {
			return
		}
		eventInformations.dateSelectionPopoverState = .startDate
		presentDateSelectionPopover()
	}
	
	@IBAction func endTap(_ sender: UIButton) {
		if eventInformations.state == .showDetail {
			return
		}
		eventInformations.dateSelectionPopoverState = .endDate
		presentDateSelectionPopover()
	}
	
	
	func setUpDateLabel(animated: Bool) {
		let hourFormatter = DateFormatter()
		
		if isAMPM {
			hourFormatter.locale = Locale(identifier:  "en_US")
		} else {
			hourFormatter.locale = Locale(identifier:  "de_DE")
		}
		
		hourFormatter.timeStyle = .short
		hourFormatter.dateStyle = .none
		
		let duration = animated ? 0.3 : 0
		UIView.animate(withDuration: duration / 2, delay: 0, options: .curveEaseInOut, animations: {
			self.startDateHourLabel.textColor = UIColor.clear
			self.startDateDayLabel.textColor = UIColor.clear
			self.endDateHourLabel.textColor = UIColor.clear
			self.endDateHourLabel.textColor = UIColor.clear
		}, completion: nil)

		startDateHourLabel.text = hourFormatter.string(from: eventInformations.startDate)
		endDateHourLabel.text = hourFormatter.string(from: eventInformations.endDate)
		
		let dayFormatter = DateFormatter()
		
		if isAMPM {
			dayFormatter.locale = Locale(identifier:  "en_US")
		} else {
			dayFormatter.locale = Locale(identifier:  "de_DE")
		}
		
		dayFormatter.dateStyle = .short
		dayFormatter.timeStyle = .none
		
		UIView.animate(withDuration: duration / 2, delay: 0, options: .curveEaseInOut, animations: {
			self.startDateHourLabel.textColor = UIColor.clear
			self.startDateDayLabel.textColor = UIColor.clear
			self.endDateHourLabel.textColor = UIColor.clear
			self.endDateHourLabel.textColor = UIColor.clear
		}, completion: nil)
		
		startDateDayLabel.text = dayFormatter.string(from: eventInformations.startDate)
		endDateDayLabel.text = dayFormatter.string(from: eventInformations.endDate)
		
		UIView.animate(withDuration: duration / 2, delay: 0, options: .curveEaseInOut, animations: {
			self.startDateHourLabel.textColor = Color.white
			self.startDateDayLabel.textColor = Color.white
			self.endDateHourLabel.textColor = Color.white
			self.endDateHourLabel.textColor = Color.white
		}, completion: nil)
	}
	
	override func awakeFromNib() {
		
		self.eventInformations = EventEditorViewController.getEventsInformations()
		
		if eventInformations.state == .showDetail {
			allDaySwitch.isUserInteractionEnabled = false
			startDateView.isUserInteractionEnabled = false
			endDateView.isUserInteractionEnabled = false
		}
		
		previousIsAllDaySwitchFontStyle = UIFont.boldSystemFont(ofSize: 30) 
		
		self.isAllDayConstraints = [isAllDayTopConstraint,
									isAllDayBottomConstraint,
									isAllDayLeadingConstraint,
									isAllDayTrailingConstraint,
									isAllDayHeightConstraint]
		
		self.isNotAllDayConstraints = [isNotAllDayTopConstraint,
									   isNotAllDayAspectConstraint,
									   isNotAllDayBottomConstraint]
		
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		
		allDaySwitch.layer.cornerRadius = allDaySwitch.frame.height / 2
		allDaySwitch.tintColor = Color.white
		setAllDaySwitchDesign()
		toggleIsAllDaySwitchFont()
		
		mainView.backgroundColor = Color.blue
		mainView.layer.cornerRadius = mainView.frame.height / 2
		mainView.layer.masksToBounds = false
		
		
		setUpDateLabel(animated: false)
    }
	
	func reloadInformations() {
		setUpDateLabel(animated: true)
	}
}
