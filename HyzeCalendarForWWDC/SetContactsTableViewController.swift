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
	let reuseIdentifier = "contactCell"
	var contacts = [CNContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .none
		self.tableView.backgroundColor = Color.blue

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		
		let start = DispatchTime.now()
		contacts = CManagement.getContacts(name: search, isFuzzy: true)
		let end = DispatchTime.now()
		
		let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
		let timeInterval = Double(nanoTime) / 1_000_000_000
		print("Elapsed Time for search: \(timeInterval)")
		
        return contacts.count
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56.0
	}


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactTableViewCell
		let contact = contacts[indexPath.row]
		cell.contactLabel.text = "\(contact.familyName), \(contact.givenName)"
		if let data = contact.imageData {
			let image = UIImage(data: data)
			cell.layer.shadowColor = UIColor.black.cgColor
			cell.contactImageView.image = image
		} else {
			let image = #imageLiteral(resourceName: "ic_account_circle").withRenderingMode(.alwaysTemplate)
			cell.contactImageView.image = image
		}
		cell.isAdded = true
        return cell
    }
	
	func searchDidChange(_ search: String) {
		self.search = search
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
