//
//  MonthsOfYearTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/28/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class MonthsOfYearTableViewCell: UITableViewCell {
	
	var eventInformations = EventManagement.shared.eventInformation
	
	var viewButtons: [UIButton: (UIView, Bool, Int)] = [:]
	var selection: [Int] = []
	
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topViewLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var janView: UIView!
	@IBOutlet weak var janButton: UIButton!
	@IBOutlet weak var febView: UIView!
	@IBOutlet weak var febButton: UIButton!
	@IBOutlet weak var marView: UIView!
	@IBOutlet weak var marButton: UIButton!
	@IBOutlet weak var aprView: UIView!
	@IBOutlet weak var aprButton: UIButton!
	@IBOutlet weak var mayView: UIView!
	@IBOutlet weak var mayButton: UIButton!
	@IBOutlet weak var junView: UIView!
	@IBOutlet weak var junButton: UIButton!
	@IBOutlet weak var julView: UIView!
	@IBOutlet weak var julButton: UIButton!
	@IBOutlet weak var augView: UIView!
	@IBOutlet weak var augButton: UIButton!
	@IBOutlet weak var sepView: UIView!
	@IBOutlet weak var sepButton: UIButton!
	@IBOutlet weak var octView: UIView!
	@IBOutlet weak var octButton: UIButton!
	@IBOutlet weak var novView: UIView!
	@IBOutlet weak var novButton: UIButton!
	@IBOutlet weak var decView: UIView!
	@IBOutlet weak var decButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		backgroundColor = UIColor.clear
		cellView.layer.cornerRadius = topView.bounds.height / 2
		cellView.layer.masksToBounds = true
		
		viewButtons = [janButton: (janView, false, 1),
		               febButton: (febView, false, 2),
		               marButton: (marView, false, 3),
		               aprButton: (aprView, false, 4),
		               mayButton: (mayView, false, 5),
		               junButton: (junView, false, 6),
		               julButton: (julView, false, 7),
		               augButton: (augView, false, 8),
		               sepButton: (sepView, false, 9),
		               octButton: (octView, false, 10),
		               novButton: (novView, false, 11),
		               decButton: (decView, false, 12)]
		
		
		
		for i in viewButtons {
			let (view, _, _) = i.value
			view.layer.cornerRadius = view.bounds.height / 2
			view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
			view.backgroundColor = Color.blue.withAlphaComponent(0)
			view.layer.shadowColor = Color.red.cgColor
			view.layer.shadowOffset = CGSize(width: 1, height: 3)
			view.layer.shadowRadius = 5
			view.layer.shadowOpacity = 0
			view.layer.masksToBounds = false
			if eventInformations.state == .showDetail {
				i.key.isUserInteractionEnabled = false
			}
		}
		
		
    }
	
	override func layoutIfNeeded() {
		guard let monthsOfTheYear = eventInformations.recurrenceRule?.monthsOfTheYear else { return }
		var indexes: [Int] = []
		for months in monthsOfTheYear {
			indexes.append(Int(truncating: months))
		}
		for i in viewButtons {
			let (view, isSelected, index) = i.value
			if indexes.contains(index) {
				selectView(view)
				viewButtons[i.key] = (view, !isSelected, index)
			}
		}
	}
	
	@IBAction func toggleButton(_ sender: UIButton) {
		for i in viewButtons {
			if sender == i.key {
				let newValue = setSelection(i.value)
				viewButtons[i.key] = newValue
				break
			}
		}
	}
	
	func setSelection(_ value: (UIView, Bool, Int)) -> (UIView, Bool, Int) {
		let (view, isSelected, index) = value
		if isSelected {
			deselectView(view)
		} else {
			selectView(view)
		}
		return (view, !isSelected, index)
	}
	
	func selectView(_ view: UIView) {
		view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
		UIView.animate(withDuration: 0.3) {
			view.backgroundColor = Color.red
			view.layer.shadowOpacity = 0.8
		}
		self.bringSubview(toFront: view)
	}
	
	func deselectView(_ view: UIView) {
		view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
		UIView.animate(withDuration: 0.3) {
			view.backgroundColor = Color.blue.withAlphaComponent(0)
			view.layer.shadowOpacity = 0
		}
	}
	
	func getSelectedMonths() -> [NSNumber] {
		var months: [NSNumber] = []
		for i in viewButtons {
			let (_, isSelected, index) = i.value
			if isSelected {
				months.append(NSNumber(integerLiteral: index))
			}
		}
	return months
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
