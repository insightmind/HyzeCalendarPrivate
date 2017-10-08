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
    let freetimeCellReuseIdentifier = "freetimeCell"
    
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func registerCells() {
        let eventNib = UINib(nibName: "ELEventTableViewCell", bundle: nil)
        tableView.register(eventNib, forCellReuseIdentifier: eventCellReuseIdentifier)
        
        let freetimeNib = UINib(nibName: "ELFreetimeTableViewCell", bundle: nil)
        tableView.register(freetimeNib, forCellReuseIdentifier: freetimeCellReuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        registerCells()
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
        fetchEvents()
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellReuseIdentifier) as! ELEventTableViewCell

        // Configure the cell...
        cell.loadEvent(events[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let event = events[indexPath.row]
        if event.isAllDay || !Settings.shared.isEventListRelative {
            return 75
        }
        let start = TimeManagement.getTimeInMinutes(of: event.startDate)
        let end = TimeManagement.getTimeInMinutes(of: event.endDate)
        
        let length = end - start
        let height = length < 90 ? 90 : length
        
        return CGFloat(height)
    }
    
    func reloadList(onlyDesign: Bool = false) {
        if onlyDesign {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        } else {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        
    }

}
