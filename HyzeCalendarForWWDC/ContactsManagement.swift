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
	
	func getContacts(email searchEmail: String, isFuzzy: Bool = false) -> [CNContact] {
		var contacts = [CNContact]()
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactImageDataKey]
		let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
		do {
			try self.CMContactStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
				mainLoop: for email in contact.emailAddresses {
					let singleEmail = String(email.value).lowercased()
					if isFuzzy {
						var count = 0
						let string = singleEmail + " "
						fuzzyLoop: for i in searchEmail.lowercased().characters {
							if string.contains(i) {
								count += 1
								if count == searchEmail.characters.count {
									contacts.append(contact)
									break mainLoop
								}
							} else {
								break fuzzyLoop
							}
						}
						if count == searchEmail.characters.count {
							contacts.append(contact)
							break mainLoop
						}
					} else if singleEmail == searchEmail {
						contacts.append(contact)
						break mainLoop
					}
				}
			})
		} catch let error {
			print(error)
		}
		return contacts
	}
	
	func getContacts(name: String, isFuzzy: Bool = false) -> [CNContact] {
		let searchString = " " + name
		var contacts = [CNContact]()
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactImageDataKey]
		if isFuzzy {
			let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
			do {
				
				try self.CMContactStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
					
					var count = 0
					let string = contact.givenName.lowercased() + " " + contact.familyName.lowercased()
					for i in searchString.lowercased().characters {
						if string.contains(i) {
							count += 1
						} else {
							break
						}
					}
					if count == searchString.characters.count {
						contacts.append(contact)
					}
				})
				
			} catch let error {
				print(error)
			}
			
			return contacts
			
		} else {
			let predicate = CNContact.predicateForContacts(matchingName: name)
			
			do {
				contacts = try CMContactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
			} catch let error {
				print(error)
			}
			return contacts
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
