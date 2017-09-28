//
//  ETView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/16/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class ETView: UITableView, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var superViewController: ViewController!
    
    var cellSize: CGSize!
    
    let cellIdentifier = "Events"
    var events: [EKEvent] = [EKEvent]()
    var prevEventsCount: Int = 1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ETViewCell
        
        let event = events[indexPath.row]
        
        if Selection.shared.selectedETViewCellIndexPath != nil {
            if Selection.shared.selectedETViewCellIndexPath == indexPath {
                eventCell.isSelected = true
                visuallySelect(eventCell, duration: 0, indexPath: indexPath)
            }
        }
        eventCell.selectionStyle = .none
		

		eventCell.sendProperties(event.title, from: event.startDate, to: event.endDate, color: Color.orange, inherit: nil, isAllDay: event.isAllDay, eventIdentifier: event.eventIdentifier)
        
        return eventCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		tableView.allowsMultipleSelection = false
		
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        tableView.register(ETViewCell.self, forCellReuseIdentifier: cellIdentifier)
        prevEventsCount = events.count
        let (selectedYearID, selectedMonthID, indexPath) = Selection.shared.selectedDayCellIndex
        guard let selectedIndexPath = indexPath else {
            return 0
        }
        events = EventManagement.shared.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item))
        if events.count < 3 {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
		self.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		
		self.layer.cornerRadius = 20
        return events.count
    }
    
    func updateEvents() {
		self.setDesign()
		
		layer.cornerRadius = 20
		layer.masksToBounds = true
		
        let (selectedYearID, selectedMonthID, indexPath) = Selection.shared.selectedDayCellIndex
        
        guard let selectedIndexPath = indexPath else {
            return
        }
        self.prevEventsCount = self.events.count + 1
        self.events = EventManagement.shared.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item))
    }
    
    func reloadView() {
        
        Selection.shared.selectedETViewCellIndexPath = nil
        
        let (selectedYearID, selectedMonthID, indexPath) = Selection.shared.selectedDayCellIndex
        guard let selectedIndexPath = indexPath else {
            fatalError()
        }
		
		let convertedDate = TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item)
		let localEvents = EventManagement.shared.getEvents(for: convertedDate)
		
        EventManagement.shared.calculateColorsForEventsOnSelectedDay(numberOfEvents: localEvents.count)
        self.beginUpdates()

        self.prevEventsCount = self.numberOfRows(inSection: 0)
        self.events = localEvents
        var delEventsChangeAt = [IndexPath]()
        for i in 0..<prevEventsCount {
            delEventsChangeAt.append(IndexPath(row: i, section: 0))
        }
        self.deleteRows(at: delEventsChangeAt, with: .fade)
        self.events = localEvents
        var addEventsChangeAt = [IndexPath]()
        for i in 0..<events.count {
            addEventsChangeAt.append(IndexPath(row: i, section: 0))
        }
        self.insertRows(at: addEventsChangeAt, with: .fade)
        self.endUpdates()
		self.setDesign()
		
		
    }
	
	func setDesign() {
		UIView.animate(withDuration: 0.2) {
			if Selection.shared.selectedIsToday!  {
				self.backgroundColor = Color.red
			} else if Selection.shared.selectedIsOnWeekend! {
				self.backgroundColor = Color.green
			} else {
				self.backgroundColor = Color.blue
			}
		}
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = tableView.cellForRow(at: indexPath) as? ETViewCell else {
            print("Didn't found cell to highlight")
            return
        }
        
        if indexPath == Selection.shared.selectedETViewCellIndexPath {
			return
        }
        if Selection.shared.selectedETViewCellIndexPath != nil {
            var access = true
            let prevRow = tableView.cellForRow(at: Selection.shared.selectedETViewCellIndexPath!) as? ETViewCell
            if prevRow == nil{
                print("Didn't found cell to unhighlight")
                Selection.shared.selectedETViewCellIndexPath = nil
                access = false
            }
            if access {
                visuallyDeSelect(prevRow!, indexPath: indexPath)
            }

        }
		
		guard let informations = EventManagement.shared.convertToEventEditorEventInformations(eventIdentifier: row.eventIdentifier, state: .showDetail) else {
			return
		}
		EventManagement.shared.selectedEventInformation = informations

        Selection.shared.selectedETViewCellIndexPath = indexPath
        visuallySelect(row, indexPath: indexPath)

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let row = tableView.cellForRow(at: indexPath) as? ETViewCell else {
            print("Didn't found cell to unhighlight")
            return
        }
        
        visuallyDeSelect(row, indexPath: indexPath)
    }
    
    func visuallySelect(_ row: ETViewCell, duration: TimeInterval = 0.2, indexPath: IndexPath) {
        if Settings.shared.viewIsDayView {
            if Settings.shared.renDayView != nil {
                Settings.shared.renDayView?.selectEventView(with: row.eventIdentifier, duration: duration)
            }
        }
		let otherOption = row.inheritanceBar.bounds.width * 4
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            row.inheritanceBar.bounds = CGRect(x: 25, y: 2, width: otherOption, height: 40)
            row.inheritanceBar.layer.cornerRadius = otherOption / 3
			row.contentView.backgroundColor = Color.white.withAlphaComponent(0.15)
        }, completion: nil)
		row.isSelected = true
    }
    
    func visuallyDeSelect(_ row: ETViewCell, duration: TimeInterval = 0.2, indexPath: IndexPath) {
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            row.inheritanceBar.bounds = CGRect(x: 5, y: 2, width: 2, height: 40)
            row.inheritanceBar.layer.cornerRadius = 0
			row.contentView.backgroundColor = UIColor.clear
        }, completion: nil)
		row.isSelected = false
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        EventManagement.shared.ETView = self
        updateEvents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateEvents()
    }

}
