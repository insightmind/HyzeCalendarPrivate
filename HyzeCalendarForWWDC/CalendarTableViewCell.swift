//
//  CalendarTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/18/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class CalendarTableViewCell: UITableViewCell {

	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var colorView: UIView!
	@IBOutlet weak var selectButton: UIView!
	@IBOutlet weak var arrowButton: UIButton!
	
	var eventInformation = EManagement.eventInformation
	var calendar: EKCalendar? = nil
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.colorView.layer.cornerRadius = self.colorView.bounds.width / 4
		self.colorView.layer.shadowPath = UIBezierPath(roundedRect: colorView.bounds, cornerRadius: colorView.layer.cornerRadius).cgPath
		self.colorView.layer.shadowRadius = 5
		self.colorView.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.colorView.layer.shadowOpacity = 0.8
		
		self.setUpSelectButton()
		
    }
	
	func setCalendarSelectionDesign() {
		if calendar?.calendarIdentifier == eventInformation.calendar?.calendarIdentifier && eventInformation.calendar != nil {
			self.mainView.backgroundColor = Color.blue.withAlphaComponent(0.8)
			self.titleLabel.textColor = Color.white
		} else {
			self.mainView.backgroundColor = Color.white.withAlphaComponent(0.8)
			self.titleLabel.textColor = Color.blue
		}
	}

	@IBAction func setCalendar(_ sender: UIButton) {
		if let viewController = eventInformation.setCalendarPopoverViewController {
			viewController.dismiss(animated: true, completion: {
				if isSettingDefaultCalendar {
					EManagement.EMCalendar = self.calendar
					let userDefault = UserDefaults.standard
					userDefault.set(EManagement.EMCalendar?.calendarIdentifier, forKey: EManagement.userDefaultCalendarIdentifier)
					settingsView?.loadInformations()
					isSettingDefaultCalendar = false
					userDefault.synchronize()
				} else {
					self.eventInformation.calendar = self.calendar
					self.eventInformation.eventEditorTableViewController?.reloadCell(.calendar, onlyInformations: true)
				}
				
			})
		} else {
			fatalError()
		}
	}
	
	fileprivate func setUpSelectButton() {
		self.selectButton.layer.cornerRadius = self.selectButton.bounds.width / 2
		self.selectButton.backgroundColor = Color.red
		let image = #imageLiteral(resourceName: "ic_done").withRenderingMode(.alwaysTemplate)
		self.arrowButton.setImage(image, for: .normal)
		self.arrowButton.tintColor = Color.white
		
		self.selectButton.layer.shadowPath = UIBezierPath(roundedRect: selectButton.bounds, cornerRadius: selectButton.bounds.width / 2).cgPath
		self.selectButton.layer.shadowColor = self.selectButton.backgroundColor?.cgColor
		self.selectButton.layer.shadowRadius = 5
		self.selectButton.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.selectButton.layer.shadowOpacity = 0.8
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
