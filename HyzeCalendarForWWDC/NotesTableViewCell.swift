//
//  NotesTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/13/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
	
	var eventInformations: EventEditorEventInformations!
	
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var topView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		self.eventInformations = EventEditorViewController.getEventsInformations()
		self.backgroundColor = UIColor.clear
		
		self.labelView.backgroundColor = Theme.calendarBlue
		self.mainView.backgroundColor = Theme.calendarLightBlue
		
		self.topView.layer.cornerRadius = self.labelView.bounds.height / 2
		self.topView.layer.masksToBounds = true
		
		self.textView.textColor = Theme.calendarWhite
		self.label.textColor = Theme.calendarWhite
		
    }
    
}
