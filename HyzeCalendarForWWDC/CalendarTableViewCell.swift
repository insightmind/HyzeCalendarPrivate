//
//  CalendarTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/18/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var colorView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.colorView.layer.cornerRadius = self.colorView.bounds.width / 4
		self.colorView.layer.shadowPath = UIBezierPath(roundedRect: colorView.bounds, cornerRadius: colorView.layer.cornerRadius).cgPath
		self.colorView.layer.shadowRadius = 5
		self.colorView.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.colorView.layer.shadowOpacity = 0.8
		
		self.mainView.backgroundColor = Color.blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
