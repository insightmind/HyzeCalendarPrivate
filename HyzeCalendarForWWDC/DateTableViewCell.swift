//
//  DateTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/28/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum RecurrenceEndType {
	case date
	case ocurrence
	case none
}

class DateTableViewCell: UITableViewCell {
	
	var tableView: RecurrenceTableViewController?
	var firstTime = true

	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topViewLabel: UILabel!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var timesPickerView: UIPickerView!
	@IBOutlet weak var timesView: UIView!
	@IBOutlet weak var timesLabel: UILabel!
	@IBOutlet weak var timesButtonView: UIView!
	@IBOutlet weak var timesButton: UIButton!
	@IBOutlet weak var yearView: UIView!
	@IBOutlet weak var yearLabel: UILabel!
	@IBOutlet weak var yearButtonView: UIView!
	@IBOutlet weak var yearButton: UIButton!
	@IBOutlet weak var selectStackView: UIStackView!
	
	@IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var timesPickerViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var selectStackViewHeightConstraint: NSLayoutConstraint!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.clear
		cellView.layer.cornerRadius = topView.bounds.height / 2
		cellView.layer.masksToBounds = true
        // Initialization code
		
    }
	@IBAction func selectYear(_ sender: UIButton) {
		if tableView?.recurrenceEndType == .none {
			selectType(.date)
		} else {
			selectType(.none)
		}
		UIView.animate(withDuration: 0.3) {
			self.layoutIfNeeded()
		}
	}
	
	@IBAction func selectTimes(_ sender: UIButton) {
		if tableView?.recurrenceEndType == .none {
			selectType(.ocurrence)
		} else {
			selectType(.none)
		}
		UIView.animate(withDuration: 0.3) {
			self.layoutIfNeeded()
		}
	}
	override func layoutSubviews() {
		if firstTime {
			selectType(tableView!.recurrenceEndType)
			firstTime = false
		}
	}
	
	func selectType(_ type: RecurrenceEndType) {
		switch type {
		case .date:
			selectStackViewHeightConstraint.constant = 56
			timesView.isHidden = true
			yearView.isHidden = false
			timesPickerViewHeightConstraint.constant = 0
			timesPickerView.isHidden = true
			datePickerHeightConstraint.constant = 100
			datePicker.isHidden = false
		case .ocurrence:
			selectStackViewHeightConstraint.constant = 56
			timesView.isHidden = false
			yearView.isHidden = true
			timesPickerViewHeightConstraint.constant = 100
			timesPickerView.isHidden = false
			datePickerHeightConstraint.constant = 0
			datePicker.isHidden = true
		case .none:
			selectStackViewHeightConstraint.constant = 112
			timesView.isHidden = false
			yearView.isHidden = false
			timesPickerViewHeightConstraint.constant = 0
			timesPickerView.isHidden = true
			datePickerHeightConstraint.constant = 0
			datePicker.isHidden = true
		}
		tableView?.recurrenceEndType = type
		tableView?.updateCellHeights()
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
