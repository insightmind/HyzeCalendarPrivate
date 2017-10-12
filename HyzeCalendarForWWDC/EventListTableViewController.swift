//
//  EventListTableViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 05.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class EventListTableViewController: UITableViewController {
    
    let eventCellReuseIdentifier = "eventCell"
    let addEventCellReuseIdentifier = "addEventCell"
    
    let basicCellHeight: CGFloat = 70
    
    var events = [EKEvent]()
    
    func fetchEvents() {
        let (yearID, monthID, dayIndexPath) = Selection.shared.selectedDayCellIndex
        guard let dayID = dayIndexPath?.item else { return}
        let day = TimeManagement.convertToDate(yearID: yearID, monthID: monthID, dayID: dayID)
        events = EventManagement.shared.getEvents(for: day)

    }
    
    func configure() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 70, right: 0)
    }
    
    func registerCells() {
        let eventNib = UINib(nibName: "ELEventTableViewCell", bundle: nil)
        tableView.register(eventNib, forCellReuseIdentifier: eventCellReuseIdentifier)
        let addEventNib = UINib(nibName: "ELAddEventTableViewCell", bundle: nil)
        tableView.register(addEventNib, forCellReuseIdentifier: addEventCellReuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            return 1
        default:
            fetchEvents()
            return events.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addEventCellReuseIdentifier) as! ELAddEventTableViewCell
            cell.tableView = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellReuseIdentifier) as! ELEventTableViewCell
        // Configure the cell...
        cell.loadEvent(events[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 75
        }
        
        let event = events[indexPath.row]
        if event.isAllDay || !Settings.shared.isEventListRelative {
            return basicCellHeight
        }
        let start = TimeManagement.getTimeInMinutes(of: event.startDate)
        let end = TimeManagement.getTimeInMinutes(of: event.endDate)
        
        let length = CGFloat(end - start)
        let height = length < basicCellHeight ? basicCellHeight : length
            
        return CGFloat(height)
    }
    
    func reloadList(onlyDesign: Bool = false) {
        if onlyDesign {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        } else {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
        
    }

}
