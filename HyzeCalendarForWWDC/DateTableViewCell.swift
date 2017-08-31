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
	case occurrence
	case none
}

class DateTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
	
	var selectedType: RecurrenceEndType = .none
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 0 {
			return 998
		} else {
			return 1
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
		var string = ""
		if component == 0 {
			string = String(row + 2)
		} else {
			string = "times"
		}
		return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: Color.white])
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

	var tableView: RecurrenceTableViewController?
	@IBOutlet weak var cellView: UIView!
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var topViewLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var selectView: UIView!
	@IBOutlet weak var selectViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var onDateView: UIView!
	@IBOutlet weak var onDateLabel: UIButton!
	@IBOutlet weak var onDateButtonView: UIView!
	@IBOutlet weak var onDateButton: UIButton!
	@IBOutlet weak var afterOccurrencesView: UIView!
	@IBOutlet weak var afterOccurrencesLabel: UIButton!
	@IBOutlet weak var afterOccurrencesButtonView: UIView!
	@IBOutlet weak var afterOccurrencesButton: UIButton!
	@IBOutlet weak var pickerMainView: UIView!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var picker: UIPickerView!
	
	@IBAction func selectDate(_ sender: UIButton) {
		if selectedType != .date {
			selectType(.date)
		} else {
			selectType(.none)
		}
		
	}
	@IBAction func selectOccurrence(_ sender: UIButton) {
		if selectedType != .occurrence {
			selectType(.occurrence)
		} else {
			selectType(.none)
		}
	}
	
	func selectType(_ type: RecurrenceEndType) {
		
		let select = CGAffineTransform(rotationAngle: CGFloat.pi/4)
		let deselect = CGAffineTransform(rotationAngle: 0)
		switch type {
		case .date:
			
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				self.onDateButton.transform = select
				self.afterOccurrencesButton.transform = deselect
				self.layoutIfNeeded()
			}, completion: nil)
			
			selectViewHeightConstraint.constant = 56
			
			afterOccurrencesView.isHidden = true
			picker.isHidden = true
			
			onDateView.isHidden = false
			datePicker.isHidden = false
			
			tableView?.dateCellExpanded = true
			
			
		case .occurrence:
			
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				self.onDateButton.transform = deselect
				self.afterOccurrencesButton.transform = select
				self.layoutIfNeeded()
			}, completion: nil)
			
			selectViewHeightConstraint.constant = 56
			
			onDateView.isHidden = true
			datePicker.isHidden = true
			
			afterOccurrencesView.isHidden = false
			picker.isHidden = false
			
			tableView?.dateCellExpanded = true
			
			
		case .none:
			
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				self.onDateButton.transform = deselect
				self.afterOccurrencesButton.transform = deselect
				self.layoutIfNeeded()
			}, completion: nil)
			
			selectViewHeightConstraint.constant = 112
			onDateView.isHidden = false
			afterOccurrencesView.isHidden = false
			
			datePicker.isHidden = true
			picker.isHidden = true
			
			tableView?.dateCellExpanded = false
		}
		
		UIView.animate(withDuration: 0.3, animations: {
			self.layoutIfNeeded()
		})
		
		tableView?.recurrenceEndType = type
		self.selectedType = type
		tableView?.updateCellHeights()
		
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		backgroundColor = UIColor.clear
		cellView.layer.cornerRadius = topView.bounds.height / 2
		cellView.layer.masksToBounds = true
		
		picker.setValue(Color.white, forKey: "textColor")
		picker.tintColor = Color.white
		picker.dataSource = self
		picker.delegate = self
		
		datePicker.setValue(Color.white, forKey: "textColor")
		datePicker.tintColor = Color.white
		
		setUpButton(onDateButtonView, button: onDateButton, image: #imageLiteral(resourceName: "ic_add"))
		setUpButton(afterOccurrencesButtonView, button: afterOccurrencesButton, image: #imageLiteral(resourceName: "ic_add"))
		
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
