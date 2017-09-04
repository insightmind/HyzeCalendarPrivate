//
//  SetRecurrenceTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/23/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit


class SetRecurrenceTableViewCell: UITableViewCell, EventEditorCellProtocol {
	
	var eventInformations: EventEditorEventInformations! = EventManagement.shared.eventInformation
	
	func reloadInformations() {
		
		let type = analyseRule()
		self.setDesign(type, animated: true)
		
	}
	
	enum RecurrenceType {
		case start
		case none
		case day
		case week
		case month
		case year
		case custom
	}
	
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var everySelection: UIView!
	@IBOutlet weak var everySelectionButtonView: UIView!
	@IBOutlet weak var everySelectionButton: UIButton!
	@IBOutlet weak var customSelection: UIView!
	@IBOutlet weak var customSelectionButtonView: UIView!
	@IBOutlet weak var customSelectionButton: UIButton!
	@IBOutlet weak var dayView: UIView!
	@IBOutlet weak var weekView: UIView!
	@IBOutlet weak var monthView: UIView!
	@IBOutlet weak var yearView: UIView!
	@IBOutlet weak var predefinedViewStack: UIView!
	@IBOutlet weak var selectionLabel: UILabel!
	
	var predefinedViews: [UIView] = []
	var selectedRecurrenceType: RecurrenceType = .start
	
	@IBAction func deleteRecurrence(_ sender: UIButton) {
		eventInformations.recurrenceRule = nil
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.none)
	}
	
	@IBAction func selectDay(_ sender: UIButton) {
		eventInformations.recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.day)
	}
	@IBAction func selectWeek(_ sender: UIButton) {
		eventInformations.recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.week)
	}
	@IBAction func selectMonth(_ sender: UIButton) {
		eventInformations.recurrenceRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.month)
	}
	@IBAction func selectYear(_ sender: UIButton) {
		eventInformations.recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.year)
	}
	
	@IBAction func selectCustom(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "RecurrencePopover", bundle: nil)
		guard let viewController = storyboard.instantiateInitialViewController() else { return }
		eventInformations.eventEditor?.present(viewController, animated: true, completion: nil)
	}
	
	func useCustom() {
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.custom)
	}
	
	func setDesign(_ type: RecurrenceType, animated: Bool = true) {
		UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
			
			if type != self.selectedRecurrenceType {
				self.setViewColor(self.predefinedViews, color: Color.lightBlue.withAlphaComponent(0))
				self.customSelection.backgroundColor = Color.blue
			}
			
			if type == .none {
				self.everySelectionButtonView.isHidden = true
				self.everySelection.backgroundColor = Color.blue
			} else {
				self.everySelectionButtonView.isHidden = false
				self.everySelection.backgroundColor = Color.blue
			}
			
			let image = #imageLiteral(resourceName: "ic_add").withRenderingMode(.alwaysTemplate)
			self.customSelectionButton.setImage(image, for: .normal)
			
			switch type {
			case .none:
				self.selectionLabel.text = "No Repeat"
			case .day:
				self.dayView.backgroundColor = Color.red
				self.dayView.layer.shadowOpacity = 0.8
				self.selectionLabel.text = "Every Day"
			case .week:
				self.weekView.backgroundColor = Color.red
				self.weekView.layer.shadowOpacity = 0.8
				self.selectionLabel.text = "Every Week"
			case .month:
				self.monthView.backgroundColor = Color.red
				self.monthView.layer.shadowOpacity = 0.8
				self.selectionLabel.text = "Every Month"
			case .year:
				self.yearView.backgroundColor = Color.red
				self.yearView.layer.shadowOpacity = 0.8
				self.selectionLabel.text = "Every Year"
			case .custom:
				let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
				self.customSelectionButton.setImage(image, for: .normal)
				self.selectionLabel.text = "Custom"
			default:
				break
			}
			
			self.selectedRecurrenceType = type
		})
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
	
	func setViewColor(_ views: [UIView], color: UIColor) {
		for view in views {
			view.backgroundColor = color
			view.layer.shadowOpacity = 0
		}
	}
	
	func setRoundView(_ views: [UIView], shouldBeRounded: Bool) {
		for view in views {
			if shouldBeRounded {
				view.layer.cornerRadius = view.bounds.height / 2
				view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
				view.layer.shadowColor = Color.red.cgColor
				view.layer.shadowOffset = CGSize(width: 1, height: 3)
				view.layer.shadowRadius = 5
				view.layer.shadowOpacity = 0
			} else {
				view.layer.cornerRadius = 0
			}
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.clear
		self.mainView.backgroundColor = Color.lightBlue
		let cornerRadius = self.labelView.bounds.height / 2
		self.topView.layer.cornerRadius = cornerRadius
		self.topView.layer.masksToBounds = true
		self.everySelection.layer.masksToBounds = false
		self.predefinedViewStack.backgroundColor = Color.lightBlue
		self.predefinedViews.append(dayView)
		self.predefinedViews.append(weekView)
		self.predefinedViews.append(monthView)
		self.predefinedViews.append(yearView)
		self.topView.backgroundColor = UIColor.clear
		self.labelView.backgroundColor = Color.lightBlue
		setUpButton(everySelectionButtonView, button: everySelectionButton, image: #imageLiteral(resourceName: "ic_delete"))
		setUpButton(customSelectionButtonView, button: customSelectionButton, image: #imageLiteral(resourceName: "ic_add"))
		setDesign(.none, animated: false)
		
		if eventInformations.state == .showDetail {
			self.customSelection.isHidden = true
			self.predefinedViewStack.isHidden = true
		}
		
		self.customSelection.layer.cornerRadius = cornerRadius
		self.layoutIfNeeded()
    }
	
	func analyseRule() -> RecurrenceType {
		guard let rule = eventInformations.recurrenceRule else { return .none }

		if rule.recurrenceEnd != nil { return .custom }
		if rule.interval != 1 { return .custom }
		if rule.daysOfTheWeek != nil { return .custom }
		if rule.daysOfTheMonth != nil { return .custom }
		if rule.daysOfTheYear != nil { return .custom }
		if rule.weeksOfTheYear != nil { return .custom }
		if rule.monthsOfTheYear != nil { return .custom }
		if rule.setPositions != nil { return .custom }
		
		switch rule.frequency {
		case .daily:
			return .day
		case .weekly:
			return .week
		case .monthly:
			return .month
		case .yearly:
			return .year
		}
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		
	}

	override func prepareForReuse() {
		self.predefinedViews = []
		self.selectedRecurrenceType = .none
	}
    
}
