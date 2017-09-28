//
//  SelectContactsTableView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class SelectContactsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
	
	let eventInformation = EventManagement.shared.eventInformation
	var isEditable: Bool = false
	
	var contacts = [String]()
	let reuseIdentifier = "contactsCell"
	
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.allowsSelection = false
		self.layer.masksToBounds = false
		self.isScrollEnabled = false
		
		self.delegate = self
		self.dataSource = self
		
		guard let calendarType = eventInformation.calendar?.type else {
			return
		}
		
		switch calendarType {
		case .birthday, .local, .subscription:
			isEditable = false
		default:
			isEditable = true
		}
		
		let cell = UINib(nibName: "ContactTableViewCell", bundle: nil)
		self.register(cell, forCellReuseIdentifier: reuseIdentifier)
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		self.setUpData()
		return contacts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ContactTableViewCell
		let email = contacts[indexPath.row]
		if let contact = ContactManagement.shared.getContact(email: email) {
			cell.setContact(contact, shouldAdd: true, email: email, isInMainCell: true)
		} else {
			cell.setEmail(email: email, shouldAdd: true, isInMainCell: true)
		}
		cell.tableView = self
		cell.setIsEditable(isEditable)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
	
	func deleteParticipant(_ email: String) {
		for i in 0..<contacts.count {
			if contacts[i] == email {
				contacts.remove(at: i)
				guard let tableView = eventInformation.eventEditorTableViewController else {
					return
				}
				reloadParticipants()
				tableView.reloadCell(.contacts, onlyInformations: true)
				return
			}
		}
	}
	
	func reloadParticipants() {
		var attendees = [EKParticipant]()
		for email in contacts {
			if let attendee = EventManagement.shared.createParticipant(email: email) {
				attendees.append(attendee)
			}
		}
		eventInformation.participants = attendees
	}
	
	func setUpData() {
		guard let participants = eventInformation.participants else {
			return
		}
		var cContacts = [String]()
		for participant in participants {
			var email = participant.url.absoluteString
			if email.contains("mailto:") {
				let mailtoRange = email.startIndex...email.index(email.startIndex, offsetBy: 6)
				email.removeSubrange(mailtoRange)
			}
			cContacts.append(email)
		}
		contacts = cContacts
	}
}
