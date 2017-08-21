//
//  ContactTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class ContactTableViewCell: UITableViewCell {
	
	var contact: EKParticipant?

	@IBOutlet weak var contactLabel: UILabel!
	@IBOutlet weak var contactView: UIView!
	@IBOutlet weak var contactImageView: UIImageView!
	@IBOutlet weak var contactDeleteView: UIView!
	@IBOutlet weak var contactDeleteButton: UIButton!
	
	fileprivate func setUpContactDeleteButton() {
		self.contactDeleteView.layer.cornerRadius = self.contactDeleteView.bounds.width / 2
		self.contactDeleteView.backgroundColor = Color.red
		let image = #imageLiteral(resourceName: "ic_remove").withRenderingMode(.alwaysTemplate)
		self.contactDeleteButton.setImage(image, for: .normal)
		self.contactDeleteButton.tintColor = Color.white
		
		self.contactDeleteView.layer.shadowPath = UIBezierPath(roundedRect: contactDeleteView.bounds, cornerRadius: contactDeleteView.bounds.width / 2).cgPath
		self.contactDeleteView.layer.shadowColor = self.contactDeleteView.backgroundColor?.cgColor
		self.contactDeleteView.layer.shadowRadius = 5
		self.contactDeleteView.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.contactDeleteView.layer.shadowOpacity = 0.8
	}
	
	fileprivate func setUpContactImageView() {
		self.contactImageView.layer.cornerRadius = self.contactImageView.bounds.width / 2
		self.contactImageView.backgroundColor = Color.red
		self.contactImageView.layer.shadowPath = UIBezierPath(roundedRect: contactImageView.bounds, cornerRadius: contactImageView.bounds.width / 2).cgPath
		self.contactImageView.layer.shadowColor = self.contactImageView.backgroundColor?.cgColor
		self.contactImageView.layer.shadowRadius = 5
		self.contactImageView.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.contactImageView.layer.shadowOpacity = 0.8
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		
		self.contactLabel.textColor = Color.white
		
		
		setUpContactDeleteButton()
		setUpContactImageView()
		
		
    }
	
	func setContact(_ participant: EKParticipant) {
		self.contact = participant
		self.contactLabel.text = contact?.name
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
