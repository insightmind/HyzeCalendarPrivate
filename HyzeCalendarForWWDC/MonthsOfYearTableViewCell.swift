//
//  MonthsOfYearTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/28/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class MonthsOfYearTableViewCell: UITableViewCell {
	
	var viewButtons: [UIButton: (UIView, Bool)] = [:]
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
		
		viewButtons = [janButton: (janView, false),
		               febButton: (febView, false),
		               marButton: (marView, false),
		               aprButton: (aprView, false),
		               mayButton: (mayView, false),
		               junButton: (junView, false),
		               julButton: (julView, false),
		               augButton: (augView, false),
		               sepButton: (sepView, false),
		               octButton: (octView, false),
		               novButton: (novView, false),
		               decButton: (decView, false)]
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
	
	func setSelection(_ value: (UIView, Bool)) -> (UIView, Bool) {
		let (view, isSelected) = value
		if isSelected {
			deselectView(view)
		} else {
			selectView(view)
		}
		return (view, !isSelected)
	}
	
	func selectView(_ view: UIView) {
		view.layer.cornerRadius = view.bounds.height / 2
		view.layer.masksToBounds = true
		UIView.animate(withDuration: 0.3) {
			view.backgroundColor = Color.red
		}
	}
	
	func deselectView(_ view: UIView) {
		UIView.animate(withDuration: 0.3) {
			view.backgroundColor = Color.lightBlue
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
