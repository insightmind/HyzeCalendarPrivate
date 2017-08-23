//
//  ContactsManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import Contacts
import EventKit

class ContactsManagement {
	
	let CMContactStore: CNContactStore
	
	func getContact(for predicate: NSPredicate) -> CNContact? {
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactEmailAddressesKey]
		do {
			let contact = try CMContactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
			return contact.first
		} catch {
			return nil
		}
	}
	
	fileprivate func contains(name: String, contact: CNContact) -> Bool {
		var count = 0
		let string = contact.givenName.lowercased() + " " + contact.familyName.lowercased()
		for i in name.lowercased().characters {
			if string.contains(i) {
				count += 1
				continue
			} else {
				break
			}
		}
		if count == name.characters.count {
			return true
		}
		return false
	}
	
	fileprivate func contains(email: String, contact: CNContact) -> Bool {
		mainLoop: for personsEmail in contact.emailAddresses {
			let singleEmail = String(personsEmail.value).lowercased()
			var count = 0
			let string = singleEmail + " "
			fuzzyLoop: for i in email.lowercased().characters {
				if string.contains(i) {
					count += 1
					continue fuzzyLoop
				} else {
					break fuzzyLoop
				}
			}
			if count == email.characters.count {
				return true
			}
		}
		return false
	}
	
	func isValidEmail(email:String) -> Bool {
		// print("validate calendar: \(testStr)")
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: email)
	}
	
	func getContact(email: String) -> CNContact? {
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactImageDataKey]
		let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
		var cContact: CNContact? = nil
		do {
			try self.CMContactStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
				if !contact.emailAddresses.isEmpty {
					for i in contact.emailAddresses {
						if String(i.value) == email {
							cContact = contact
						}
					}
				}
			})
			return cContact
		} catch let error {
			print(error)
			return nil
		}
	}
	
	func getContacts(name: String, isFuzzy: Bool = false, alreadyAdded: [CNContact]) -> [CNContact] {
		let searchString = " " + name
		var contacts = [CNContact]()
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactImageDataKey]
		if isFuzzy {
			let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
			do {
				
				try self.CMContactStore.enumerateContacts(with: request, usingBlock: { (contact, cursor) in
					
					if !contact.emailAddresses.isEmpty && !alreadyAdded.contains(contact) {
						let isInName = self.contains(name: searchString, contact: contact)
						let isInEmail = self.contains(email: searchString, contact: contact)
						
						if isInName || isInEmail {
							contacts.append(contact)
						}
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
