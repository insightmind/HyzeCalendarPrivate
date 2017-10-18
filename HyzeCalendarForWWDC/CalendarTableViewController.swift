//
//  CalendarTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/18/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class CalendarTableViewController: UITableViewController {
	
	var calendars: [EKCalendar] = EventManagement.shared.getCalendars(onlyEditable: true, for: .event)
	let reuseIdentifier = "calendar"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.tableView.allowsSelection = false
		self.tableView.separatorStyle = .none
		if Settings.shared.isDarkMode {
			self.tableView.backgroundColor = Color.grey.withAlphaComponent(0.3)
		} else {
			self.tableView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		}
		
		
		let nib = UINib(nibName: "CalendarTableViewCell", bundle: nil)
		
		self.tableView!.register(nib, forCellReuseIdentifier: reuseIdentifier)
		self.tableView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
		
		for i in 0..<calendars.count {
			let calendar = calendars[i]
			let eventInformation = EventManagement.shared.eventInformation
			if calendar.calendarIdentifier == eventInformation.calendar?.calendarIdentifier && eventInformation.calendar != nil{
				let removed = calendars.remove(at: i)
				calendars.insert(removed, at: 0)
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendars.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CalendarTableViewCell

        // Configure the cell...
		let calendar = calendars[indexPath.item]
		cell.colorView.backgroundColor = UIColor(cgColor: calendar.cgColor)
		cell.titleLabel.text = calendar.title
		cell.colorView.layer.shadowColor = cell.colorView.backgroundColor?.cgColor
		cell.calendar = calendar
		cell.backgroundColor = UIColor.clear
		cell.setCalendarSelectionDesign()

        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 56.0
	}

}
