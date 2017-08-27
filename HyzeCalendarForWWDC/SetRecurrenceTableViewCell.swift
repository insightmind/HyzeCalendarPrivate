//
//  SetRecurrenceTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/23/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit


class SetRecurrenceTableViewCell: UITableViewCell, EventEditorCell {
	
	var eventInformations: EventEditorEventInformations! = EManagement.eventInformation
	
	func reloadInformations() {
		return
	}
	

	enum recurrenceType {
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
	var isRecurrenceActive: Bool = false
	var recurrenceRule: EKRecurrenceRule? = nil {
		didSet {
			if recurrenceRule == nil {
				isRecurrenceActive = false
			} else {
				isRecurrenceActive = true
			}
		}
	}
	var selectedRecurrenceType: recurrenceType = .none
	
	@IBAction func deleteRecurrence(_ sender: UIButton) {
		recurrenceRule = nil
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.none)
	}
	
	@IBAction func selectDay(_ sender: UIButton) {
		recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.day)
	}
	@IBAction func selectWeek(_ sender: UIButton) {
		recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.week)
	}
	@IBAction func selectMonth(_ sender: UIButton) {
		recurrenceRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.month)
	}
	@IBAction func selectYear(_ sender: UIButton) {
		recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.year)
	}
	
	func selectCustom() {
		self.setRoundView(predefinedViews, shouldBeRounded: true)
		setDesign(.custom)
	}
	
	func setDesign(_ type: recurrenceType, animated: Bool = true) {
		UIView.animate(withDuration: animated ? 0.4 : 0, animations: {
			
			var transform: CGAffineTransform
			self.setViewColor(self.predefinedViews, color: Color.lightBlue)
			self.customSelection.backgroundColor = Color.blue
			
			if type == .none {
				self.everySelectionButtonView.isHidden = true
				self.everySelection.backgroundColor = Color.blue
			} else {
				self.everySelectionButtonView.isHidden = false
				self.everySelection.backgroundColor = Color.green
			}
			
			switch type {
			case .none:
				transform = CGAffineTransform(rotationAngle: 0)
				self.customSelection.backgroundColor = Color.blue
				self.selectionLabel.text = "No Repeat"
			case .day:
				transform = CGAffineTransform(rotationAngle: 0)
				self.dayView.backgroundColor = Color.green
				self.selectionLabel.text = "Every Day"
			case .week:
				transform = CGAffineTransform(rotationAngle: 0)
				self.weekView.backgroundColor = Color.green
				self.selectionLabel.text = "Every Week"
			case .month:
				transform = CGAffineTransform(rotationAngle: 0)
				self.monthView.backgroundColor = Color.green
				self.selectionLabel.text = "Every Month"
			case .year:
				transform = CGAffineTransform(rotationAngle: 0)
				self.yearView.backgroundColor = Color.green
				self.selectionLabel.text = "Every Year"
			case .custom:
				transform = CGAffineTransform(rotationAngle: 1/4*PI)
				self.customSelection.backgroundColor = Color.green
				self.selectionLabel.text = "Custom"
			}
			
			self.selectedRecurrenceType = type
			self.customSelectionButtonView.transform = transform
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
		}
	}
	
	func setRoundView(_ views: [UIView], shouldBeRounded: Bool) {
		for view in views {
			if shouldBeRounded {
				let path = UIBezierPath(roundedRect:view.bounds,
				                        byRoundingCorners:[.bottomRight, .bottomLeft],
				                        cornerRadii: CGSize(width: 20, height:  20))
				
				let maskLayer = CAShapeLayer()
				
				maskLayer.path = path.cgPath
				view.layer.mask = maskLayer
			} else {
				view.layer.mask = nil
			}
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.clear
		self.topView.layer.cornerRadius = self.labelView.bounds.height / 2
		self.topView.layer.masksToBounds = true
		self.predefinedViewStack.backgroundColor = Color.lightBlue
		self.predefinedViews.append(dayView)
		self.predefinedViews.append(weekView)
		self.predefinedViews.append(monthView)
		self.predefinedViews.append(yearView)
		self.topView.backgroundColor = UIColor.clear
		self.labelView.backgroundColor = Color.lightBlue
		setUpButton(everySelectionButtonView, button: everySelectionButton, image: #imageLiteral(resourceName: "ic_clear"))
		setUpButton(customSelectionButtonView, button: customSelectionButton, image: #imageLiteral(resourceName: "ic_add"))
		setDesign(.none, animated: false)
		
		if eventInformations.state == .showDetail {
			self.customSelection.isHidden = true
			self.predefinedViewStack.isHidden = true
		}
    }

	override func prepareForReuse() {
		self.predefinedViews = []
		self.selectedRecurrenceType = .none
		self.recurrenceRule = nil
	}
    
}
