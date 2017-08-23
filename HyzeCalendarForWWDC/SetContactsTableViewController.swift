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
	
	var searchBar: UISearchBar?
	var search: String = ""
	var searchIsEmail: Bool = false
	let reuseIdentifier = "contactCell"
	var contacts = [CNContact]()
	var addedContacts = [CNContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .none
		self.tableView.backgroundColor = UIColor.clear

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
		self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
		self.tableView.contentInset = UIEdgeInsets(top: -56, left: 0, bottom: 56, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		contacts = CManagement.getContacts(name: search, isFuzzy: true)
		
		let faktor = searchIsEmail ? 1 : 0
		
        return contacts.count + faktor
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56.0
	}


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactTableViewCell
		if searchIsEmail {
			if indexPath.row == 0 {
				cell.setEmail(email: search)
			} else {
				cell.setContact(contacts[indexPath.row - 1])
			}
		} else {
			cell.setContact(contacts[indexPath.row])
		}
        return cell
    }
	
	func searchDidChange(_ search: String) {
		self.search = search
		self.searchIsEmail = CManagement.isValidEmail(email: search)
		self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
