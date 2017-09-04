//
//  WeekdayTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/28/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class WeekdayTableViewCell: UITableViewCell {
	
	var eventInformations = EventManagement.shared.eventInformation
	
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var firstDayView: UIView!
	@IBOutlet weak var firstDayViewButton: UIButton!
	@IBOutlet weak var secondDayView: UIView!
	@IBOutlet weak var secondDayViewButton: UIButton!
	@IBOutlet weak var thirdDayView: UIView!
	@IBOutlet weak var thirdDayViewButton: UIButton!
	@IBOutlet weak var fourthDayView: UIView!
	@IBOutlet weak var fourthDayViewButton: UIButton!
	@IBOutlet weak var fifthDayView: UIView!
	@IBOutlet weak var fifthDayViewButton: UIButton!
	@IBOutlet weak var sixthDayView: UIView!
	@IBOutlet weak var sixthDayViewButton: UIButton!
	@IBOutlet weak var seventhDayView: UIView!
	@IBOutlet weak var seventhDayViewButton: UIButton!
	@IBOutlet weak var stackView: UIStackView!
	
	var dayViews: [UIView] = []
	var dayViewButtons: [UIButton] = []
	var selectedDays: [EKWeekday] = []
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.clear
		self.cellView.layer.cornerRadius = self.topView.bounds.height / 2
		self.cellView.layer.masksToBounds = true
		setDayViewButtonLabels()
		let freeSpace = stackView.bounds.width / 7 - stackView.bounds.height
		stackView.spacing = freeSpace
    }
	
	func setDayViewButtonLabels() {
		
		dayViews = [firstDayView,
		            secondDayView,
		            thirdDayView,
		            fourthDayView,
		            fifthDayView,
		            sixthDayView,
		            seventhDayView]
		dayViewButtons = [firstDayViewButton,
		                  secondDayViewButton,
		                  thirdDayViewButton,
		                  fourthDayViewButton,
		                  fifthDayViewButton,
		                  sixthDayViewButton,
		                  seventhDayViewButton]
		
		for index in 0..<dayViewButtons.count {
			var number = index + (Selection.shared.weekDayStart.rawValue) + 1
			if number > 7 {
				number -= 7
			}
			let weekDay = ["S", "M", "T", "W", "T", "F", "S"]
			dayViewButtons[index].setTitle(weekDay[number - 1], for: .normal)
		}
	}

	@IBAction func selectFirstDay(_ sender: UIButton) {
		selectDay(0)
	}
	@IBAction func selectSecondDay(_ sender: UIButton) {
		selectDay(1)
	}
	@IBAction func selectThirdDay(_ sender: UIButton) {
		selectDay(2)
	}
	@IBAction func selectFourthDay(_ sender: UIButton) {
		selectDay(3)
	}
	@IBAction func selectFifthDay(_ sender: UIButton) {
		selectDay(4)
	}
	@IBAction func selectSixthDay(_ sender: UIButton) {
		selectDay(5)
	}
	@IBAction func selectSeventhDay(_ sender: UIButton) {
		selectDay(6)
	}
	
	func selectDay(_ dayIndex: Int) {
		var number = dayIndex + Selection.shared.weekDayStart.rawValue + 1
		if number > 7 {
			number -= 7
		}
		guard let weekday = EKWeekday.init(rawValue: number) else { return }
		if let index = selectedDays.index(of: weekday) {
			selectedDays.remove(at: index)
			self.dayViews[dayIndex].layer.shadowPath = UIBezierPath(roundedRect: self.dayViews[dayIndex].bounds, cornerRadius: self.dayViews[dayIndex].layer.cornerRadius).cgPath
			UIView.animate(withDuration: 0.3, animations: {
				self.dayViews[dayIndex].backgroundColor = Color.lightBlue.withAlphaComponent(0)
				self.dayViews[dayIndex].layer.shadowOpacity = 0
			})
		} else {
			selectedDays.append(weekday)
			self.dayViews[dayIndex].layer.shadowPath = UIBezierPath(roundedRect: self.dayViews[dayIndex].bounds, cornerRadius: self.dayViews[dayIndex].layer.cornerRadius).cgPath
			UIView.animate(withDuration: 0.3, animations: {
				self.dayViews[dayIndex].backgroundColor = Color.red
				self.dayViews[dayIndex].layer.shadowOpacity = 0.8
			})
		}
	}
	
	override func layoutIfNeeded() {
		for view in dayViews {
			view.layer.cornerRadius = view.bounds.height / 2
			view.layer.shadowColor = Color.red.cgColor
			view.layer.shadowOffset = CGSize(width: 1, height: 3)
			view.layer.shadowRadius = 5
			view.layer.shadowOpacity = 0
			view.layer.masksToBounds = false
		}
		if let rule = eventInformations.recurrenceRule {
			if rule.frequency == .weekly {
				if let dayOfWeek = rule.daysOfTheWeek {
					for day in dayOfWeek {
						selectDay(day.dayOfTheWeek.rawValue - 1)
					}
				}
			}
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func prepareForReuse() {
		setDayViewButtonLabels()
	}
    
}
