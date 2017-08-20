//
//  SelectContactsTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/20/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SelectContactsTableViewCell: UITableViewCell, EventEditorCell {
	
	var eventInformations: EventEditorEventInformations! = EManagement.eventInformation
	
	func reloadInformations() {
		eventInformations = EManagement.eventInformation
	}
	
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var labelViewTitle: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var topContactView: UIView!
	@IBOutlet weak var addButton: UIView!
	@IBOutlet weak var addContactLabel: UILabel!
	@IBOutlet weak var showContactsButton: UIButton!
	
	@IBAction func addContact(_ sender: UIButton) {
		
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		self.topView.layer.cornerRadius = labelView.bounds.height / 2
		self.topView.layer.masksToBounds = true
		
		self.labelView.backgroundColor = Color.lightBlue
		self.mainView.backgroundColor = Color.blue
		self.topContactView.backgroundColor = UIColor.clear
		
		if eventInformations.participants == nil {
			showContactsButton.isEnabled = false
		}
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
