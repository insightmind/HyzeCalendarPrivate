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
    
    let basicCellHeight: CGFloat = 80
    var isEmbededInDayView: Bool = false
    
    var events = [EKEvent]()
    
    func fetchEvents() {
        let (yearID, monthID, dayIndexPath) = Selection.shared.selectedDayCellIndex
        guard let dayID = dayIndexPath?.item else { return}
        let day = TimeManagement.convertToDate(yearID: yearID, monthID: monthID, dayID: dayID)
        events = EventManagement.shared.getEvents(for: day)

    }
    
    func configure() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 70, right: 0)
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
        Settings.shared.eventList = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        cell.eventList = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 50
        }
        
        let event = events[indexPath.row]
        
        let start = TimeManagement.getTimeInMinutes(of: event.startDate)
        let end = TimeManagement.getTimeInMinutes(of: event.endDate)
        
        let length = CGFloat(end - start)
        var height = length < basicCellHeight ? basicCellHeight : length
        
        if event.isAllDay || !Settings.shared.isEventListRelative {
            height = basicCellHeight
        }
        if self.tableView.indexPathForSelectedRow == indexPath || event.eventIdentifier == Selection.shared.selectedEventIdentifier {
            height += 40
        }
        return CGFloat(height)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadCellSize()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let configuredCell = cell as? ELEventTableViewCell else { return }
        guard let event = configuredCell.event else { return }
        if event.eventIdentifier == Selection.shared.selectedEventIdentifier {
            cell.setSelected(true, animated: false)
            self.reloadCellSize()
        }
    }
    
    func reloadCellSize() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func reloadList(onlyDesign: Bool = false, animated: Bool = true) {
        if onlyDesign {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ELAddEventTableViewCell else { return }
            cell.updateDesign()
        } else {
            self.tableView.reloadSections(IndexSet(integer: 1), with: animated ? .fade : .none)
        }
    }
}
