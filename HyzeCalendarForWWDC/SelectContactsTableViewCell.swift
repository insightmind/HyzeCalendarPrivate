//
//  SelectContactsTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/20/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SelectContactsTableViewCell: UITableViewCell, EventEditorCellProtocol {
	
	var eventInformations: EventEditorEventInformations! = EventManagement.shared.eventInformation
	var isEditable: Bool = false
	
	func reloadInformations() {
		self.contactsTableView.setUpData()
		self.contactsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
		eventInformations = EventManagement.shared.eventInformation
		setUpLayout()
		checkEditable()
		eventInformations.eventEditorTableViewController?.updateContactsCellHeight()
	}
	
	@IBOutlet weak var topView: UIView!
	@IBOutlet weak var labelView: UIView!
	@IBOutlet weak var labelViewTitle: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var topContactView: UIView!
	@IBOutlet weak var addButton: UIView!
	@IBOutlet weak var realAddButton: UIButton!
	@IBOutlet weak var addContactLabel: UILabel!
	@IBOutlet weak var showContactsButton: UIButton!
	@IBOutlet weak var showContactsView: UIView!
	@IBOutlet weak var bottomView: UIView!
	@IBOutlet weak var contactsTableView: SelectContactsTableView!
	@IBOutlet weak var topContactViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
	
	@IBAction func addContact(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "SetContacts", bundle: nil)
		guard let viewController = storyboard.instantiateInitialViewController() else {
			return
		}
		eventInformations.eventEditor?.present(viewController, animated: true, completion: nil)
	}
	
	@IBAction func toggleAllContacts(_ sender: UIButton) {
		eventInformations.showAllContacts = !eventInformations.showAllContacts
		eventInformations.eventEditorTableViewController?.updateContactsCellHeight()
		UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
			self.showContactsButton.transform = CGAffineTransform(rotationAngle: self.eventInformations.showAllContacts ? CGFloat.pi : 2*CGFloat.pi)
		}, completion: nil)
	}
	
	fileprivate func setUpAddButton() {
		self.addButton.layer.cornerRadius = self.addButton.bounds.width / 2
		self.addButton.backgroundColor = Color.red
		let image = #imageLiteral(resourceName: "ic_group_add").withRenderingMode(.alwaysTemplate)
		self.realAddButton.setImage(image, for: .normal)
		self.realAddButton.tintColor = Color.white
		
		self.addButton.layer.shadowPath = UIBezierPath(roundedRect: addButton.bounds, cornerRadius: addButton.bounds.width / 2).cgPath
		self.addButton.layer.shadowColor = self.addButton.backgroundColor?.cgColor
		self.addButton.layer.shadowRadius = 5
		self.addButton.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.addButton.layer.shadowOpacity = 0.8
	}
	
	fileprivate func setUpShowContactsButton() {
		self.showContactsView.layer.cornerRadius = self.showContactsView.bounds.width / 2
		self.showContactsView.backgroundColor = Color.red
		let image = #imageLiteral(resourceName: "ic_keyboard_arrow_down").withRenderingMode(.alwaysTemplate)
		self.showContactsButton.setImage(image, for: .normal)
		self.showContactsButton.tintColor = Color.white
		
		self.showContactsView.layer.shadowPath = UIBezierPath(roundedRect: showContactsView.bounds, cornerRadius: showContactsView.bounds.width / 2).cgPath
		self.showContactsView.layer.shadowColor = self.showContactsView.backgroundColor?.cgColor
		self.showContactsView.layer.shadowRadius = 5
		self.showContactsView.layer.shadowOffset = CGSize(width: 1, height: 3)
		self.showContactsView.layer.shadowOpacity = 0.8
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.backgroundColor = UIColor.clear
		self.topView.layer.cornerRadius = labelView.bounds.height / 2
		self.topView.layer.masksToBounds = true
		
		self.labelView.backgroundColor = Color.lightBlue
		self.mainView.backgroundColor = Color.blue
		self.bottomView.backgroundColor = Color.blue
		self.topContactView.backgroundColor = UIColor.clear
		
		self.setUpAddButton()
		self.setUpShowContactsButton()
		self.setUpLayout()
		
		checkEditable()
		
		layoutIfNeeded()
		
    }
	
	func checkEditable() {
		guard let calendarType = eventInformations.calendar?.type else {
            self.addContactLabel.text = "Select Calendar first"
            self.addButton.isHidden = true
			return
		}
		switch calendarType {
		case .birthday, .local, .subscription:
			isEditable = false
		default:
			isEditable = true
		}
		self.addButton.isHidden = false
		if isEditable {
			self.addContactLabel.text = "add Contacts"
			self.realAddButton.isUserInteractionEnabled = true
			let image = #imageLiteral(resourceName: "ic_person_add").withRenderingMode(.alwaysTemplate)
			self.realAddButton.setImage(image, for: .normal)
		} else {
			self.addContactLabel.text = "unsupported by Calendar"
			self.realAddButton.isUserInteractionEnabled = false
			let image = #imageLiteral(resourceName: "ic_clear").withRenderingMode(.alwaysTemplate)
			self.realAddButton.setImage(image, for: .normal)
		}
	}
	
	func setUpLayout() {
		
		let defaultCellHeight: CGFloat = 55
		
		switch eventInformations.state {
		case .create:
			topContactViewHeightConstraint.constant = defaultCellHeight
			topContactView.isHidden = false
			if let count = eventInformations.participants?.count {
				if count > 2 {
					bottomViewHeightConstraint.constant = defaultCellHeight
					bottomView.isHidden = false
				} else {
					bottomViewHeightConstraint.constant = 0
					bottomView.isHidden = true
				}
			} else {
				bottomViewHeightConstraint.constant = 0
				bottomView.isHidden = true
			}
		case .showDetail:
			topContactViewHeightConstraint.constant = 0
			topContactView.isHidden = true
			if let count = eventInformations.participants?.count {
				if count > 3 {
					bottomViewHeightConstraint.constant = defaultCellHeight
					bottomView.isHidden = false
				} else {
					bottomViewHeightConstraint.constant = 0
					bottomView.isHidden = true
				}
			} else {
				bottomViewHeightConstraint.constant = 0
				bottomView.isHidden = true
			}
		}
		layoutSubviews()
	}
	
	override func layoutIfNeeded() {
		
		super.layoutIfNeeded()
		
		let cornerRadius = self.labelView.bounds.height / 2
		let path = UIBezierPath(roundedRect:topContactView.bounds,
		                        byRoundingCorners:[.bottomLeft, .bottomRight],
		                        cornerRadii: CGSize(width: cornerRadius, height:  cornerRadius))
		
		let maskLayer = CAShapeLayer()
		
		maskLayer.path = path.cgPath
		topContactView.layer.mask = maskLayer
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
