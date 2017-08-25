//
//  SetRecurrenceTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/23/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SetRecurrenceTableViewCell: UITableViewCell {

	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var mainView: UITableView!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.clear
		self.topView.backgroundColor = UIColor.clear
		self.labelView.backgroundColor = Color.lightBlue
		self.mainView.backgroundColor = Color.blue
		self.topView.layer.cornerRadius = self.labelView.bounds.height / 2
		self.topView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
