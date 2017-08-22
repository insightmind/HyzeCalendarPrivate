//
//  ContactTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit
import Contacts

class ContactTableViewCell: UITableViewCell {
	
	var contact: EKParticipant?
	var tableView: SelectContactsTableView?
	var isAdded: Bool = false

	@IBOutlet weak var contactLabel: UILabel!
	@IBOutlet weak var contactView: UIView!
	@IBOutlet weak var contactImageView: UIImageView!
	@IBOutlet weak var contactDeleteView: UIView!
	@IBOutlet weak var contactDeleteButton: UIButton!
	@IBOutlet weak var mainView: UIView!
	
	@IBAction func deleteContact(_ sender: UIButton) {
		if isAdded {
			guard let checkedTableView = tableView else {
				return
			}
			checkedTableView.deleteParticipant(contact!)
		}
	}
	
	fileprivate func setUpContactDeleteButton() {
		self.contactDeleteView.layer.cornerRadius = self.contactDeleteView.bounds.width / 2
		self.contactDeleteView.backgroundColor = Color.red
		var image: UIImage
		if isAdded {
			image = #imageLiteral(resourceName: "ic_remove").withRenderingMode(.alwaysTemplate)
		} else {
			image = #imageLiteral(resourceName: "ic_person_add").withRenderingMode(.alwaysTemplate)
		}
		self.contactDeleteButton.setImage(image, for: .normal)
		self.contactDeleteButton.tintColor = Color.white
		
		self.contactDeleteView.layer.shadowPath = UIBezierPath(roundedRect: contactDeleteView.bounds, cornerRadius: contactDeleteView.bounds.width / 2).cgPath
		self.contactDeleteView.layer.shadowColor = self.contactDeleteView.backgroundColor?.cgColor
		self.contactDeleteView.layer.shadowRadius = 5
		self.contactDeleteView.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.contactDeleteView.layer.shadowOpacity = 0.8
	}
	
	fileprivate func setUpContactImageView() {
		self.contactView.layer.cornerRadius = self.contactView.bounds.width / 2
		self.contactView.backgroundColor = Color.red
		self.contactView.layer.shadowPath = UIBezierPath(roundedRect: contactImageView.bounds, cornerRadius: contactImageView.bounds.width / 2).cgPath
		self.contactView.layer.shadowColor = self.contactView.backgroundColor?.cgColor
		self.contactView.layer.shadowRadius = 5
		self.contactView.layer.shadowOffset = CGSize(width: 1, height: 2)
		self.contactView.layer.shadowOpacity = 0.8
		let image = #imageLiteral(resourceName: "ic_account_circle").withRenderingMode(.alwaysTemplate)
		self.contactImageView.image = image
		self.contactImageView.tintColor = Color.white
		self.contactImageView.layer.masksToBounds = true
		self.contactImageView.contentMode = .scaleAspectFill
		self.contactImageView.layer.cornerRadius = self.contactImageView.bounds.width / 2
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		self.mainView.backgroundColor = UIColor.clear
		
		self.contactLabel.textColor = Color.white
		
		
		setUpContactDeleteButton()
		setUpContactImageView()
		
		
    }
	
	func setContact(_ participant: EKParticipant) {
		self.contact = participant
		print(participant)
		guard let checkedContact = contact else {
			return
		}
		self.isAdded = true
		let image = #imageLiteral(resourceName: "ic_remove").withRenderingMode(.alwaysTemplate)
		self.contactDeleteButton.setImage(image, for: .normal)
		if let realContact = CManagement.getContact(for: checkedContact.contactPredicate) {
			self.contactLabel.text = "\(realContact.familyName), \(realContact.givenName)"
			if let data = realContact.imageData {
				let image = UIImage(data: data)
				self.contactImageView.image = image
				self.contactView.layer.shadowColor = UIColor.black.cgColor
			}
		} else {
			var email = checkedContact.url.absoluteString
			let range = email.startIndex...email.index(email.startIndex, offsetBy: 6)
			email.removeSubrange(range)
			self.contactLabel.text = email
			self.contactView.layer.shadowColor = Color.red.cgColor
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
