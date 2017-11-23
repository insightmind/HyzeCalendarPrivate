//
//  SelectCalendarTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/16/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SelectCalendarTableViewCell: UITableViewCell, EventEditorCellProtocol {
	
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var headerLabel: UILabel!
	@IBOutlet weak var informationView: UIView!
	@IBOutlet weak var selectButton: UIView!
	@IBOutlet weak var arrowButton: UIButton!
	@IBOutlet weak var selectedCalendarLabel: UILabel!
	@IBOutlet weak var shadowView: UIView!
	@IBOutlet weak var calendarColorView: UIView!
	
	var eventInformations: EventEditorEventInformations!

	@IBAction func selectCalendar(_ sender: UIButton) {
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			let storyBoard = UIStoryboard(name: "SelectCalendar", bundle: nil)
			guard let startDateViewController = storyBoard.instantiateInitialViewController() else {
				return
			}
			startDateViewController.modalTransitionStyle = .coverVertical
			topController.present(startDateViewController, animated: true, completion: nil)
		}
	}
	
	fileprivate func setUpSelectButton() {
		self.selectButton.layer.cornerRadius = self.selectButton.bounds.height / 2
		self.selectButton.backgroundColor = Color.red
		let image = #imageLiteral(resourceName: "ic_edit").withRenderingMode(.alwaysTemplate)
		self.arrowButton.setImage(image, for: .normal)
		self.arrowButton.tintColor = Color.white
        
		self.selectButton.layer.shadowColor = self.selectButton.backgroundColor?.cgColor
		self.selectButton.layer.shadowRadius = 5
		self.selectButton.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.selectButton.layer.shadowOpacity = 0.8
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.eventInformations = EventManagement.shared.eventInformation
		
		self.backgroundColor = UIColor.clear
		self.mainView.layer.cornerRadius = self.labelView.bounds.height / 2
		self.mainView.backgroundColor = UIColor.clear
		self.mainView.layer.masksToBounds = true
		self.shadowView.backgroundColor = UIColor.clear
		
		self.calendarColorView.layer.cornerRadius = self.calendarColorView.bounds.width / 2
		self.calendarColorView.layer.shadowPath = UIBezierPath(roundedRect: calendarColorView.bounds, cornerRadius: calendarColorView.layer.cornerRadius).cgPath
		self.calendarColorView.layer.shadowRadius = 5
		self.calendarColorView.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.calendarColorView.layer.shadowOpacity = 0.8
		
		
		if let title = eventInformations.calendar?.title {
			self.selectedCalendarLabel.text = title
			self.calendarColorView.backgroundColor = UIColor(cgColor: (eventInformations.calendar?.cgColor)!)
		} else {
			if let standardTitle = EventManagement.shared.EMCalendar?.title {
				self.selectedCalendarLabel.text = standardTitle
				self.calendarColorView.backgroundColor = UIColor(cgColor: (EventManagement.shared.EMCalendar?.cgColor)!)
			} else {
				self.selectedCalendarLabel.text = EventManagement.shared.EMEventStore.defaultCalendarForNewEvents?.title
				self.calendarColorView.backgroundColor = UIColor(cgColor: (EventManagement.shared.EMEventStore.defaultCalendarForNewEvents?.cgColor) ?? Color.blue.cgColor)
			}
		}
		self.calendarColorView.layer.shadowColor = self.calendarColorView.backgroundColor?.cgColor
		
		self.labelView.backgroundColor = Color.lightBlue
		self.informationView.backgroundColor = Color.blue
		
		setUpSelectButton()
		
		if eventInformations.state == .showDetail {
			selectButton.isHidden = true
		}
    }

	func reloadInformations() {
		
		eventInformations = EventManagement.shared.eventInformation
		
		UIView.animate(withDuration: 0.3, animations: {
			switch self.eventInformations.state {
			case .create:
				self.selectButton.isHidden = false
			case .showDetail:
				self.selectButton.isHidden = true
			}
		})
		
		
		if let calendar = eventInformations.calendar {
			selectedCalendarLabel.text = calendar.title
            UIView.animate(withDuration: 0.15, animations: {
                self.calendarColorView.backgroundColor = UIColor(cgColor: calendar.cgColor)
            })
			
			calendarColorView.layer.shadowColor = calendarColorView.backgroundColor?.cgColor
		}
	}
	
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
