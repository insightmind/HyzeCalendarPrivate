//
//  SetContactsTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import Contacts

class SetContactsTableViewController: UITableViewController {
	
	let eventInformation = EventManagement.shared.eventInformation
	var searchBar: UISearchBar?
	var search: String = ""
	var searchIsEmail: Bool = false
	let reuseIdentifier = "contactCell"
	var contacts = [CNContact]()
	var addedContacts = [CNContact]()
	var addedEmails = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .none
		self.tableView.backgroundColor = UIColor.clear
		self.setUpAdded()
		
		
		let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
		self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
		self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		switch section {
		case 0:
			return addedContacts.count + addedEmails.count
		default:
			
			contacts = ContactManagement.shared.getContacts(name: search, isFuzzy: true, alreadyAdded: addedContacts)
			
			var faktor = 0
			if searchIsEmail {
				faktor = addedEmails.contains(search) ? 0 : 1
			}
			
			return contacts.count + faktor
		}
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56.0
	}


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactTableViewCell
		switch indexPath.section {
		case 0:
			if indexPath.row < addedContacts.count {
				cell.setContact(addedContacts[indexPath.row], shouldAdd: true)
			} else {
				cell.setEmail(email: addedEmails[indexPath.row - addedContacts.count], shouldAdd: true)
			}
			
		default:
			if searchIsEmail && !addedEmails.contains(search) {
				if indexPath.row == 0 {
					cell.setEmail(email: search)
				} else {
					cell.setContact(contacts[indexPath.row - 1], shouldAdd: false)
				}
			} else {
				cell.setContact(contacts[indexPath.row], shouldAdd: false)
			}
		}
		cell.setTableView = self
        return cell
    }
	
	func add(_ contact: CNContact) {
		self.addedContacts.append(contact)
		self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}
	
	func add(_ email: String) {
		self.addedEmails.append(email)
		self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}
	
	func remove(_ contact: CNContact) {
		for i in 0..<addedContacts.count {
			if contact.identifier == addedContacts[i].identifier {
				addedContacts.remove(at: i)
				break
			}
		}
		self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}
	
	func remove(_ email: String) {
		for i in 0..<addedContacts.count {
			if email == addedEmails[i] {
				addedContacts.remove(at: i)
				break
			}
		}
		self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}
	
	func searchDidChange(_ search: String) {
		self.search = search
		self.searchIsEmail = ContactManagement.shared.isValidEmail(email: search)
		self.tableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
	}
	
	func setUpAdded() {
		guard let participants = eventInformation.participants else {
			return
		}
		for participant in participants {
			if let contact = ContactManagement.shared.getContact(for: participant.contactPredicate) {
				addedContacts.append(contact)
			} else {
				var email = participant.url.absoluteString
				let range = email.startIndex...email.index(email.startIndex, offsetBy: 6)
				email.removeSubrange(range)
				addedEmails.append(email)
			}
		}
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
