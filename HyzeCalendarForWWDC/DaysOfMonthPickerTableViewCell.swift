//
//  TableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/30/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DaysOfMonthPickerTableViewCell: UITableViewCell {
	
	let dataSource = RecurrenceDaysOfMonthPickerView()
	var tableView: RecurrenceTableViewController?
	
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
		isSelected = !isSelected
		var transform: CGAffineTransform
		if isSelected {
			enableLabel.setTitle("disable", for: .normal)
			transform = CGAffineTransform(rotationAngle: PI/4)
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
		
		UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
			self.enableButton.transform = transform
			self.layoutIfNeeded()
		}, completion: nil)
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
    }
    
}
