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
	
	let eventInformation = EManagement.eventInformation
	var participant: EKParticipant?
	var contact: CNContact?
	var isContact: Bool = false
	var email: String?
	var name: String?
	var tableView: SelectContactsTableView?
	var setTableView: SetContactsTableViewController?
	var isAdded: Bool = false

	@IBOutlet weak var contactLabel: UILabel!
	@IBOutlet weak var contactView: UIView!
	@IBOutlet weak var contactImageView: UIImageView!
	@IBOutlet weak var contactDeleteView: UIView!
	@IBOutlet weak var contactDeleteButton: UIButton!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var emailLabel: UILabel!
	
	@IBOutlet weak var contactLabelBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var emailLabelTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var contactLabelHeightConstraint: NSLayoutConstraint!
	
	
	
	fileprivate func removeInTableView(_ tableView: SelectContactsTableView) {
		guard let stringEmail = email else {
			return
		}
		tableView.deleteParticipant(stringEmail)
	}
	
	fileprivate func removeInSetTableView(_ tableView: SetContactsTableViewController) {
		if isContact {
			guard let cnContact = contact else {
				return
			}
			tableView.remove(cnContact)
		} else {
			guard let stringEmail = email else {
				return
			}
			tableView.remove(stringEmail)
		}
	}
	
	fileprivate func addInSetTableView(_ tableView: SetContactsTableViewController) {
		if isContact {
			guard let cnContact = contact else {
				return
			}
			tableView.add(cnContact)
		} else {
			guard let stringEmail = email else {
				return
			}
			tableView.add(stringEmail)
		}
	}
	
	@IBAction func toggleContact(_ sender: UIButton) {
		if isAdded {
			if let checkedTableView = tableView {
				removeInTableView(checkedTableView)
				return
			} else if let checkedTableView = setTableView {
				removeInSetTableView(checkedTableView)
			}
		} else {
			if let checkedTableView = setTableView {
				addInSetTableView(checkedTableView)
			}
		}
	}
	
	func updateLayout() {
		if self.emailLabel.text == nil || self.emailLabel.text == "" {
			NSLayoutConstraint.deactivate([emailLabelTopConstraint])
			NSLayoutConstraint.activate([contactLabelBottomConstraint])
			self.layoutSubviews()
		} else {
			NSLayoutConstraint.deactivate([contactLabelBottomConstraint])
			NSLayoutConstraint.activate([emailLabelTopConstraint])
			self.layoutSubviews()
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
		
		if darkMode {
			self.contactLabel.textColor = Color.white
			self.emailLabel.textColor = Color.white.withAlphaComponent(0.7)
		} else {
			self.contactLabel.textColor = Color.blue
			self.emailLabel.textColor = Color.blue.withAlphaComponent(0.7)
		}
		
		switch eventInformation.state {
		case .showDetail:
			self.contactDeleteView.isHidden = true
			self.contactDeleteButton.isUserInteractionEnabled = false
		default:
			self.contactDeleteView.isHidden = false
			self.contactDeleteButton.isUserInteractionEnabled = true
		}
		
		
		
		setUpContactDeleteButton()
		setUpContactImageView()
		
		
    }
	
	fileprivate func setIsAdded(_ shouldAdd: Bool) {
		self.isAdded = shouldAdd
		if shouldAdd {
			let image = #imageLiteral(resourceName: "ic_remove").withRenderingMode(.alwaysTemplate)
			self.contactDeleteButton.setImage(image, for: .normal)
		} else {
			let image = #imageLiteral(resourceName: "ic_person_add").withRenderingMode(.alwaysTemplate)
			self.contactDeleteButton.setImage(image, for: .normal)
		}
	}
	
	fileprivate func setUp(contact: CNContact) {
		self.contactLabel.text = "\(contact.familyName), \(contact.givenName)"
		if let data = contact.imageData {
			let image = UIImage(data: data)
			self.contactImageView.image = image
			self.contactView.layer.shadowColor = UIColor.black.cgColor
		} else {
			let image = #imageLiteral(resourceName: "ic_account_circle").withRenderingMode(.alwaysTemplate)
			self.contactImageView.image = image
			self.contactView.layer.shadowColor = self.contactView.backgroundColor?.cgColor
		}
		guard let mail = contact.emailAddresses.first else {
			return
		}
		self.email = String(mail.value)
		self.emailLabel.text = email
		updateLayout()
		self.contact = contact
	}
	
	func setEmail(email: String, shouldAdd: Bool = false, isInMainCell: Bool = false) {
		setIsAdded(shouldAdd)
		setUp(email: email)
		if isInMainCell {
			self.contactLabel.textColor = Color.white
			self.emailLabel.textColor = Color.white.withAlphaComponent(0.7)
		}
	}
	
	fileprivate func setUp(email stringEmail: String, deleteMailto: Bool = false) {
		var sEmail = stringEmail
		if deleteMailto {
			let range = stringEmail.startIndex...stringEmail.index(stringEmail.startIndex, offsetBy: 6)
			sEmail.removeSubrange(range)
			self.email = sEmail
		} else {
			self.email = sEmail
		}
		self.contactLabel.text = email
		self.emailLabel.text = nil
		self.updateLayout()
		let image = #imageLiteral(resourceName: "ic_account_circle").withRenderingMode(.alwaysTemplate)
		self.contactImageView.image = image
		self.contactView.layer.shadowColor = self.contactView.backgroundColor?.cgColor
		self.isContact = false
	}
	
	func setContact(_ participant: EKParticipant, shouldAdd: Bool = false, email: String? = nil) {
		setIsAdded(shouldAdd)
		self.participant = participant
		if let realContact = CManagement.getContact(for: participant.contactPredicate) {
			setUp(contact: realContact)
			self.isContact = true
		} else {
			let stringEmail = participant.url.absoluteString
			setUp(email: stringEmail, deleteMailto: true)
		}
		if let stringEmail = email {
			self.emailLabel.text = stringEmail
			self.email = stringEmail
		}
		self.contactLabel.textColor = Color.white
		self.emailLabel.textColor = Color.white.withAlphaComponent(0.7)
	}
	
	func setContact(_ contact: CNContact, shouldAdd: Bool = false, email: String? = nil, isInMainCell: Bool = false) {
		setIsAdded(shouldAdd)
		setUp(contact: contact)
		self.isContact = true
		if let stringEmail = email {
			self.emailLabel.text = stringEmail
			self.email = stringEmail
		}
		if isInMainCell {
			self.contactLabel.textColor = Color.white
			self.emailLabel.textColor = Color.white.withAlphaComponent(0.7)
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func prepareForReuse() {
		NSLayoutConstraint.deactivate([contactLabelBottomConstraint])
		NSLayoutConstraint.activate([emailLabelTopConstraint])
		self.layoutSubviews()
		self.isContact = true
		self.emailLabel.text = nil
		self.contactImageView.image = nil
		self.contactView.layer.backgroundColor = Color.red.cgColor
		self.contactLabel.text = nil
		self.contact = nil
		self.contactDeleteButton.imageView?.image = nil
	}
    
}
