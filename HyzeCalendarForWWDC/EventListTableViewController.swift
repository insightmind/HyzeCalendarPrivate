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
        print(events.count)
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
            return 100
        }
        let start = TimeManagement.getTimeInMinutes(of: event.startDate)
        let end = TimeManagement.getTimeInMinutes(of: event.endDate)
        
        let length = end - start
        let height = length < 100 ? 100 : length
        
        return CGFloat(height)
    }
    
    func reloadList() {
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
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
