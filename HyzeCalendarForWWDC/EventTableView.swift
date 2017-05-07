//
//  EventTableView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/16/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class EventTableView: UITableView, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var superViewController: ViewController!
    
    var cellSize: CGSize!
    
    let cellIdentifier = "Events"
    var events: [EKEvent] = [EKEvent]()
    var prevEventsCount: Int = 1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventsTableViewCell
        
        let event = events[indexPath.row]
        
        if selectedEventsTableViewCellIndexPath != nil {
            if selectedEventsTableViewCellIndexPath == indexPath {
                eventCell.isSelected = true
                visuallySelect(eventCell, duration: 0, indexPath: indexPath)
            }
        }
        
        eventCell.selectionStyle = .none

        eventCell.sendProperties(event.title, from: event.startDate, to: event.endDate, color: eventsColorsOnSelectedDate[indexPath.row], inherit: nil, isAllDay: event.isAllDay)
        
        return eventCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(EventsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        prevEventsCount = events.count
        events = EManagement.getEvents(for: HSelection.selectedTime.conformToDate())
        if events.count < 3 {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        return events.count
    }
    
    func updateEvents() {

        self.prevEventsCount = self.events.count + 1
        self.events = EManagement.getEvents(for: HSelection.selectedTime.conformToDate())
    }
    
    func reloadView() {
        
        selectedEventsTableViewCellIndexPath = nil
        
        calculateColorsForEventsOnSelectedDay(numberOfEvents: EManagement.getEvents(for: HSelection.selectedTime.conformToDate()).count)
        self.beginUpdates()

        self.prevEventsCount = self.numberOfRows(inSection: 0)
        self.events = EManagement.getEvents(for: HSelection.selectedTime.conformToDate())
        var delEventsChangeAt = [IndexPath]()
        for i in 0..<prevEventsCount {
            delEventsChangeAt.append(IndexPath(row: i, section: 0))
        }
        self.deleteRows(at: delEventsChangeAt, with: .fade)
        self.events = EManagement.getEvents(for: HSelection.selectedTime.conformToDate())
        var addEventsChangeAt = [IndexPath]()
        for i in 0..<events.count {
            addEventsChangeAt.append(IndexPath(row: i, section: 0))
        }
        self.insertRows(at: addEventsChangeAt, with: .top)
        
        self.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        guard let row = tableView.cellForRow(at: indexPath) as? EventsTableViewCell else {
            print("Didn't found cell to highlight")
            return
        }
        
        if indexPath == selectedEventsTableViewCellIndexPath {
            visuallyDeSelect(row, indexPath: indexPath)
            selectedEventsTableViewCellIndexPath = nil
        }
        if selectedEventsTableViewCellIndexPath != nil {
            var access = true
            let prevRow = tableView.cellForRow(at: selectedEventsTableViewCellIndexPath!) as? EventsTableViewCell
            if prevRow == nil{
                print("Didn't found cell to unhighlight")
                selectedEventsTableViewCellIndexPath = nil
                access = false
            }
            if access {
                visuallyDeSelect(prevRow!, indexPath: indexPath)
            }

        }

        selectedEventsTableViewCellIndexPath = indexPath
        visuallySelect(row, indexPath: indexPath)

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let row = tableView.cellForRow(at: indexPath) as? EventsTableViewCell else {
            print("Didn't found cell to unhighlight")
            return
        }
        
        visuallyDeSelect(row, indexPath: indexPath)
    }
    
    func visuallySelect(_ row: EventsTableViewCell, duration: TimeInterval = 0.2, indexPath: IndexPath) {
        
        
        if viewIsDayView {
            if renDayView != nil {
                renDayView?.selectEventView(indexPath.row, duration: duration)
            }
        }
        
        let fullWidth = row.contentView.bounds.width * 2
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            row.inheritanceBar.bounds = CGRect(x: 0, y: 0, width: fullWidth, height: 44)
        }, completion: nil)
    }
    
    func visuallyDeSelect(_ row: EventsTableViewCell, duration: TimeInterval = 0.2, indexPath: IndexPath) {
        
        if viewIsDayView {
            if renDayView != nil {
                renDayView?.deselectEventView(indexPath.row, duration: duration)
            }
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            row.inheritanceBar.bounds = CGRect(x: 0, y: 0, width: 5, height: 44)
        }, completion: nil)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        updateEvents()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateEvents()
    }

}
