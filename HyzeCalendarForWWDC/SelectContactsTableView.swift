//
//  SelectContactsTableView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/21/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SelectContactsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
	
	let eventInformation = EManagement.eventInformation
	
	let reuseIdentifier = "contactsCell"
	
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		
		self.allowsSelection = false
		
		self.delegate = self
		self.dataSource = self
		
		let cell = UINib(nibName: "ContactTableViewCell", bundle: nil)
		self.register(cell, forCellReuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.allowsSelection = false
		
		self.delegate = self
		self.dataSource = self
		
		let cell = UINib(nibName: "ContactTableViewCell", bundle: nil)
		self.register(cell, forCellReuseIdentifier: reuseIdentifier)
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let count = eventInformation.participants?.count {
			return count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ContactTableViewCell
		cell.setContact(eventInformation.participants![indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56
	}
}
