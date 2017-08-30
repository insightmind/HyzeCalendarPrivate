//
//  DaysOfMonthTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/28/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum MonthlyRecurrenceType {
	case each
	case on
}

class DaysOfMonthTableViewCell: UITableViewCell {
	
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
		
		pickerView.dataSource = dataSource
		pickerView.delegate = dataSource
		pickerView.setValue(Color.white, forKey: "textColor")
		pickerView.tintColor = Color.white
		
		setUpButton(onViewButtonView, button: onViewButton, image: #imageLiteral(resourceName: "ic_add"))
		setUpButton(eachViewButtonView, button: eachViewButton, image: #imageLiteral(resourceName: "ic_add"))
		
		selectType(selectedType)
    }
	@IBAction func selectEach(_ sender: UIButton) {
		if selectedType == .each {
			selectType(.on)
		} else {
			selectType(.each)
		}
		
	}
	
	@IBAction func selectOn(_ sender: UIButton) {
		if selectedType == .on {
			selectType(.each)
		} else {
			selectType(.on)
		}
	}
	
	
	func selectType(_ type: MonthlyRecurrenceType) {
		let selected = CGAffineTransform(rotationAngle: PI/4)
		let deselected = CGAffineTransform(rotationAngle: 0)
		switch type {
		case .each:
			
			collectionView.isHidden = false
			pickerView.isHidden = true
			
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
				self.eachViewButton.transform = selected
				self.onViewButton.transform = deselected
				self.layoutIfNeeded()
			}, completion: nil)
			
		case .on:
			
			collectionView.isHidden = true
			pickerView.isHidden = false
			
			UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
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
