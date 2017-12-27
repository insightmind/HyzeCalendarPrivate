//
//  SelectContactsTableView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit
import Contacts

class SelectContactsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
	
	let eventInformation = EventManagement.shared.eventInformation
	var isEditable: Bool = false
	
	var contacts = [EKParticipant]()
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
        
        if eventInformation.state == .showDetail || eventInformation.isReadOnly {
            isEditable = false
        } else {
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
        let participant = contacts[indexPath.row]
        if let contact = ContactManagement.shared.getContact(for: participant.contactPredicate) {
            cell.setContact(contact, shouldAdd: true)
            cell.participant = participant
        } else {
            let email = participant.name ?? "Unknown"
            cell.setEmail(email: email, shouldAdd: true, isInMainCell: true)
        }
		cell.tableView = self
		cell.setIsEditable(isEditable)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
	
	func deleteParticipant(_ email: URL) {
		for i in 0..<contacts.count {
			if contacts[i].url == email {
				contacts.remove(at: i)
				reloadParticipants()
                reloadData()
                guard let tableView = eventInformation.eventEditorTableViewController else { return }
				tableView.reloadCell(.contacts, onlyInformations: true)
                tableView.updateCellHeights()
                return
			}
		}
	}
	
	func reloadParticipants() {
		eventInformation.participants = contacts
        setUpData()
	}
	
	func setUpData() {
        guard let cn = eventInformation.participants else {
            return
        }
		contacts = cn
	}
}
