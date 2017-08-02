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
        
        if selectedETViewCellIndexPath != nil {
            if selectedETViewCellIndexPath == indexPath {
                eventCell.isSelected = true
                visuallySelect(eventCell, duration: 0, indexPath: indexPath)
            }
        }
        eventCell.selectionStyle = .none

		eventCell.sendProperties(event.title, from: event.startDate, to: event.endDate, color: calendarOrange, inherit: nil, isAllDay: event.isAllDay, eventIdentifier: event.eventIdentifier)
        
        return eventCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 25, right: 0)
        tableView.register(ETViewCell.self, forCellReuseIdentifier: cellIdentifier)
        prevEventsCount = events.count
        let (selectedYearID, selectedMonthID, indexPath) = HSelection.selectedDayCellIndex
        guard let selectedIndexPath = indexPath else {
            return 0
        }
        events = EManagement.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item))
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
		
		self.layer.cornerRadius = 20
		self.layer.masksToBounds = true
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = CGSize(width: 0.0, height: -5)
		self.layer.shadowOpacity = 0.5
		
        let (selectedYearID, selectedMonthID, indexPath) = HSelection.selectedDayCellIndex
        
        guard let selectedIndexPath = indexPath else {
            return
        }
        self.prevEventsCount = self.events.count + 1
        self.events = EManagement.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item))
		UIView.animate(withDuration: 0.2) {
			if HSelection.selectedIsOnWeekend! {
				self.backgroundColor = calendarGreen
			} else {
				self.backgroundColor = calendarBlue
				
			}
		}
    }
    
    func reloadView() {
        
        selectedETViewCellIndexPath = nil
        
        let (selectedYearID, selectedMonthID, indexPath) = HSelection.selectedDayCellIndex
        guard let selectedIndexPath = indexPath else {
            fatalError()
        }
        
        calculateColorsForEventsOnSelectedDay(numberOfEvents: EManagement.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item)).count)
        self.beginUpdates()

        self.prevEventsCount = self.numberOfRows(inSection: 0)
        self.events = EManagement.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item))
        var delEventsChangeAt = [IndexPath]()
        for i in 0..<prevEventsCount {
            delEventsChangeAt.append(IndexPath(row: i, section: 0))
        }
        self.deleteRows(at: delEventsChangeAt, with: .fade)
        self.events = EManagement.getEvents(for: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item))
        var addEventsChangeAt = [IndexPath]()
        for i in 0..<events.count {
            addEventsChangeAt.append(IndexPath(row: i, section: 0))
        }
        self.insertRows(at: addEventsChangeAt, with: .fade)
        self.endUpdates()
		
		UIView.animate(withDuration: 0.2) {
			if HSelection.selectedIsOnWeekend! {
				self.backgroundColor = calendarGreen
			} else {
				self.backgroundColor = calendarBlue
				
			}
		}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = tableView.cellForRow(at: indexPath) as? ETViewCell else {
            print("Didn't found cell to highlight")
            return
        }
        
        if indexPath == selectedETViewCellIndexPath {
            return
        }
        if selectedETViewCellIndexPath != nil {
            var access = true
            let prevRow = tableView.cellForRow(at: selectedETViewCellIndexPath!) as? ETViewCell
            if prevRow == nil{
                print("Didn't found cell to unhighlight")
                selectedETViewCellIndexPath = nil
                access = false
            }
            if access {
                visuallyDeSelect(prevRow!, indexPath: indexPath)
            }

        }

        selectedETViewCellIndexPath = indexPath
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
        if viewIsDayView {
            if renDayView != nil {
                renDayView?.selectEventView(with: row.eventIdentifier, duration: duration)
            }
        }
        let otherOption = row.inheritanceBar.bounds.width * 4
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            row.inheritanceBar.bounds = CGRect(x: 5, y: 2, width: otherOption, height: 40)
            row.inheritanceBar.layer.cornerRadius = otherOption / 3
        }, completion: nil)
        
        row.contentView.backgroundColor = calendarWhite.withAlphaComponent(0.15)
    }
    
    func visuallyDeSelect(_ row: ETViewCell, duration: TimeInterval = 0.2, indexPath: IndexPath) {
        
        if viewIsDayView {
            if renDayView != nil {
				renDayView?.deselectEventView(with: row.eventIdentifier, duration: duration)
            }
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            row.inheritanceBar.bounds = CGRect(x: 5, y: 2, width: 2, height: 40)
            row.inheritanceBar.layer.cornerRadius = 0
        }, completion: nil)
        
        row.contentView.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        GlobalETView = self
        updateEvents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateEvents()
    }

}
