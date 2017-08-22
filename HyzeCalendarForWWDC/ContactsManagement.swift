//
//  ContactsManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import Contacts

class ContactsManagement {
	
	let CMContactStore: CNContactStore
	
	func getContact(for predicate: NSPredicate) -> CNContact? {
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey]
		do {
			let contact = try CMContactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
			return contact.first
		} catch {
			return nil
		}
	}
	
	func askForPermission() -> Bool {
		var status = false
		if CNContactStore.authorizationStatus(for: .contacts) ==  CNAuthorizationStatus.authorized {
		} else {
			CMContactStore.requestAccess(for: .contacts, completionHandler: {
				(accessGranted: Bool, error: Error?) in
				if accessGranted == true {
					status = true
				}
			})
		}
		return status
	}
	
	init() {
		self.CMContactStore = CNContactStore()
	}
	
}
