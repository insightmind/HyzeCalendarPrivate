//
//  EventsManagement.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/8/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import EventKit
import UIKit


// Basic class for EventKit implementation and functionality
class EventManagement {
	
	var eventInformation = EventEditorEventInformations()
    
    //initialize EKEventStore for EventKit usage
    let EMEventStore: EKEventStore!
    
    //function to convert startTime and endTime from events to an Array of Array of Ints for the EventView
    ///Convert the startTime and endTime of event in ArrayOfEvents to ArrayOfIntArray
    /// - parameter events : array of Events by EventKit
	func convertEventsToTimeArray(_ events: [EKEvent]) -> [String: [Int]] {
        
        //create temporary variable of Dictionary of Array of Int with the eventIdentifier as key
		var eventTimes: [String:[Int]] = [String:[Int]]()
        
        //for every event in the eventsArray
        for event in events {
            
            //create temporary IntArray to store collected data
            //eventTime: [EventType,StartTime,EndTime]
            var eventTime: [Int]!
            
            //check if the events duration is all day long
            if event.isAllDay {
                //set eventTime to EventType: allDay = 0, StartTime: 0min and EndTime: 1440 min
                eventTime = [0,0,1440]

            } else {
                var tip = 1
                
                let startHour = TMCalendar.component(.hour, from: event.startDate)
                let startMinute = TMCalendar.component(.minute, from: event.startDate)
                var startTime = (startHour * 60) + startMinute
                
                let endHour = TMCalendar.component(.hour, from: event.endDate)
                let endMinute = TMCalendar.component(.minute, from: event.endDate)
                var endTime = (endHour * 60) + endMinute
                
                let moreDays = TMCalendar.compare(event.startDate, to: event.endDate, toUnitGranularity: .day)
                
                if moreDays == .orderedAscending {
                    let (selectedYearID, selectedMonthID, indexPath) = HSelection.selectedDayCellIndex
                    
                    guard let selectedIndexPath = indexPath else {
                        fatalError()
                    }
                    
                    if TMCalendar.compare(event.startDate, to: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item), toUnitGranularity: .day) == .orderedSame {
                        startTime = (startHour * 60) + startMinute
                        endTime = 1440
                    } else if TMCalendar.compare(event.endDate, to: TimeManagement.convertToDate(yearID: selectedYearID, monthID: selectedMonthID, dayID: selectedIndexPath.item), toUnitGranularity: .day) == .orderedSame {
                        startTime = 0
                        endTime = (endHour * 60) + endMinute
                    } else {
                        startTime = 0
                        endTime = 1440
                        tip = 0
                    }
                } else {
                    startTime = (startHour * 60) + startMinute
                    endTime = (endHour * 60) + endMinute
                }
                
                if informationMode{
                    print("[INFORMATION] \(startHour * 60) + \(startMinute) = \(startTime)min")
                    print("[INFORMATION] \(endHour * 60) + \(endMinute) = \(endTime)min")
                }
                
                eventTime = [tip,startTime,endTime]
            }
			eventTimes[event.eventIdentifier] = eventTime
        }
        return eventTimes
    }
    
    func getEvents(for date: Date) -> [EKEvent] {
		let predicate = EMEventStore.predicateForEvents(withStart: date, end: date.addingTimeInterval(86399), calendars: nil)
        let events = EMEventStore.events(matching: predicate)
        if informationMode {
			print("[INFORMATION] Events from \(date) to \(date.addingTimeInterval(86339))")
            print("[INFORMATION] Predicate for Events: \(predicate)")
            print("[INFORMATION] Events: \(events)")
            
        }
        return events
    }
    
    func askForPermission() -> Bool {
		var status = false
        if EKEventStore.authorizationStatus(for: .event) ==  EKAuthorizationStatus.authorized {
        } else {
            EMEventStore.requestAccess(to: .event, completion: {
                (accessGranted: Bool, error: Error?) in
                if accessGranted == true {
                    status = true
                }
            })
        }
		return status
    }
    
	func addEvent(_ informations: EventEditorEventInformations) {
        let event = EKEvent(eventStore: EManagement.EMEventStore)
        event.title = informations.title
        event.calendar = EManagement.EMEventStore.defaultCalendarForNewEvents
        if informations.startDate < informations.endDate {
            event.startDate = informations.startDate
            event.endDate = informations.endDate
            event.isAllDay = informations.isAllDay
			event.notes = informations.notes
		} else {
			return
		}
        do {
            try EMEventStore.save(event, span: .thisEvent, commit: true)
            eventsChange = true
        } catch {
            print("Event could not be added")
            eventsChange = false
        }
		self.eventInformation = EventEditorEventInformations()

    }
	
	func getCalendarColor(eventIdentifier: String) -> UIColor? {
		guard let event = EMEventStore.event(withIdentifier: eventIdentifier) else {
			return nil
		}
//		guard let cColor = event.calendar.cgColor else {
//			return nil
//		}
		return UIColor(cgColor: event.calendar.cgColor)
	}
	
	func convertToEventEditorEventInformations(eventIdentifier: String, state: EventEditorState) -> EventEditorEventInformations? {
		guard let event = EMEventStore.event(withIdentifier: eventIdentifier) else {
			return nil
		}
		let informations = EventEditorEventInformations()
		
		informations.state = state
		informations.startDate = event.startDate
		informations.endDate = event.endDate
		informations.isAllDay = event.isAllDay
		informations.title = event.title
		informations.notes = event.notes
		informations.eventIdentifier = eventIdentifier
		
		print(informations)
		
		return informations
	}
    
    init() {
        self.EMEventStore = EKEventStore()
    }
}
