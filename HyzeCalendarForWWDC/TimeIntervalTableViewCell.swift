//
//  TimeIntervallTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/27/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class TimeIntervalTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
	
	var eventInformations = EventManagement.shared.eventInformation
	
	var isOnlyOne: Bool = true
	var selectedRow: Int = 0
	var tableView: RecurrenceTableViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		pickerView.dataSource = self
		pickerView.delegate = self
		pickerView.setValue(Color.white, forKey: "textColor")
		pickerView.tintColor = Color.white
		backgroundColor = UIColor.clear
		mainView.layer.cornerRadius = topView.bounds.height / 2
		mainView.layer.masksToBounds = true
		mainView.backgroundColor = Color.lightBlue
		
		if let rule = eventInformations.recurrenceRule {
			selectedRow = rule.interval - 1
			if rule.interval > 1 {
				isOnlyOne = false
			}
		}
		pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
		
		if eventInformations.state == .showDetail {
			pickerView.isUserInteractionEnabled = false
		}
    }
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		var string: String = ""
		if component == 0 {
			string = String(row + 1)
		} else if component == 1 {
			guard let frequency = tableView?.popover?.selectedFrequency else {
				return nil
			}
			switch frequency {
			case .daily:
				string = isOnlyOne ? "day" : "days"
			case .weekly:
				string = isOnlyOne ? "week" : "weeks"
			case .monthly:
				string = isOnlyOne ? "month" : "months"
			case .yearly:
				string = isOnlyOne ? "year" : "years"
			}
			
		} else {
			return nil
		}
		return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: Color.white])
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if component == 0 {
			if row == 0 {
				self.isOnlyOne = true
			} else {
				self.isOnlyOne = false
			}
		}
		self.selectedRow = row
		pickerView.reloadComponent(1)
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 0 {
			return 999
		} else {
			return 1
		}
	}
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var pickerView: UIPickerView!
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
