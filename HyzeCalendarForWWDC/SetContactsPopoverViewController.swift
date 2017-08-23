//
//  SetContactsPopoverViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class SetContactsPopoverViewController: UIViewController {

	
	@IBOutlet weak var popoverView: UIView!
	@IBOutlet weak var backgroundBlurView: UIVisualEffectView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var toolbarBlurView: UIVisualEffectView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	var searchBarViewController: SetContactsSearchViewController?
	
	@IBAction func cancel(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveButton(_ sender: UIButton) {
		guard let tableViewController = searchBarViewController?.tableViewController else {
			return
		}
		let addedContacts = tableViewController.addedContacts
		let addedEmails = tableViewController.addedEmails
		
		var attendees = [EKParticipant]()
		
		for contact in addedContacts {
			if let email = contact.emailAddresses.first?.value {
				if let attendee = EManagement.createParticipant(email: String(email)) {
					attendees.append(attendee)
				}
			}
		}
		
		for email in addedEmails {
			if let attendee = EManagement.createParticipant(email: email) {
				attendees.append(attendee)
			}
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.popoverView.layer.cornerRadius = 20
		self.popoverView.backgroundColor = UIColor.clear
		self.popoverView.layer.masksToBounds = true
		self.view.backgroundColor = UIColor.clear
		
		if darkMode {
			backgroundBlurView.effect = UIBlurEffect(style: .dark)
			toolbarBlurView.effect = UIBlurEffect(style: .dark)
		} else {
			backgroundBlurView.effect = UIBlurEffect(style: .light)
			toolbarBlurView.effect = UIBlurEffect(style: .light)
		}
		
		if darkMode {
			self.popoverView.backgroundColor = Color.grey.withAlphaComponent(0.3)
		} else {
			self.popoverView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "embed" {
			if let viewController = segue.destination as? SetContactsSearchViewController {
				self.searchBarViewController = viewController
			}
		}
    }


}
