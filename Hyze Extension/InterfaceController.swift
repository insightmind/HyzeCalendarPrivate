//
//  InterfaceController.swift
//  Hyze Extension
//
//  Created by Niklas Bülow on 30.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import WatchKit
import EventKit
import Foundation

class InterfaceController: WKInterfaceController {

    
    @IBOutlet var date: WKInterfaceLabel!
    @IBOutlet var noEventsLabel: WKInterfaceLabel!
    @IBOutlet var eventList: WKInterfaceTable!
    
    let freeDay = "No events"
    
    @IBAction func previousDay() {
        EventManagement.shared.setDay(.previous)
        loadEventList()
        setDate()
    }
    @IBAction func today() {
        EventManagement.shared.setDay(.today)
        loadEventList()
        setDate()
    }
    @IBAction func nextDay() {
        EventManagement.shared.setDay(.next)
        loadEventList()
        setDate()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        loadEventList()
        setDate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func setDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let currentDate = EventManagement.shared.getDate()
        let string = formatter.string(from: currentDate)
        date.setText(string)
    }
    
    func loadEventList() {
        
        //Fetch the events
        let events = EventManagement.shared.fetch()
        
        if events.count == 0 {
            noEventsLabel.setText(freeDay)
        } else {
            noEventsLabel.setText(nil)
        }
        
        self.eventList.setNumberOfRows(events.count, withRowType: "EventRow")
            
        let rowCount = self.eventList.numberOfRows
            
        for index in 0..<rowCount {
            let row = self.eventList.rowController(at: index) as! EventRow
            let title = events[index].title
            row.setTitle(title)
        }
        
        
    }

}
