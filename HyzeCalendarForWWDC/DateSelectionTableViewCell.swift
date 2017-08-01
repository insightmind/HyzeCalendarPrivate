//
//  DateSelectionTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/1/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DateSelectionTableViewCell: UITableViewCell {

	// - MARK: Outlets
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet var startDateLabels: [UILabel]!
	@IBOutlet var endDateLabels: [UILabel]!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		
		mainView.backgroundColor = calendarBlue
		mainView.layer.cornerRadius = mainView.frame.height / 2
		mainView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
