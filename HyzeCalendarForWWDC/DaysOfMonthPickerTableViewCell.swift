//
//  TableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/30/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class DaysOfMonthPickerTableViewCell: UITableViewCell {
	
	var eventInformations = EventManagement.shared.eventInformation
	let dataSource = RecurrenceDaysOfMonthPickerView()
	var tableView: RecurrenceTableViewController?
	
	var isLaunch = true
	
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var enableView: UIView!
	@IBOutlet weak var enableLabel: UIButton!
	@IBOutlet weak var enableButtonView: UIView!
	@IBOutlet weak var enableButton: UIButton!
	@IBOutlet weak var pickerView: UIPickerView!

	@IBAction func toggleSelection(_ sender: UIButton) {
		setSelection(!isSelected)
	}
	
	func setSelection(_ isSelected: Bool, animated: Bool = true) {
		setUpButton(enableButtonView, button: enableButton, image: #imageLiteral(resourceName: "ic_add"))
		var transform: CGAffineTransform
		if isSelected {
			enableLabel.setTitle("disable", for: .normal)
			transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
			pickerView.isHidden = false
			tableView?.daysOfMonthPickerExpanded = true
			tableView?.updateCellHeights()
		} else {
			enableLabel.setTitle("enable", for: .normal)
			transform = CGAffineTransform(rotationAngle: 0)
			pickerView.isHidden = true
			tableView?.daysOfMonthPickerExpanded = false
			tableView?.updateCellHeights()
		}
		self.isSelected = isSelected
		UIView.animate(withDuration: animated ? 0.6 : 0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
			self.enableButton.transform = transform
			self.layoutIfNeeded()
		}, completion: nil)
	}
	
	func setPickerView(_ rule: EKRecurrenceRule) {
		guard let position = rule.setPositions?.first else { return }
		let num = Int(truncating: position)
		switch num {
		case 1...5:
			pickerView.selectRow(num - 1, inComponent: 0, animated: false)
		case -1:
			pickerView.selectRow(5, inComponent: 0, animated: false)
		default:
			return
		}
		guard let daysOfTheWeek = rule.daysOfTheWeek else { return }
		if daysOfTheWeek.count == 1 {
			guard let first = daysOfTheWeek.first else { return }
			let day = first.dayOfTheWeek.rawValue
			pickerView.selectRow(day - 1, inComponent: 1, animated: false)
		} else if daysOfTheWeek.count == 2 {
			pickerView.selectRow(9, inComponent: 1, animated: false)
		} else if daysOfTheWeek.count == 5 {
			pickerView.selectRow(8, inComponent: 1, animated: false)
		} else {
			pickerView.selectRow(7, inComponent: 1, animated: false)
		}
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		backgroundColor = UIColor.clear
		cellView.layer.cornerRadius = topView.bounds.height / 2
		cellView.layer.masksToBounds = true
		setUpButton(enableButtonView, button: enableButton, image: #imageLiteral(resourceName: "ic_add"))
		
		pickerView.dataSource = dataSource
		pickerView.delegate = dataSource
		
		if isLaunch {
			isLaunch = false
			guard let rule = eventInformations.recurrenceRule else { return }
			setPickerView(rule)
			self.enableButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
			enableLabel.setTitle("disable", for: .normal)
			self.isSelected = true
		}
		
    }
    
}
