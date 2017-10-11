//
//  DaysOfMonthTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/28/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

enum MonthlyRecurrenceType {
	case each
	case on
}

class DaysOfMonthTableViewCell: UITableViewCell {
	
	var eventInformations = EventManagement.shared.eventInformation
	
	var tableView: RecurrenceTableViewController?
	var selectedType: MonthlyRecurrenceType = .each
	let dataSource = RecurrenceDaysOfMonthPickerView()

	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var selectView: UIView!
	@IBOutlet weak var eachView: UIView!
	@IBOutlet weak var eachViewButtonView: UIView!
	@IBOutlet weak var eachViewButton: UIButton!
	@IBOutlet weak var onView: UIView!
	@IBOutlet weak var onViewButtonView: UIView!
	@IBOutlet weak var onViewButton: UIButton!
	@IBOutlet weak var selectedView: UIView!
	@IBOutlet weak var collectionView: DaysOfMonthCollectionView!
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topViewLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		backgroundColor = UIColor.clear
		cellView.layer.cornerRadius = topView.bounds.height / 2
		cellView.layer.masksToBounds = true
		
		pickerView.dataSource = dataSource
		pickerView.delegate = dataSource
		pickerView.setValue(Color.white, forKey: "textColor")
		pickerView.tintColor = Color.white
		
		
		setUpButton(onViewButtonView, button: onViewButton, image: #imageLiteral(resourceName: "ic_add"))
		setUpButton(eachViewButtonView, button: eachViewButton, image: #imageLiteral(resourceName: "ic_add"))
		
		if let rule = eventInformations.recurrenceRule {
			if rule.daysOfTheMonth != nil {
				selectedType = .each
			} else {
				selectedType = .on
				setPickerView(rule)
			}
		}
		
		selectType(selectedType)
		
		if eventInformations.state == .showDetail {
			pickerView.isUserInteractionEnabled = false
			collectionView.isUserInteractionEnabled = false
			onViewButtonView.isHidden = true
			eachViewButtonView.isHidden = true
		}
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
	
	
	@IBAction func selectEach(_ sender: UIButton) {
		if eventInformations.state == .showDetail { return }
		if selectedType == .each {
			selectType(.on)
		} else {
			selectType(.each)
		}
		
	}
	
	@IBAction func selectOn(_ sender: UIButton) {
		if eventInformations.state == .showDetail { return }
		if selectedType == .on {
			selectType(.each)
		} else {
			selectType(.on)
		}
	}
	
	
	func selectType(_ type: MonthlyRecurrenceType) {
		let selected = CGAffineTransform(rotationAngle: CGFloat.pi/4)
		let deselected = CGAffineTransform(rotationAngle: 0)
		switch type {
		case .each:
			
			collectionView.isHidden = false
			pickerView.isHidden = true
			
			UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				self.eachViewButton.transform = selected
				self.onViewButton.transform = deselected
				self.layoutIfNeeded()
			}, completion: nil)
			
		case .on:
			
			collectionView.isHidden = true
			pickerView.isHidden = false
			
			UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				self.eachViewButton.transform = deselected
				self.onViewButton.transform = selected
				self.layoutIfNeeded()
			}, completion: nil)
			
		}
		tableView?.updateCellHeights()
		selectedType = type
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
